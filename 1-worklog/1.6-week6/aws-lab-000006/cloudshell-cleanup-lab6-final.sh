cat > fcj_lab6_cleanup_final.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
REGION="ap-southeast-1"
LAB_TAG_KEY="Workshop"
LAB_TAG_VALUE="FCJ-ASG-Lab-000006"
ASG_NAME="FCJ-Management-ASG"
LB_NAME="FCJ-Management-LB"
TG_NAME="FCJ-Management-TG"
LT_NAME="FCJ-Management-template"
AMI_NAME="FCJ-Management-AMI"
KEY_NAME="fcj-key-rerun"
DB_ID="fcj-management-db-instance"
DB_SUBNET_GROUP="FCJ-Management-Subnet-Group"
if [[ -f fcj_lab_state.env ]]; then source fcj_lab_state.env || true; fi
ASG_NAME="FCJ-Management-ASG"; LB_NAME="FCJ-Management-LB"; TG_NAME="FCJ-Management-TG"; LT_NAME="FCJ-Management-template"; AMI_NAME="FCJ-Management-AMI"; KEY_NAME="fcj-key-rerun"; DB_ID="fcj-management-db-instance"; DB_SUBNET_GROUP="FCJ-Management-Subnet-Group"
log() { printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

log "Delete ASG"
aws autoscaling delete-scheduled-action --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --scheduled-action-name "Rush hour" >/dev/null 2>&1 || true
for pol in $(aws autoscaling describe-policies --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --query 'ScalingPolicies[].PolicyName' --output text 2>/dev/null || true); do
  aws autoscaling delete-policy --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --policy-name "$pol" >/dev/null 2>&1 || true
done
aws autoscaling update-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --min-size 0 --desired-capacity 0 >/dev/null 2>&1 || true
aws autoscaling delete-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --force-delete >/dev/null 2>&1 || true
for _ in {1..60}; do
  [[ "$(aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'length(AutoScalingGroups)' --output text 2>/dev/null || echo 0)" == "0" ]] && break
  sleep 10
done

log "Terminate EC2 instances"
ids="$(aws ec2 describe-instances --region "$REGION" --filters Name=tag:"$LAB_TAG_KEY",Values="$LAB_TAG_VALUE" Name=instance-state-name,Values=pending,running,stopping,stopped --query 'Reservations[].Instances[].InstanceId' --output text 2>/dev/null || true)"
if [[ -n "$ids" ]]; then
  aws ec2 terminate-instances --region "$REGION" --instance-ids $ids >/dev/null || true
  aws ec2 wait instance-terminated --region "$REGION" --instance-ids $ids || true
fi

log "Delete ALB and Target Group"
lb_arn="$(aws elbv2 describe-load-balancers --region "$REGION" --names "$LB_NAME" --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || true)"
if [[ -n "$lb_arn" && "$lb_arn" != "None" ]]; then
  aws elbv2 delete-load-balancer --region "$REGION" --load-balancer-arn "$lb_arn" || true
  for _ in {1..50}; do
    aws elbv2 describe-load-balancers --region "$REGION" --load-balancer-arns "$lb_arn" >/dev/null 2>&1 || break
    sleep 10
  done
fi
tg_arn="$(aws elbv2 describe-target-groups --region "$REGION" --names "$TG_NAME" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || true)"
if [[ -n "$tg_arn" && "$tg_arn" != "None" ]]; then
  for _ in {1..20}; do
    aws elbv2 delete-target-group --region "$REGION" --target-group-arn "$tg_arn" >/dev/null 2>&1 && break
    sleep 10
  done
fi

log "Delete launch template, AMI, snapshots"
aws ec2 delete-launch-template --region "$REGION" --launch-template-name "$LT_NAME" >/dev/null 2>&1 || true
for image_id in $(aws ec2 describe-images --region "$REGION" --owners self --filters Name=name,Values="$AMI_NAME" --query 'Images[].ImageId' --output text 2>/dev/null || true); do
  snaps="$(aws ec2 describe-images --region "$REGION" --image-ids "$image_id" --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' --output text 2>/dev/null || true)"
  aws ec2 deregister-image --region "$REGION" --image-id "$image_id" >/dev/null 2>&1 || true
  for snap in $snaps; do aws ec2 delete-snapshot --region "$REGION" --snapshot-id "$snap" >/dev/null 2>&1 || true; done
done

log "Delete RDS"
aws rds delete-db-instance --region "$REGION" --db-instance-identifier "$DB_ID" --skip-final-snapshot --delete-automated-backups >/dev/null 2>&1 || true
aws rds wait db-instance-deleted --region "$REGION" --db-instance-identifier "$DB_ID" || true
aws rds delete-db-subnet-group --region "$REGION" --db-subnet-group-name "$DB_SUBNET_GROUP" >/dev/null 2>&1 || true

VPC_ID="${VPC_ID:-$(aws ec2 describe-vpcs --region "$REGION" --filters Name=tag:Name,Values=AutoScaling-Lab --query 'Vpcs[0].VpcId' --output text 2>/dev/null || true)}"
log "Delete security groups"
for sg in $(aws ec2 describe-security-groups --region "$REGION" --filters Name=vpc-id,Values="$VPC_ID" Name=group-name,Values='FCJ*' --query 'SecurityGroups[].GroupId' --output text 2>/dev/null || true); do
  aws ec2 delete-security-group --region "$REGION" --group-id "$sg" >/dev/null 2>&1 || true
done
if [[ -n "${DB_SG_ID:-}" ]]; then aws ec2 delete-security-group --region "$REGION" --group-id "$DB_SG_ID" >/dev/null 2>&1 || true; fi
if [[ -n "${APP_SG_ID:-}" ]]; then aws ec2 delete-security-group --region "$REGION" --group-id "$APP_SG_ID" >/dev/null 2>&1 || true; fi

log "Delete VPC networking"
if [[ -n "$VPC_ID" && "$VPC_ID" != "None" ]]; then
  for igw in $(aws ec2 describe-internet-gateways --region "$REGION" --filters Name=attachment.vpc-id,Values="$VPC_ID" --query 'InternetGateways[].InternetGatewayId' --output text 2>/dev/null || true); do
    aws ec2 detach-internet-gateway --region "$REGION" --internet-gateway-id "$igw" --vpc-id "$VPC_ID" >/dev/null 2>&1 || true
    aws ec2 delete-internet-gateway --region "$REGION" --internet-gateway-id "$igw" >/dev/null 2>&1 || true
  done
  for subnet in $(aws ec2 describe-subnets --region "$REGION" --filters Name=vpc-id,Values="$VPC_ID" --query 'Subnets[].SubnetId' --output text 2>/dev/null || true); do
    aws ec2 delete-subnet --region "$REGION" --subnet-id "$subnet" >/dev/null 2>&1 || true
  done
  for rtb in $(aws ec2 describe-route-tables --region "$REGION" --filters Name=vpc-id,Values="$VPC_ID" --query 'RouteTables[?Associations[?Main!=`true`]].RouteTableId' --output text 2>/dev/null || true); do
    aws ec2 delete-route-table --region "$REGION" --route-table-id "$rtb" >/dev/null 2>&1 || true
  done
  aws ec2 delete-vpc --region "$REGION" --vpc-id "$VPC_ID" >/dev/null 2>&1 || true
fi

log "Delete key pair"
aws ec2 delete-key-pair --region "$REGION" --key-name "$KEY_NAME" >/dev/null 2>&1 || true
rm -f "${KEY_NAME}.pem" fcj-key.pem

log "Verify cleanup"
echo "__ASG__"
aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'AutoScalingGroups[].AutoScalingGroupName' --output table
echo "__EC2__"
aws ec2 describe-instances --region "$REGION" --filters Name=tag:"$LAB_TAG_KEY",Values="$LAB_TAG_VALUE" Name=instance-state-name,Values=pending,running,stopping,stopped --query 'Reservations[].Instances[].InstanceId' --output table
echo "__LB__"
aws elbv2 describe-load-balancers --region "$REGION" --names "$LB_NAME" --query 'LoadBalancers[].LoadBalancerName' --output table 2>/dev/null || true
echo "__RDS__"
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[].DBInstanceIdentifier' --output table 2>/dev/null || true
echo "__VPC__"
aws ec2 describe-vpcs --region "$REGION" --filters Name=tag:Name,Values=AutoScaling-Lab --query 'Vpcs[].VpcId' --output table
echo "CLEANUP_COMPLETE"
EOF
chmod +x fcj_lab6_cleanup_final.sh
./fcj_lab6_cleanup_final.sh 2>&1 | tee fcj_lab6_cleanup_final.log
