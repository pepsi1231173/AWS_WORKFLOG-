#!/usr/bin/env bash
set -u
AWS_PAGER=""

REGION="${REGION:-ap-southeast-1}"
PREFIX="${PREFIX:-LAB4-0705}"
PROJECT="${PROJECT:-AwsStudyGroup000004EC2}"
STATE="$HOME/lab4-state.env"

if [ -f "$STATE" ]; then
  # shellcheck disable=SC1090
  source "$STATE"
fi

log() {
  printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"
}

ids_by_tag() {
  local resource="$1"
  aws ec2 "describe-$resource" --region "$REGION" \
    --filters "Name=tag:LabPrefix,Values=$PREFIX" \
    --query "$2" --output text 2>/dev/null | tr '\t' '\n' | sed '/^None$/d;/^$/d'
}

log "Lab 000004 cleanup start for $PREFIX in $REGION"

log "Collect AMI snapshots before deregistering images"
IMAGE_IDS=$(aws ec2 describe-images --region "$REGION" --owners self \
  --filters "Name=tag:LabPrefix,Values=$PREFIX" \
  --query 'Images[].ImageId' --output text 2>/dev/null || true)
IMAGE_SNAPSHOT_IDS=$(aws ec2 describe-images --region "$REGION" --owners self \
  --filters "Name=tag:LabPrefix,Values=$PREFIX" \
  --query 'Images[].BlockDeviceMappings[].Ebs.SnapshotId' --output text 2>/dev/null || true)

log "Terminate lab instances"
INSTANCE_IDS=$(aws ec2 describe-instances --region "$REGION" \
  --filters "Name=tag:LabPrefix,Values=$PREFIX" "Name=instance-state-name,Values=pending,running,stopping,stopped" \
  --query 'Reservations[].Instances[].InstanceId' --output text 2>/dev/null || true)
if [ -n "${INSTANCE_IDS:-}" ]; then
  aws ec2 terminate-instances --region "$REGION" --instance-ids $INSTANCE_IDS >/dev/null 2>&1 || true
  aws ec2 wait instance-terminated --region "$REGION" --instance-ids $INSTANCE_IDS >/dev/null 2>&1 || true
fi

log "Deregister custom AMIs"
for image_id in $IMAGE_IDS; do
  aws ec2 deregister-image --region "$REGION" --image-id "$image_id" >/dev/null 2>&1 || true
done

log "Delete EBS snapshots"
TAGGED_SNAPSHOT_IDS=$(aws ec2 describe-snapshots --region "$REGION" --owner-ids self \
  --filters "Name=tag:LabPrefix,Values=$PREFIX" \
  --query 'Snapshots[].SnapshotId' --output text 2>/dev/null || true)
for snapshot_id in $IMAGE_SNAPSHOT_IDS $TAGGED_SNAPSHOT_IDS "${SNAPSHOT_ID:-}"; do
  if [ -n "$snapshot_id" ] && [ "$snapshot_id" != "None" ]; then
    aws ec2 delete-snapshot --region "$REGION" --snapshot-id "$snapshot_id" >/dev/null 2>&1 || true
  fi
done

log "Delete key pairs"
aws ec2 delete-key-pair --region "$REGION" --key-name "$PREFIX-kp-linux" >/dev/null 2>&1 || true
aws ec2 delete-key-pair --region "$REGION" --key-name "$PREFIX-kp-windows" >/dev/null 2>&1 || true
rm -f "$HOME/$PREFIX-kp-linux.pem" "$HOME/$PREFIX-kp-windows.pem"

log "Delete IAM users, groups, policies, and EC2 role"
IAM_GROUP="${IAM_GROUP:-$PREFIX-IAM-Governance-Group}"
IAM_USER="${IAM_USER:-$PREFIX-demo-user}"
ROLE_NAME="${ROLE_NAME:-$PREFIX-EC2-SSM-Role}"
PROFILE_NAME="${PROFILE_NAME:-$PREFIX-EC2-Profile}"

for policy_arn in $(aws iam list-attached-group-policies --group-name "$IAM_GROUP" --query 'AttachedPolicies[].PolicyArn' --output text 2>/dev/null || true); do
  aws iam detach-group-policy --group-name "$IAM_GROUP" --policy-arn "$policy_arn" >/dev/null 2>&1 || true
done
aws iam remove-user-from-group --group-name "$IAM_GROUP" --user-name "$IAM_USER" >/dev/null 2>&1 || true
aws iam delete-user --user-name "$IAM_USER" >/dev/null 2>&1 || true
aws iam delete-group --group-name "$IAM_GROUP" >/dev/null 2>&1 || true

for policy_arn in $(aws iam list-policies --scope Local --query "Policies[?starts_with(PolicyName, '$PREFIX')].Arn" --output text 2>/dev/null || true); do
  versions=$(aws iam list-policy-versions --policy-arn "$policy_arn" --query 'Versions[?IsDefaultVersion==`false`].VersionId' --output text 2>/dev/null || true)
  for version in $versions; do
    aws iam delete-policy-version --policy-arn "$policy_arn" --version-id "$version" >/dev/null 2>&1 || true
  done
  aws iam delete-policy --policy-arn "$policy_arn" >/dev/null 2>&1 || true
done

aws iam remove-role-from-instance-profile --instance-profile-name "$PROFILE_NAME" --role-name "$ROLE_NAME" >/dev/null 2>&1 || true
aws iam delete-instance-profile --instance-profile-name "$PROFILE_NAME" >/dev/null 2>&1 || true
aws iam detach-role-policy --role-name "$ROLE_NAME" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null 2>&1 || true
aws iam delete-role --role-name "$ROLE_NAME" >/dev/null 2>&1 || true

log "Delete VPC networking resources"
TAGGED_VPC_IDS=$(aws ec2 describe-vpcs --region "$REGION" \
  --filters "Name=tag:LabPrefix,Values=$PREFIX" \
  --query 'Vpcs[].VpcId' --output text 2>/dev/null || true)
SG_VPC_IDS=$(aws ec2 describe-security-groups --region "$REGION" \
  --filters "Name=tag:LabPrefix,Values=$PREFIX" \
  --query 'SecurityGroups[].VpcId' --output text 2>/dev/null || true)
VPC_IDS=$(printf '%s\n%s\n' "$TAGGED_VPC_IDS" "$SG_VPC_IDS" | tr '\t' '\n' | sed '/^$/d' | sort -u)
for vpc_id in $VPC_IDS; do
  eni_ids=$(aws ec2 describe-network-interfaces --region "$REGION" --filters "Name=vpc-id,Values=$vpc_id" --query 'NetworkInterfaces[].NetworkInterfaceId' --output text 2>/dev/null || true)
  if [ -n "$eni_ids" ]; then
    sleep 15
  fi

  for sg_id in $(aws ec2 describe-security-groups --region "$REGION" --filters "Name=vpc-id,Values=$vpc_id" --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text 2>/dev/null || true); do
    aws ec2 delete-security-group --region "$REGION" --group-id "$sg_id" >/dev/null 2>&1 || true
  done

  for igw_id in $(aws ec2 describe-internet-gateways --region "$REGION" --filters "Name=attachment.vpc-id,Values=$vpc_id" --query 'InternetGateways[].InternetGatewayId' --output text 2>/dev/null || true); do
    aws ec2 detach-internet-gateway --region "$REGION" --internet-gateway-id "$igw_id" --vpc-id "$vpc_id" >/dev/null 2>&1 || true
    aws ec2 delete-internet-gateway --region "$REGION" --internet-gateway-id "$igw_id" >/dev/null 2>&1 || true
  done

  for rt_id in $(aws ec2 describe-route-tables --region "$REGION" --filters "Name=vpc-id,Values=$vpc_id" --query 'RouteTables[?Associations[?Main!=`true`]].RouteTableId' --output text 2>/dev/null || true); do
    for assoc_id in $(aws ec2 describe-route-tables --region "$REGION" --route-table-ids "$rt_id" --query 'RouteTables[].Associations[?Main!=`true`].RouteTableAssociationId' --output text 2>/dev/null || true); do
      aws ec2 disassociate-route-table --region "$REGION" --association-id "$assoc_id" >/dev/null 2>&1 || true
    done
    aws ec2 delete-route-table --region "$REGION" --route-table-id "$rt_id" >/dev/null 2>&1 || true
  done

  for subnet_id in $(aws ec2 describe-subnets --region "$REGION" --filters "Name=vpc-id,Values=$vpc_id" --query 'Subnets[].SubnetId' --output text 2>/dev/null || true); do
    aws ec2 delete-subnet --region "$REGION" --subnet-id "$subnet_id" >/dev/null 2>&1 || true
  done

  for sg_id in $(aws ec2 describe-security-groups --region "$REGION" --filters "Name=vpc-id,Values=$vpc_id" --query 'SecurityGroups[?GroupName!=`default`].GroupId' --output text 2>/dev/null || true); do
    aws ec2 delete-security-group --region "$REGION" --group-id "$sg_id" >/dev/null 2>&1 || true
  done

  for rt_id in $(aws ec2 describe-route-tables --region "$REGION" --filters "Name=vpc-id,Values=$vpc_id" --query 'RouteTables[?Associations[0].Main!=`true`].RouteTableId' --output text 2>/dev/null || true); do
    aws ec2 delete-route-table --region "$REGION" --route-table-id "$rt_id" >/dev/null 2>&1 || true
  done

  aws ec2 delete-vpc --region "$REGION" --vpc-id "$vpc_id" >/dev/null 2>&1 || true
done

log "Verification after cleanup"
aws ec2 describe-instances --region "$REGION" --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Reservations[].Instances[].{InstanceId:InstanceId,State:State.Name,Name:Tags[?Key==`Name`]|[0].Value}' --output table
aws ec2 describe-vpcs --region "$REGION" --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Vpcs[].VpcId' --output table
aws ec2 describe-snapshots --region "$REGION" --owner-ids self --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Snapshots[].SnapshotId' --output table
aws ec2 describe-images --region "$REGION" --owners self --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Images[].ImageId' --output table
aws iam list-policies --scope Local --query "Policies[?starts_with(PolicyName, '$PREFIX')].[PolicyName,Arn]" --output table
echo "LAB4_CLEANUP_DONE $PREFIX"
