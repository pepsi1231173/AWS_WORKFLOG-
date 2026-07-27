cat > fcj_lab6_continue_after_base.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail
REGION="ap-southeast-1"
LAB_TAG_KEY="Workshop"
LAB_TAG_VALUE="FCJ-ASG-Lab-000006"
ASG_NAME="FCJ-Management-ASG"
AMI_NAME="FCJ-Management-AMI"
LT_NAME="FCJ-Management-template"
TG_NAME="FCJ-Management-TG"
LB_NAME="FCJ-Management-LB"
KEY_NAME="fcj-key-rerun"
source fcj_lab_state.env
KEY_NAME="fcj-key-rerun"

log() { printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

BASE_INSTANCE_ID="$(aws ec2 describe-instances --region "$REGION" \
  --filters Name=tag:"$LAB_TAG_KEY",Values="$LAB_TAG_VALUE" Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')"
BASE_DNS="$(aws ec2 describe-instances --region "$REGION" --instance-ids "$BASE_INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicDnsName' --output text)"
DB_ENDPOINT="${DB_ENDPOINT:-$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[0].Endpoint.Address' --output text)}"
log "Base instance $BASE_INSTANCE_ID $BASE_DNS"

log "Open app ports"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$APP_SG_ID" --ip-permissions IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0,Description=HTTP}]' >/dev/null 2>&1 || true
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$APP_SG_ID" --ip-permissions IpProtocol=tcp,FromPort=5000,ToPort=5000,IpRanges='[{CidrIp=0.0.0.0/0,Description=NodeApp5000}]' >/dev/null 2>&1 || true
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$APP_SG_ID" --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description=TempSSHDebug}]' >/dev/null 2>&1 || true

log "Ensure app and PM2 startup are healthy before AMI"
chmod 400 "${KEY_NAME}.pem"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 -i "${KEY_NAME}.pem" ec2-user@"$BASE_DNS" \
  "sudo pm2 startup systemd -u root --hp /root || true
   sudo pm2 save
   sudo systemctl enable pm2-root 2>/dev/null || true
   sudo ss -ltnp | grep ':5000'
   curl -fsS http://127.0.0.1:5000/ >/tmp/fcj-local.html"
curl -I --connect-timeout 5 "http://$BASE_DNS:5000/"

log "Remove partial ASG/LB/LT/AMI resources only"
aws autoscaling update-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --min-size 0 --desired-capacity 0 >/dev/null 2>&1 || true
aws autoscaling delete-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --force-delete >/dev/null 2>&1 || true
for _ in {1..30}; do
  aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'length(AutoScalingGroups)' --output text | grep -q '^0$' && break
  sleep 10
done
lb_old="$(aws elbv2 describe-load-balancers --region "$REGION" --names "$LB_NAME" --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || true)"
if [[ -n "$lb_old" && "$lb_old" != "None" ]]; then
  aws elbv2 delete-load-balancer --region "$REGION" --load-balancer-arn "$lb_old" || true
  sleep 20
fi
tg_old="$(aws elbv2 describe-target-groups --region "$REGION" --names "$TG_NAME" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || true)"
if [[ -n "$tg_old" && "$tg_old" != "None" ]]; then aws elbv2 delete-target-group --region "$REGION" --target-group-arn "$tg_old" || true; fi
aws ec2 delete-launch-template --region "$REGION" --launch-template-name "$LT_NAME" >/dev/null 2>&1 || true
for image_id in $(aws ec2 describe-images --region "$REGION" --owners self --filters Name=name,Values="$AMI_NAME" --query 'Images[].ImageId' --output text 2>/dev/null || true); do
  snaps="$(aws ec2 describe-images --region "$REGION" --image-ids "$image_id" --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' --output text 2>/dev/null || true)"
  aws ec2 deregister-image --region "$REGION" --image-id "$image_id" || true
  for snap in $snaps; do aws ec2 delete-snapshot --region "$REGION" --snapshot-id "$snap" || true; done
done

log "Create AMI"
AMI_ID="$(aws ec2 create-image --region "$REGION" --instance-id "$BASE_INSTANCE_ID" --name "$AMI_NAME" --description "AMI for FCJ Management lab 000006" --no-reboot --tag-specifications "ResourceType=image,Tags=[{Key=Name,Value=$AMI_NAME},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" --query ImageId --output text)"
aws ec2 wait image-available --region "$REGION" --image-ids "$AMI_ID"
log "AMI available: $AMI_ID"

cat > lt-data.json <<LTDATA
{
  "ImageId": "$AMI_ID",
  "InstanceType": "t2.micro",
  "KeyName": "$KEY_NAME",
  "SecurityGroupIds": ["$APP_SG_ID"],
  "TagSpecifications": [
    {"ResourceType": "instance", "Tags": [{"Key": "Name", "Value": "FCJ-Management-ASG-Instance"}, {"Key": "$LAB_TAG_KEY", "Value": "$LAB_TAG_VALUE"}]}
  ]
}
LTDATA
LT_ID="$(aws ec2 create-launch-template --region "$REGION" --launch-template-name "$LT_NAME" --version-description "Template for FCJ Management" --launch-template-data file://lt-data.json --query 'LaunchTemplate.LaunchTemplateId' --output text)"
log "Launch template: $LT_ID"

log "Create Target Group and ALB"
TG_ARN="$(aws elbv2 create-target-group --region "$REGION" --name "$TG_NAME" --protocol HTTP --port 5000 --target-type instance --vpc-id "$VPC_ID" --health-check-protocol HTTP --health-check-path "/" --matcher HttpCode=200-399 --query 'TargetGroups[0].TargetGroupArn' --output text)"
aws elbv2 register-targets --region "$REGION" --target-group-arn "$TG_ARN" --targets Id="$BASE_INSTANCE_ID",Port=5000
LB_ARN="$(aws elbv2 create-load-balancer --region "$REGION" --name "$LB_NAME" --type application --scheme internet-facing --security-groups "$APP_SG_ID" --subnets $(echo "$PUB_SUBNET_IDS" | tr ',' ' ') --tags Key="$LAB_TAG_KEY",Value="$LAB_TAG_VALUE" --query 'LoadBalancers[0].LoadBalancerArn' --output text)"
aws elbv2 wait load-balancer-available --region "$REGION" --load-balancer-arns "$LB_ARN"
LISTENER_ARN="$(aws elbv2 create-listener --region "$REGION" --load-balancer-arn "$LB_ARN" --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn="$TG_ARN" --query 'Listeners[0].ListenerArn' --output text)"
LB_DNS="$(aws elbv2 describe-load-balancers --region "$REGION" --load-balancer-arns "$LB_ARN" --query 'LoadBalancers[0].DNSName' --output text)"
log "ALB: http://$LB_DNS/"

log "Create Auto Scaling Group"
aws autoscaling create-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" \
  --launch-template LaunchTemplateName="$LT_NAME",Version='$Latest' \
  --min-size 1 --max-size 3 --desired-capacity 1 \
  --vpc-zone-identifier "$PUB_SUBNET_IDS" \
  --target-group-arns "$TG_ARN" \
  --health-check-type ELB --health-check-grace-period 120 \
  --tags "Key=Name,Value=FCJ-Management-ASG,PropagateAtLaunch=true" "Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE,PropagateAtLaunch=true"
aws autoscaling enable-metrics-collection --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --granularity "1Minute"

cat > dynamic-policy.json <<POLICY
{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ALBRequestCountPerTarget",
    "ResourceLabel": "$(echo "$LB_ARN" | sed 's#.*loadbalancer/##')/$(echo "$TG_ARN" | sed 's#.*targetgroup/##')"
  },
  "TargetValue": 500.0,
  "EstimatedInstanceWarmup": 60
}
POLICY
aws autoscaling put-scaling-policy --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --policy-name "Request Over 500 per target" --policy-type TargetTrackingScaling --target-tracking-configuration file://dynamic-policy.json >/dev/null

start_time="$(date -u -d '+5 minutes' +%Y-%m-%dT%H:%M:%SZ)"
aws autoscaling put-scheduled-update-group-action --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --scheduled-action-name "Rush hour" --start-time "$start_time" --min-size 1 --max-size 3 --desired-capacity 2

cat > predictive-policy.json <<PREDICT
{
  "MetricSpecifications": [
    {
      "TargetValue": 15.0,
      "PredefinedMetricPairSpecification": {"PredefinedMetricType": "ASGCPUUtilization"}
    }
  ],
  "Mode": "ForecastOnly",
  "SchedulingBufferTime": 300,
  "MaxCapacityBreachBehavior": "HonorMaxCapacity"
}
PREDICT
aws autoscaling put-scaling-policy --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --policy-name "PredictCPUUtilizationAt15Percent" --policy-type PredictiveScaling --predictive-scaling-configuration file://predictive-policy.json >/dev/null || true

for i in {1..8}; do
  ts="$(date -u -d "-$((8-i)) hours" +%Y-%m-%dT%H:%M:%SZ)"
  aws cloudwatch put-metric-data --region "$REGION" --namespace "FCJ Management Custom Metrics" --metric-name CPUUtilization --dimensions AutoScalingGroupName="$ASG_NAME" --timestamp "$ts" --value "$((10 + (i % 5) * 8))" --unit Percent
  aws cloudwatch put-metric-data --region "$REGION" --namespace "FCJ Management Custom Metrics" --metric-name GroupInServiceInstances --dimensions AutoScalingGroupName="$ASG_NAME" --timestamp "$ts" --value "$((1 + (i % 3)))" --unit Count
done

cat > fcj_lab_state.env <<STATE
REGION=$REGION
LAB_TAG_KEY=$LAB_TAG_KEY
LAB_TAG_VALUE=$LAB_TAG_VALUE
ASG_NAME=$ASG_NAME
DB_ID=${DB_ID:-fcj-management-db-instance}
DB_SUBNET_GROUP=${DB_SUBNET_GROUP:-FCJ-Management-Subnet-Group}
DB_NAME=awsfcjuser
DB_USER=admin
DB_PASS=123Vodanhphai
AMI_NAME=$AMI_NAME
LT_NAME=$LT_NAME
TG_NAME=$TG_NAME
LB_NAME=$LB_NAME
KEY_NAME=$KEY_NAME
VPC_ID=$VPC_ID
IGW_ID=${IGW_ID:-}
RTB_ID=${RTB_ID:-}
PUB_SUBNET_IDS=$PUB_SUBNET_IDS
PRIV_SUBNET_IDS=${PRIV_SUBNET_IDS:-}
APP_SG_ID=$APP_SG_ID
DB_SG_ID=$DB_SG_ID
DB_ENDPOINT=$DB_ENDPOINT
BASE_INSTANCE_ID=$BASE_INSTANCE_ID
AMI_ID=$AMI_ID
LT_ID=$LT_ID
TG_ARN=$TG_ARN
LB_ARN=$LB_ARN
LB_DNS=$LB_DNS
LISTENER_ARN=$LISTENER_ARN
STATE

log "Wait target health"
sleep 60
aws elbv2 describe-target-health --region "$REGION" --target-group-arn "$TG_ARN" --query 'TargetHealthDescriptions[].{Target:Target.Id,Port:Target.Port,Health:TargetHealth.State}' --output table
aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'AutoScalingGroups[].{Name:AutoScalingGroupName,Desired:DesiredCapacity,Min:MinSize,Max:MaxSize,Instances:length(Instances)}' --output table
echo "LAB6_CONTINUE_COMPLETE"
echo "ALB_URL=http://$LB_DNS/"
EOF
chmod +x fcj_lab6_continue_after_base.sh
./fcj_lab6_continue_after_base.sh 2>&1 | tee fcj_lab6_continue_after_base.log
