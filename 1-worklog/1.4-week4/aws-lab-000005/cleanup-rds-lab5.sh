#!/usr/bin/env bash
set -Eeuo pipefail
export AWS_PAGER=""

STATE=${STATE:-~/rds5-state.env}
if [ ! -f "$STATE" ]; then
  echo "Missing state file: $STATE"
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$STATE"
set +a

REGION=${REGION:-ap-southeast-1}
PROJECT=${PROJECT:-AwsStudyGroup000005RDS}

exists_db() {
  aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$1" >/dev/null 2>&1
}

delete_db() {
  local id="$1"
  if [ -z "${id:-}" ]; then
    return 0
  fi
  if exists_db "$id"; then
    local status
    status=$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$id" --query 'DBInstances[0].DBInstanceStatus' --output text)
    echo "Deleting DB instance $id (status=$status)"
    if [ "$status" != "deleting" ]; then
      aws rds delete-db-instance --region "$REGION" --db-instance-identifier "$id" --skip-final-snapshot --delete-automated-backups >/dev/null || true
    fi
    aws rds wait db-instance-deleted --region "$REGION" --db-instance-identifier "$id" || true
  else
    echo "DB instance $id already deleted"
  fi
}

echo "=== CLEANUP LAB 000005: ${PREFIX:-unknown} in $REGION ==="

if [ -n "${EC2:-}" ]; then
  if aws ec2 describe-instances --region "$REGION" --instance-ids "$EC2" --query 'Reservations[0].Instances[0].State.Name' --output text >/dev/null 2>&1; then
    state=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$EC2" --query 'Reservations[0].Instances[0].State.Name' --output text)
    echo "Terminating EC2 $EC2 (state=$state)"
    if [ "$state" != "terminated" ]; then
      aws ec2 terminate-instances --region "$REGION" --instance-ids "$EC2" >/dev/null || true
      aws ec2 wait instance-terminated --region "$REGION" --instance-ids "$EC2" || true
    fi
  fi
fi

delete_db "${RESTORE_ID:-}"
delete_db "${DB_ID:-}"

if [ -n "${SNAP_ID:-}" ]; then
  if aws rds describe-db-snapshots --region "$REGION" --db-snapshot-identifier "$SNAP_ID" >/dev/null 2>&1; then
    echo "Deleting manual snapshot $SNAP_ID"
    aws rds delete-db-snapshot --region "$REGION" --db-snapshot-identifier "$SNAP_ID" >/dev/null || true
    aws rds wait db-snapshot-deleted --region "$REGION" --db-snapshot-identifier "$SNAP_ID" || true
  else
    echo "Snapshot $SNAP_ID already deleted"
  fi
fi

if [ -n "${DBSUBGROUP:-}" ]; then
  echo "Deleting DB subnet group $DBSUBGROUP"
  aws rds delete-db-subnet-group --region "$REGION" --db-subnet-group-name "$DBSUBGROUP" >/dev/null 2>&1 || true
fi

if [ -n "${ASSOC:-}" ]; then
  echo "Disassociating route table $ASSOC"
  aws ec2 disassociate-route-table --region "$REGION" --association-id "$ASSOC" >/dev/null 2>&1 || true
fi

if [ -n "${IGW:-}" ] && [ -n "${VPC:-}" ]; then
  echo "Deleting internet gateway $IGW"
  aws ec2 detach-internet-gateway --region "$REGION" --internet-gateway-id "$IGW" --vpc-id "$VPC" >/dev/null 2>&1 || true
  aws ec2 delete-internet-gateway --region "$REGION" --internet-gateway-id "$IGW" >/dev/null 2>&1 || true
fi

if [ -n "${RT:-}" ]; then
  echo "Deleting route table $RT"
  aws ec2 delete-route-table --region "$REGION" --route-table-id "$RT" >/dev/null 2>&1 || true
fi

for sg in "${RDSSG:-}" "${EC2SG:-}"; do
  if [ -n "$sg" ]; then
    echo "Deleting security group $sg"
    for n in {1..10}; do
      aws ec2 delete-security-group --region "$REGION" --group-id "$sg" >/dev/null 2>&1 && break
      sleep 10
    done
  fi
done

for subnet in "${DBSUB2:-}" "${DBSUB1:-}" "${PUB:-}"; do
  if [ -n "$subnet" ]; then
    echo "Deleting subnet $subnet"
    aws ec2 delete-subnet --region "$REGION" --subnet-id "$subnet" >/dev/null 2>&1 || true
  fi
done

if [ -n "${VPC:-}" ]; then
  echo "Deleting VPC $VPC"
  aws ec2 delete-vpc --region "$REGION" --vpc-id "$VPC" >/dev/null 2>&1 || true
fi

if [ -n "${KEY:-}" ]; then
  echo "Deleting key pair $KEY"
  aws ec2 delete-key-pair --region "$REGION" --key-name "$KEY" >/dev/null 2>&1 || true
fi

if [ -n "${PROFILE:-}" ] && [ -n "${ROLE:-}" ]; then
  echo "Deleting IAM instance profile $PROFILE and role $ROLE"
  aws iam remove-role-from-instance-profile --instance-profile-name "$PROFILE" --role-name "$ROLE" >/dev/null 2>&1 || true
  aws iam delete-instance-profile --instance-profile-name "$PROFILE" >/dev/null 2>&1 || true
  aws iam detach-role-policy --role-name "$ROLE" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null 2>&1 || true
  aws iam delete-role --role-name "$ROLE" >/dev/null 2>&1 || true
fi

echo "=== CLEANUP VERIFICATION ==="
echo "EC2 tagged resources with Project=$PROJECT:"
aws resourcegroupstaggingapi get-resources --region "$REGION" --tag-filters Key=Project,Values="$PROJECT" --query 'ResourceTagMappingList[].ResourceARN' --output text || true
echo
echo "RDS DB check:"
for id in "${DB_ID:-}" "${RESTORE_ID:-}"; do
  [ -n "$id" ] && aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$id" >/dev/null 2>&1 && echo "Still exists: $id" || true
done
echo "=== CLEANUP_COMPLETE ${PREFIX:-unknown} ==="
