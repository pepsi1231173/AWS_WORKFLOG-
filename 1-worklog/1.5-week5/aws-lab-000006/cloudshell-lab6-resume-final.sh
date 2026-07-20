cat > fcj_lab6_resume_final.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

REGION="ap-southeast-1"
LAB_TAG_KEY="Workshop"
LAB_TAG_VALUE="FCJ-ASG-Lab-000006"
ASG_NAME="FCJ-Management-ASG"
DB_ID="fcj-management-db-instance"
DB_NAME="awsfcjuser"
DB_USER="admin"
DB_PASS="123Vodanhphai"
AMI_NAME="FCJ-Management-AMI"
LT_NAME="FCJ-Management-template"
TG_NAME="FCJ-Management-TG"
LB_NAME="FCJ-Management-LB"
KEY_NAME="fcj-key-rerun"

if [[ -f fcj_lab_state.env ]]; then
  # shellcheck disable=SC1091
  source fcj_lab_state.env
fi
KEY_NAME="fcj-key-rerun"

log() { printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

save_state() {
  cat > fcj_lab_state.env <<STATE
REGION=$REGION
LAB_TAG_KEY=$LAB_TAG_KEY
LAB_TAG_VALUE=$LAB_TAG_VALUE
ASG_NAME=$ASG_NAME
DB_ID=$DB_ID
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
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
BASE_INSTANCE_ID=${BASE_INSTANCE_ID:-}
AMI_ID=${AMI_ID:-}
LT_ID=${LT_ID:-}
TG_ARN=${TG_ARN:-}
LB_ARN=${LB_ARN:-}
LB_DNS=${LB_DNS:-}
LISTENER_ARN=${LISTENER_ARN:-}
STATE
}

need_state() {
  : "${VPC_ID:?missing VPC_ID in fcj_lab_state.env}"
  : "${PUB_SUBNET_IDS:?missing PUB_SUBNET_IDS in fcj_lab_state.env}"
  : "${APP_SG_ID:?missing APP_SG_ID in fcj_lab_state.env}"
  : "${DB_SG_ID:?missing DB_SG_ID in fcj_lab_state.env}"
  DB_ENDPOINT="${DB_ENDPOINT:-$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[0].Endpoint.Address' --output text)}"
}

cleanup_named_partials() {
  log "Remove partial ASG/LB/LT/AMI resources from interrupted attempts"
  aws autoscaling update-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --min-size 0 --desired-capacity 0 || true
  aws autoscaling delete-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --force-delete || true
  for _ in {1..30}; do
    aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'length(AutoScalingGroups)' --output text | grep -q '^0$' && break
    sleep 10
  done

  local lb_arn
  lb_arn="$(aws elbv2 describe-load-balancers --region "$REGION" --names "$LB_NAME" --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || true)"
  if [[ -n "$lb_arn" && "$lb_arn" != "None" ]]; then
    aws elbv2 delete-load-balancer --region "$REGION" --load-balancer-arn "$lb_arn" || true
    sleep 15
  fi

  local tg_arn
  tg_arn="$(aws elbv2 describe-target-groups --region "$REGION" --names "$TG_NAME" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || true)"
  if [[ -n "$tg_arn" && "$tg_arn" != "None" ]]; then
    aws elbv2 delete-target-group --region "$REGION" --target-group-arn "$tg_arn" || true
  fi

  aws ec2 delete-launch-template --region "$REGION" --launch-template-name "$LT_NAME" >/dev/null 2>&1 || true

  local old_amis
  old_amis="$(aws ec2 describe-images --region "$REGION" --owners self --filters Name=name,Values="$AMI_NAME" --query 'Images[].ImageId' --output text 2>/dev/null || true)"
  for image_id in $old_amis; do
    local snaps
    snaps="$(aws ec2 describe-images --region "$REGION" --image-ids "$image_id" --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' --output text 2>/dev/null || true)"
    aws ec2 deregister-image --region "$REGION" --image-id "$image_id" || true
    for snap in $snaps; do aws ec2 delete-snapshot --region "$REGION" --snapshot-id "$snap" || true; done
  done

  local base_ids
  base_ids="$(aws ec2 describe-instances --region "$REGION" \
    --filters Name=tag:Name,Values=FCJ-Management Name=tag:"$LAB_TAG_KEY",Values="$LAB_TAG_VALUE" Name=instance-state-name,Values=pending,running,stopping,stopped \
    --query 'Reservations[].Instances[].InstanceId' --output text 2>/dev/null || true)"
  if [[ -n "$base_ids" ]]; then
    aws ec2 terminate-instances --region "$REGION" --instance-ids $base_ids >/dev/null || true
    aws ec2 wait instance-terminated --region "$REGION" --instance-ids $base_ids || true
  fi
}

ensure_security() {
  log "Open lab security group rules"
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$APP_SG_ID" --ip-permissions \
    IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0,Description=HTTP}]' >/dev/null 2>&1 || true
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$APP_SG_ID" --ip-permissions \
    IpProtocol=tcp,FromPort=3000,ToPort=3000,IpRanges='[{CidrIp=0.0.0.0/0,Description=NodeApp}]' >/dev/null 2>&1 || true
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$DB_SG_ID" --protocol tcp --port 3306 --source-group "$APP_SG_ID" >/dev/null 2>&1 || true
}

ensure_key() {
  log "Ensure key pair $KEY_NAME"
  if ! aws ec2 describe-key-pairs --region "$REGION" --key-names "$KEY_NAME" >/dev/null 2>&1; then
    aws ec2 create-key-pair --region "$REGION" --key-name "$KEY_NAME" --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
    chmod 400 "${KEY_NAME}.pem"
  fi
}

launch_base_instance() {
  log "Launch FCJ-Management base EC2 with app and DB seed"
  local pub_subnet ami_id user_data
  pub_subnet="$(echo "$PUB_SUBNET_IDS" | cut -d, -f1)"
  ami_id="$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)"
  cat > user-data-fcj.sh <<USERDATA
#!/bin/bash
set -xe
dnf update -y
dnf install -y git mariadb105 nodejs npm
npm install -g pm2
cd /home/ec2-user
rm -rf 000004-EC2
git clone https://github.com/First-Cloud-Journey/000004-EC2.git
cd 000004-EC2
cat > .env <<APPENV
DB_HOST='$DB_ENDPOINT'
DB_NAME='$DB_NAME'
DB_USER='$DB_USER'
DB_PASS='$DB_PASS'
APPENV
mysql -h "$DB_ENDPOINT" -P 3306 -u "$DB_USER" -p"$DB_PASS" <<'SQL'
CREATE DATABASE IF NOT EXISTS awsfcjuser;
USE awsfcjuser;
CREATE TABLE IF NOT EXISTS user (
  id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(45) NOT NULL,
  phone VARCHAR(45) NOT NULL,
  comments TEXT NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'active',
  PRIMARY KEY (id)
) ENGINE = InnoDB;
INSERT INTO user (first_name,last_name,email,phone,comments,status) VALUES
('Amanda','Nunes','anunes@ufc.com','012345 678910','','active'),
('Alexander','Volkanovski','avolkanovski@ufc.com','012345 678910','','active'),
('Khabib','Nurmagomedov','knurmagomedov@ufc.com','012345 678910','','active'),
('Kamaru','Usman','kusman@ufc.com','012345 678910','','active'),
('Israel','Adesanya','iadesanya@ufc.com','012345 678910','','active'),
('Henry','Cejudo','hcejudo@ufc.com','012345 678910','','active'),
('Valentina','Shevchenko','vshevchenko@ufc.com','012345 678910','','active'),
('Tyron','Woodley','twoodley@ufc.com','012345 678910','','active'),
('Rose','Namajunas','rnamajunas@ufc.com','012345 678910','','active'),
('Tony','Ferguson','tferguson@ufc.com','012345 678910','','active'),
('Jorge','Masvidal','jmasvidal@ufc.com','012345 678910','','active'),
('Nate','Diaz','ndiaz@ufc.com','012345 678910','','active'),
('Conor','McGregor','cmcGregor@ufc.com','012345 678910','','active'),
('Cris','Cyborg','ccyborg@ufc.com','012345 678910','','active'),
('Tecia','Torres','ttorres@ufc.com','012345 678910','','active'),
('Ronda','Rousey','rrousey@ufc.com','012345 678910','','active'),
('Holly','Holm','hholm@ufc.com','012345 678910','','active'),
('Joanna','Jedrzejczyk','jjedrzejczyk@ufc.com','012345 678910','','active');
SQL
npm install
pm2 start app.js --name fcj-management || pm2 start npm --name fcj-management -- start
pm2 startup systemd -u ec2-user --hp /home/ec2-user || true
pm2 save
chown -R ec2-user:ec2-user /home/ec2-user/000004-EC2
echo FCJ_USER_DATA_DONE >/var/tmp/fcj-user-data.done
USERDATA
  BASE_INSTANCE_ID="$(aws ec2 run-instances --region "$REGION" --image-id "$ami_id" --instance-type t2.micro --key-name "$KEY_NAME" \
    --subnet-id "$pub_subnet" --security-group-ids "$APP_SG_ID" --associate-public-ip-address \
    --user-data file://user-data-fcj.sh \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=FCJ-Management},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" \
    --query 'Instances[0].InstanceId' --output text)"
  save_state
  aws ec2 wait instance-running --region "$REGION" --instance-ids "$BASE_INSTANCE_ID"
  aws ec2 wait instance-status-ok --region "$REGION" --instance-ids "$BASE_INSTANCE_ID" || true
  log "Base instance: $BASE_INSTANCE_ID"
}

wait_for_app() {
  log "Wait for web app on base instance"
  local public_dns
  public_dns="$(aws ec2 describe-instances --region "$REGION" --instance-ids "$BASE_INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicDnsName' --output text)"
  for _ in {1..40}; do
    if curl -fsS --connect-timeout 3 "http://${public_dns}:3000/" >/tmp/fcj-app.html 2>/dev/null; then
      log "Base app reachable: http://${public_dns}:3000/"
      return 0
    fi
    sleep 15
  done
  log "App did not answer yet; continuing so console resources can still be verified"
}

create_ami_and_template() {
  log "Create AMI from FCJ-Management"
  AMI_ID="$(aws ec2 create-image --region "$REGION" --instance-id "$BASE_INSTANCE_ID" --name "$AMI_NAME" --description "AMI for FCJ-Management" --no-reboot --tag-specifications "ResourceType=image,Tags=[{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE},{Key=Name,Value=$AMI_NAME}]" --query ImageId --output text)"
  save_state
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
  save_state
  log "Launch template: $LT_ID"
}

create_load_balancer() {
  log "Create target group and Application Load Balancer"
  TG_ARN="$(aws elbv2 create-target-group --region "$REGION" --name "$TG_NAME" --protocol HTTP --port 3000 --target-type instance --vpc-id "$VPC_ID" --health-check-protocol HTTP --health-check-path "/" --matcher HttpCode=200-399 --query 'TargetGroups[0].TargetGroupArn' --output text)"
  aws elbv2 register-targets --region "$REGION" --target-group-arn "$TG_ARN" --targets Id="$BASE_INSTANCE_ID",Port=3000
  LB_ARN="$(aws elbv2 create-load-balancer --region "$REGION" --name "$LB_NAME" --type application --scheme internet-facing --security-groups "$APP_SG_ID" --subnets $(echo "$PUB_SUBNET_IDS" | tr ',' ' ') --tags Key="$LAB_TAG_KEY",Value="$LAB_TAG_VALUE" --query 'LoadBalancers[0].LoadBalancerArn' --output text)"
  aws elbv2 wait load-balancer-available --region "$REGION" --load-balancer-arns "$LB_ARN"
  LISTENER_ARN="$(aws elbv2 create-listener --region "$REGION" --load-balancer-arn "$LB_ARN" --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn="$TG_ARN" --query 'Listeners[0].ListenerArn' --output text)"
  LB_DNS="$(aws elbv2 describe-load-balancers --region "$REGION" --load-balancer-arns "$LB_ARN" --query 'LoadBalancers[0].DNSName' --output text)"
  save_state
  log "Load balancer DNS: http://$LB_DNS/"
}

create_asg_and_policies() {
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

  local start_time
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
  save_state
}

put_demo_metrics() {
  log "Upload demo CloudWatch metrics for predictive section"
  for i in {1..8}; do
    local ts cpu inst
    ts="$(date -u -d "-$((8-i)) hours" +%Y-%m-%dT%H:%M:%SZ)"
    cpu=$((10 + (i % 5) * 8))
    inst=$((1 + (i % 3)))
    aws cloudwatch put-metric-data --region "$REGION" --namespace "FCJ Management Custom Metrics" --metric-name CPUUtilization --dimensions AutoScalingGroupName="$ASG_NAME" --timestamp "$ts" --value "$cpu" --unit Percent
    aws cloudwatch put-metric-data --region "$REGION" --namespace "FCJ Management Custom Metrics" --metric-name GroupInServiceInstances --dimensions AutoScalingGroupName="$ASG_NAME" --timestamp "$ts" --value "$inst" --unit Count
  done
}

create_cleanup_script() {
  cat > fcj_lab_cleanup.sh <<'CLEANUP'
#!/usr/bin/env bash
set -euo pipefail
REGION="ap-southeast-1"
if [[ -f fcj_lab_state.env ]]; then source fcj_lab_state.env; fi
ASG_NAME="${ASG_NAME:-FCJ-Management-ASG}"
LB_NAME="${LB_NAME:-FCJ-Management-LB}"
TG_NAME="${TG_NAME:-FCJ-Management-TG}"
LT_NAME="${LT_NAME:-FCJ-Management-template}"
AMI_NAME="${AMI_NAME:-FCJ-Management-AMI}"
KEY_NAME="${KEY_NAME:-fcj-key-rerun}"
DB_ID="${DB_ID:-fcj-management-db-instance}"
DB_SUBNET_GROUP="${DB_SUBNET_GROUP:-FCJ-Management-Subnet-Group}"
VPC_ID="${VPC_ID:-}"
APP_SG_ID="${APP_SG_ID:-}"
DB_SG_ID="${DB_SG_ID:-}"
LAB_TAG_KEY="${LAB_TAG_KEY:-Workshop}"
LAB_TAG_VALUE="${LAB_TAG_VALUE:-FCJ-ASG-Lab-000006}"

log() { printf '\n[%s] %s\n' "$(date +%H:%M:%S)" "$*"; }

log "Delete Auto Scaling Group"
aws autoscaling update-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --min-size 0 --desired-capacity 0 || true
aws autoscaling delete-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --force-delete || true
for _ in {1..45}; do
  aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'length(AutoScalingGroups)' --output text | grep -q '^0$' && break
  sleep 10
done

log "Terminate lab EC2 instances"
ids="$(aws ec2 describe-instances --region "$REGION" --filters Name=tag:"$LAB_TAG_KEY",Values="$LAB_TAG_VALUE" Name=instance-state-name,Values=pending,running,stopping,stopped --query 'Reservations[].Instances[].InstanceId' --output text 2>/dev/null || true)"
if [[ -n "$ids" ]]; then
  aws ec2 terminate-instances --region "$REGION" --instance-ids $ids >/dev/null || true
  aws ec2 wait instance-terminated --region "$REGION" --instance-ids $ids || true
fi

log "Delete Load Balancer and Target Group"
lb_arn="$(aws elbv2 describe-load-balancers --region "$REGION" --names "$LB_NAME" --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || true)"
if [[ -n "$lb_arn" && "$lb_arn" != "None" ]]; then
  aws elbv2 delete-load-balancer --region "$REGION" --load-balancer-arn "$lb_arn" || true
  for _ in {1..40}; do
    aws elbv2 describe-load-balancers --region "$REGION" --load-balancer-arns "$lb_arn" >/dev/null 2>&1 || break
    sleep 10
  done
fi
tg_arn="$(aws elbv2 describe-target-groups --region "$REGION" --names "$TG_NAME" --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || true)"
if [[ -n "$tg_arn" && "$tg_arn" != "None" ]]; then aws elbv2 delete-target-group --region "$REGION" --target-group-arn "$tg_arn" || true; fi

log "Delete Launch Template and AMI"
aws ec2 delete-launch-template --region "$REGION" --launch-template-name "$LT_NAME" >/dev/null 2>&1 || true
for image_id in $(aws ec2 describe-images --region "$REGION" --owners self --filters Name=name,Values="$AMI_NAME" --query 'Images[].ImageId' --output text 2>/dev/null || true); do
  snaps="$(aws ec2 describe-images --region "$REGION" --image-ids "$image_id" --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' --output text 2>/dev/null || true)"
  aws ec2 deregister-image --region "$REGION" --image-id "$image_id" || true
  for snap in $snaps; do aws ec2 delete-snapshot --region "$REGION" --snapshot-id "$snap" || true; done
done

log "Delete RDS"
aws rds delete-db-instance --region "$REGION" --db-instance-identifier "$DB_ID" --skip-final-snapshot --delete-automated-backups >/dev/null 2>&1 || true
aws rds wait db-instance-deleted --region "$REGION" --db-instance-identifier "$DB_ID" || true
aws rds delete-db-subnet-group --region "$REGION" --db-subnet-group-name "$DB_SUBNET_GROUP" >/dev/null 2>&1 || true

log "Delete security groups"
if [[ -n "$DB_SG_ID" ]]; then aws ec2 delete-security-group --region "$REGION" --group-id "$DB_SG_ID" >/dev/null 2>&1 || true; fi
if [[ -n "$APP_SG_ID" ]]; then aws ec2 delete-security-group --region "$REGION" --group-id "$APP_SG_ID" >/dev/null 2>&1 || true; fi

log "Delete VPC networking"
if [[ -n "$VPC_ID" ]]; then
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
rm -f "${KEY_NAME}.pem"

log "Verify cleanup"
aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'AutoScalingGroups[].AutoScalingGroupName' --output table
aws elbv2 describe-load-balancers --region "$REGION" --names "$LB_NAME" --query 'LoadBalancers[].LoadBalancerName' --output table 2>/dev/null || true
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[].DBInstanceIdentifier' --output table 2>/dev/null || true
echo CLEANUP_COMPLETE
CLEANUP
  chmod +x fcj_lab_cleanup.sh
}

main() {
  need_state
  cleanup_named_partials
  ensure_security
  ensure_key
  launch_base_instance
  wait_for_app
  create_ami_and_template
  create_load_balancer
  create_asg_and_policies
  put_demo_metrics
  create_cleanup_script
  log "Final verification"
  aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query 'AutoScalingGroups[].{Name:AutoScalingGroupName,Desired:DesiredCapacity,Min:MinSize,Max:MaxSize,Instances:length(Instances)}' --output table
  aws elbv2 describe-target-health --region "$REGION" --target-group-arn "$TG_ARN" --query 'TargetHealthDescriptions[].{Target:Target.Id,Port:Target.Port,Health:TargetHealth.State}' --output table
  echo "LAB6_RESUME_COMPLETE"
  echo "ALB_URL=http://$LB_DNS/"
}

main "$@"
EOF
chmod +x fcj_lab6_resume_final.sh
./fcj_lab6_resume_final.sh 2>&1 | tee fcj_lab6_resume_final.log
