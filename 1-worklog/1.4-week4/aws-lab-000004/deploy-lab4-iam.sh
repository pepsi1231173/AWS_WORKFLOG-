#!/usr/bin/env bash
set -u
AWS_PAGER=""

PREFIX="LAB4-0705"
PROJECT="AwsStudyGroup000004EC2"
IAM_GROUP="$PREFIX-IAM-Governance-Group"
IAM_USER="$PREFIX-demo-user"

log() {
  printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"
}

policy_arn() {
  aws iam list-policies --scope Local --query "Policies[?PolicyName=='$1'].Arn | [0]" --output text
}

create_policy() {
  local name="$1" file="/tmp/$1.json" arn
  cat > "$file" <<JSON
{"Version":"2012-10-17","Statement":[{"Sid":"Lab4DenyExample","Effect":"Deny","Action":"ec2:*","Resource":"*"}]}
JSON
  arn=$(policy_arn "$PREFIX-$name")
  if [ "$arn" = "None" ] || [ -z "$arn" ]; then
    arn=$(aws iam create-policy --policy-name "$PREFIX-$name" --policy-document "file://$file" \
      --tags "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" \
      --query Policy.Arn --output text)
  fi
  aws iam attach-group-policy --group-name "$IAM_GROUP" --policy-arn "$arn" >/dev/null 2>&1 || true
  echo "$PREFIX-$name $arn"
}

log "Create IAM group and policy set"
aws iam create-group --group-name "$IAM_GROUP" >/dev/null 2>&1 || true
aws iam create-user --user-name "$IAM_USER" >/dev/null 2>&1 || true
aws iam add-user-to-group --group-name "$IAM_GROUP" --user-name "$IAM_USER" >/dev/null 2>&1 || true

create_policy RestrictRegion
create_policy LimitEC2Family
create_policy LimitEC2Size
create_policy RestrictEBSVolumeType
create_policy RestrictDeleteByIP
create_policy RestrictDeleteByTime

aws iam list-policies --scope Local --output text | grep "$PREFIX" || true
echo "LAB4_IAM_DONE $PREFIX"
