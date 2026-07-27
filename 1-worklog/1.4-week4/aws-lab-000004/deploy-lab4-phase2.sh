#!/usr/bin/env bash
set -u
AWS_PAGER=""

REGION="ap-southeast-1"
PREFIX="LAB4-0705"
PROJECT="AwsStudyGroup000004EC2"
STATE="$HOME/lab4-state.env"

if [ -f "$STATE" ]; then
  # shellcheck disable=SC1090
  source "$STATE"
fi

log() {
  printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"
}

save_state() {
  {
    echo "REGION='$REGION'"
    echo "PREFIX='$PREFIX'"
    echo "PROJECT='$PROJECT'"
    echo "LINUX_VPC_ID='${LINUX_VPC_ID:-}'"
    echo "WINDOWS_VPC_ID='${WINDOWS_VPC_ID:-}'"
    echo "LINUX_PUBLIC_SUBNET_1='${LINUX_PUBLIC_SUBNET_1:-}'"
    echo "WINDOWS_PUBLIC_SUBNET_1='${WINDOWS_PUBLIC_SUBNET_1:-}'"
    echo "LINUX_SG_ID='${LINUX_SG_ID:-}'"
    echo "WINDOWS_SG_ID='${WINDOWS_SG_ID:-}'"
    echo "LINUX_INSTANCE_ID='${LINUX_INSTANCE_ID:-}'"
    echo "WINDOWS_INSTANCE_ID='${WINDOWS_INSTANCE_ID:-}'"
    echo "SNAPSHOT_ID='${SNAPSHOT_ID:-}'"
    echo "AMI_ID='${AMI_ID:-}'"
    echo "AMI_INSTANCE_ID='${AMI_INSTANCE_ID:-}'"
    echo "ROLE_NAME='${ROLE_NAME:-}'"
    echo "PROFILE_NAME='${PROFILE_NAME:-}'"
    echo "IAM_GROUP='${IAM_GROUP:-}'"
    echo "IAM_USER='${IAM_USER:-}'"
  } > "$STATE"
}

log "Phase 2 start"

if [ -z "${LINUX_INSTANCE_ID:-}" ]; then
  LINUX_INSTANCE_ID=$(aws ec2 describe-instances --region "$REGION" \
    --filters "Name=tag:Name,Values=$PREFIX-Linux-instance" "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query 'Reservations[0].Instances[0].InstanceId' --output text)
fi

if [ -z "${LINUX_SG_ID:-}" ]; then
  LINUX_SG_ID=$(aws ec2 describe-security-groups --region "$REGION" \
    --filters "Name=tag:Name,Values=$PREFIX-Linux-SG" \
    --query 'SecurityGroups[0].GroupId' --output text)
fi

if [ -z "${LINUX_PUBLIC_SUBNET_1:-}" ]; then
  LINUX_PUBLIC_SUBNET_1=$(aws ec2 describe-subnets --region "$REGION" \
    --filters "Name=tag:Name,Values=$PREFIX-Linux-public-1a" \
    --query 'Subnets[0].SubnetId' --output text)
fi

aws ec2 wait instance-running --region "$REGION" --instance-ids "$LINUX_INSTANCE_ID" >/dev/null 2>&1 || true
ROOT_VOLUME_ID=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$LINUX_INSTANCE_ID" \
  --query 'Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId' --output text)

SNAPSHOT_ID=$(aws ec2 create-snapshot --region "$REGION" --volume-id "$ROOT_VOLUME_ID" \
  --description "$PREFIX Linux root volume snapshot" \
  --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$PREFIX-Linux-root-snapshot},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
  --query SnapshotId --output text)

AMI_ID=$(aws ec2 create-image --region "$REGION" --instance-id "$LINUX_INSTANCE_ID" \
  --name "$PREFIX-Linux-custom-ami-$(date +%H%M%S)" --description "$PREFIX custom AMI from Linux lab instance" --no-reboot \
  --tag-specifications "ResourceType=image,Tags=[{Key=Name,Value=$PREFIX-Linux-custom-AMI},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
  --query ImageId --output text)
aws ec2 create-tags --region "$REGION" --resources "$AMI_ID" \
  --tags "Key=Name,Value=$PREFIX-Linux-custom-AMI" "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" >/dev/null

sleep 45
AMI_STATE=$(aws ec2 describe-images --region "$REGION" --image-ids "$AMI_ID" --query 'Images[0].State' --output text 2>/dev/null || echo pending)
if [ "$AMI_STATE" = "available" ] && [ -n "${LINUX_PUBLIC_SUBNET_1:-}" ] && [ -n "${LINUX_SG_ID:-}" ]; then
  AMI_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI_ID" --instance-type t3.micro \
    --subnet-id "$LINUX_PUBLIC_SUBNET_1" --security-group-ids "$LINUX_SG_ID" \
    --iam-instance-profile Name="${PROFILE_NAME:-$PREFIX-EC2-Profile}" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-From-custom-AMI},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    "ResourceType=volume,Tags=[{Key=Name,Value=$PREFIX-AMI-instance-root},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Instances[0].InstanceId --output text)
else
  AMI_INSTANCE_ID="${AMI_INSTANCE_ID:-}"
fi

save_state
echo "ROOT_VOLUME_ID=$ROOT_VOLUME_ID"
echo "SNAPSHOT_ID=$SNAPSHOT_ID"
echo "AMI_ID=$AMI_ID"
echo "AMI_STATE=$AMI_STATE"
echo "AMI_INSTANCE_ID=${AMI_INSTANCE_ID:-}"
echo "LAB4_PHASE2_DONE $PREFIX"
