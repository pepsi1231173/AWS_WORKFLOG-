cat > fcj_lab6_rest_v2.sh <<'SCRIPT'
#!/usr/bin/env bash
set -euo pipefail
source fcj_lab_state.env
REGION="${REGION:-ap-southeast-1}"
STATE="fcj_lab_state.env"
LAB_TAG_KEY="${LAB_TAG_KEY:-Workshop}"
LAB_TAG_VALUE="${LAB_TAG_VALUE:-FCJ-ASG-Lab-000006}"
DB_PASS="123Vodanhphai"
KEY_NAME="fcj-key-rerun"
ASG_NAME="FCJ-Management-ASG"
AMI_NAME="FCJ-Management-AMI"
LT_NAME="FCJ-Management-template"
TG_NAME="FCJ-Management-TG"
LB_NAME="FCJ-Management-LB"

log(){ printf '\n[%s] %s\n' "$(date -u +%H:%M:%S)" "$*"; }
record(){ grep -v "^$1=" "$STATE" 2>/dev/null > "$STATE.tmp" || true; printf '%s=%q\n' "$1" "$2" >> "$STATE.tmp"; mv "$STATE.tmp" "$STATE"; source "$STATE"; }

record KEY_NAME "$KEY_NAME"
IFS=, read -ra PUBS <<< "$PUB_SUBNET_IDS"

log "Ensure key pair $KEY_NAME"
if aws ec2 describe-key-pairs --region "$REGION" --key-names "$KEY_NAME" >/dev/null 2>&1; then
  record KEY_CREATED "0"
else
  aws ec2 create-key-pair --region "$REGION" --key-name "$KEY_NAME" --tag-specifications "ResourceType=key-pair,Tags=[{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE},{Key=Name,Value=$KEY_NAME}]" --query 'KeyMaterial' --output text > "$KEY_NAME.pem"
  chmod 400 "$KEY_NAME.pem"
  record KEY_CREATED "1"
fi

log "Launch base EC2 and deploy app"
AMI_BASE=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query 'Parameter.Value' --output text)
cat > user-data-fcj-rerun.sh <<'USERDATA'
#!/bin/bash
exec > >(tee /var/log/fcj-user-data.log | logger -t fcj-user-data -s 2>/dev/console) 2>&1
set -euxo pipefail
DB_HOST="__DB_HOST__"
DB_NAME="awsfcjuser"
DB_USER="admin"
DB_PASS="__DB_PASS__"
dnf update -y
dnf install -y git mariadb105 nodejs npm
npm install -g pm2
mkdir -p /opt
cd /opt
rm -rf 000004-EC2
git clone https://github.com/First-Cloud-Journey/000004-EC2.git
cd 000004-EC2
cat > .env <<ENV
DB_HOST='$DB_HOST'
DB_NAME='$DB_NAME'
DB_USER='$DB_USER'
DB_PASS='$DB_PASS'
PORT=5000
ENV
npm install
python3 - <<'PY'
import json
with open('package.json') as f: p=json.load(f)
p.setdefault('scripts', {})['start']='pm2 start app.js --name fcj-management --update-env'
with open('package.json','w') as f: json.dump(p, f, indent=2)
PY
for i in {1..40}; do mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e 'SELECT 1' && break; sleep 10; done
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" -e "ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY '123Vodanhphai'; FLUSH PRIVILEGES;" || true
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" <<'SQL'
CREATE DATABASE IF NOT EXISTS `awsfcjuser`;
USE `awsfcjuser`;
CREATE TABLE IF NOT EXISTS `user` (`id` INT NOT NULL AUTO_INCREMENT, `first_name` VARCHAR(45) NOT NULL, `last_name` VARCHAR(45) NOT NULL, `email` VARCHAR(45) NOT NULL, `phone` VARCHAR(45) NOT NULL, `comments` TEXT NOT NULL, `status` VARCHAR(10) NOT NULL DEFAULT 'active', PRIMARY KEY (`id`)) ENGINE = InnoDB;
TRUNCATE TABLE `user`;
INSERT INTO `user` (`id`, `first_name`, `last_name`, `email`, `phone`, `comments`, `status`) VALUES
(NULL,'Amanda','Nunes','anunes@ufc.com','012345 678910','','active'),(NULL,'Alexander','Volkanovski','avolkanovski@ufc.com','012345 678910','','active'),(NULL,'Khabib','Nurmagomedov','knurmagomedov@ufc.com','012345 678910','','active'),(NULL,'Kamaru','Usman','kusman@ufc.com','012345 678910','','active'),(NULL,'Israel','Adesanya','iadesanya@ufc.com','012345 678910','','active'),(NULL,'Henry','Cejudo','hcejudo@ufc.com','012345 678910','','active'),(NULL,'Valentina','Shevchenko','vshevchenko@ufc.com','012345 678910','','active'),(NULL,'Tyron','Woodley','twoodley@ufc.com','012345 678910','','active'),(NULL,'Rose','Namajunas','rnamajunas@ufc.com','012345 678910','','active'),(NULL,'Tony','Ferguson','tferguson@ufc.com','012345 678910','','active'),(NULL,'Jorge','Masvidal','jmasvidal@ufc.com','012345 678910','','active'),(NULL,'Nate','Diaz','ndiaz@ufc.com','012345 678910','','active'),(NULL,'Conor','McGregor','cmcGregor@ufc.com','012345 678910','','active'),(NULL,'Cris','Cyborg','ccyborg@ufc.com','012345 678910','','active'),(NULL,'Tecia','Torres','ttorres@ufc.com','012345 678910','','active'),(NULL,'Ronda','Rousey','rrousey@ufc.com','012345 678910','','active'),(NULL,'Holly','Holm','hholm@ufc.com','012345 678910','','active'),(NULL,'Joanna','Jedrzejczyk','jjedrzejczyk@ufc.com','012345 678910','','active');
SQL
pm2 delete fcj-management || true
pm2 start app.js --name fcj-management --update-env
pm2 save
pm2 startup systemd -u root --hp /root || true
systemctl enable pm2-root || true
touch /var/tmp/fcj-ready
USERDATA
sed -i "s|__DB_HOST__|$DB_ENDPOINT|g; s|__DB_PASS__|$DB_PASS|g" user-data-fcj-rerun.sh

BASE_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI_BASE" --instance-type t2.micro --key-name "$KEY_NAME" --subnet-id "${PUBS[0]}" --security-group-ids "$APP_SG_ID" --user-data file://user-data-fcj-rerun.sh --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=FCJ-Management},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" "ResourceType=volume,Tags=[{Key=Name,Value=FCJ-Management-root},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" --query 'Instances[0].InstanceId' --output text)
record BASE_INSTANCE_ID "$BASE_INSTANCE_ID"
aws ec2 wait instance-status-ok --region "$REGION" --instance-ids "$BASE_INSTANCE_ID"
BASE_PUBLIC_DNS=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$BASE_INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
record BASE_PUBLIC_DNS "$BASE_PUBLIC_DNS"
log "Waiting for app http://$BASE_PUBLIC_DNS:5000"
for i in {1..60}; do curl -fsS "http://$BASE_PUBLIC_DNS:5000/" >/dev/null && break; sleep 10; done
curl -fsS "http://$BASE_PUBLIC_DNS:5000/" >/dev/null

log "Upload CloudWatch custom metrics"
mkdir -p metric-preparation
python3 - <<'PY'
import json, math, datetime
now=datetime.datetime.now(datetime.timezone.utc).replace(minute=0,second=0,microsecond=0); start=now-datetime.timedelta(days=8)
cpu=[]; inst=[]
for i in range(8*24):
    ts=start+datetime.timedelta(hours=i); hour=ts.hour
    load=round(max(12,70+45*max(0,math.sin((hour-9)/24*2*math.pi)),55+35*max(0,math.sin((hour-15)/24*2*math.pi))),3)
    cap=1 if load<55 else (2 if load<90 else 3)
    dims=[{"Name":"AutoScalingGroupName","Value":"FCJ-Management-ASG"}]
    cpu.append({"MetricName":"WSCustomCPUUTILIZATION","Dimensions":dims,"Timestamp":ts.isoformat(),"Value":load,"Unit":"Percent"})
    inst.append({"MetricName":"WSCustomGroupInstances","Dimensions":dims,"Timestamp":ts.isoformat(),"Value":cap,"Unit":"Count"})
json.dump(cpu,open('metric-preparation/metric-cpu.json','w')); json.dump(inst,open('metric-preparation/metric-instances.json','w'))
PY
aws cloudwatch put-metric-data --region "$REGION" --namespace 'FCJ Management Custom Metrics' --metric-data file://metric-preparation/metric-cpu.json
aws cloudwatch put-metric-data --region "$REGION" --namespace 'FCJ Management Custom Metrics' --metric-data file://metric-preparation/metric-instances.json

log "Create AMI and Launch Template"
AMI_ID=$(aws ec2 create-image --region "$REGION" --instance-id "$BASE_INSTANCE_ID" --name "$AMI_NAME" --description "AMI for FCJ-Management" --no-reboot --tag-specifications "ResourceType=image,Tags=[{Key=Name,Value=$AMI_NAME},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" "ResourceType=snapshot,Tags=[{Key=Name,Value=$AMI_NAME-snapshot},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" --query 'ImageId' --output text)
record AMI_ID "$AMI_ID"
aws ec2 wait image-available --region "$REGION" --image-ids "$AMI_ID"
SNAPSHOT_IDS=$(aws ec2 describe-images --region "$REGION" --image-ids "$AMI_ID" --query 'Images[0].BlockDeviceMappings[].Ebs.SnapshotId' --output text)
record SNAPSHOT_IDS "$SNAPSHOT_IDS"
cat > launch-template-data.json <<JSON
{"ImageId":"$AMI_ID","InstanceType":"t2.micro","KeyName":"$KEY_NAME","SecurityGroupIds":["$APP_SG_ID"],"TagSpecifications":[{"ResourceType":"instance","Tags":[{"Key":"Name","Value":"FCJ-Management-ASG-instance"},{"Key":"$LAB_TAG_KEY","Value":"$LAB_TAG_VALUE"}]},{"ResourceType":"volume","Tags":[{"Key":"Name","Value":"FCJ-Management-ASG-volume"},{"Key":"$LAB_TAG_KEY","Value":"$LAB_TAG_VALUE"}]}]}
JSON
LT_ID=$(aws ec2 create-launch-template --region "$REGION" --launch-template-name "$LT_NAME" --version-description "Template for FCJ Management" --launch-template-data file://launch-template-data.json --tag-specifications "ResourceType=launch-template,Tags=[{Key=Name,Value=$LT_NAME},{Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE}]" --query 'LaunchTemplate.LaunchTemplateId' --output text)
record LT_ID "$LT_ID"

log "Create Target Group and ALB"
TG_ARN=$(aws elbv2 create-target-group --region "$REGION" --name "$TG_NAME" --protocol HTTP --port 5000 --target-type instance --vpc-id "$VPC_ID" --health-check-path / --matcher HttpCode=200-399 --tags Key=Name,Value="$TG_NAME" Key="$LAB_TAG_KEY",Value="$LAB_TAG_VALUE" --query 'TargetGroups[0].TargetGroupArn' --output text)
record TG_ARN "$TG_ARN"
aws elbv2 register-targets --region "$REGION" --target-group-arn "$TG_ARN" --targets Id="$BASE_INSTANCE_ID",Port=5000
ALB_ARN=$(aws elbv2 create-load-balancer --region "$REGION" --name "$LB_NAME" --subnets ${PUBS[*]} --security-groups "$APP_SG_ID" --scheme internet-facing --type application --tags Key=Name,Value="$LB_NAME" Key="$LAB_TAG_KEY",Value="$LAB_TAG_VALUE" --query 'LoadBalancers[0].LoadBalancerArn' --output text)
record ALB_ARN "$ALB_ARN"
aws elbv2 wait load-balancer-available --region "$REGION" --load-balancer-arns "$ALB_ARN"
ALB_DNS=$(aws elbv2 describe-load-balancers --region "$REGION" --load-balancer-arns "$ALB_ARN" --query 'LoadBalancers[0].DNSName' --output text)
record ALB_DNS "$ALB_DNS"
LISTENER_ARN=$(aws elbv2 create-listener --region "$REGION" --load-balancer-arn "$ALB_ARN" --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn="$TG_ARN" --query 'Listeners[0].ListenerArn' --output text)
record LISTENER_ARN "$LISTENER_ARN"
for i in {1..40}; do s=$(aws elbv2 describe-target-health --region "$REGION" --target-group-arn "$TG_ARN" --targets Id="$BASE_INSTANCE_ID" --query 'TargetHealthDescriptions[0].TargetHealth.State' --output text 2>/dev/null || true); [ "$s" = healthy ] && break; sleep 15; done
curl -fsS "http://$ALB_DNS/" >/dev/null

log "Create ASG and SNS topic"
TOPIC_ARN=$(aws sns create-topic --region "$REGION" --name asg-topic --tags Key="$LAB_TAG_KEY",Value="$LAB_TAG_VALUE" Key=Name,Value=asg-topic --query TopicArn --output text)
record TOPIC_ARN "$TOPIC_ARN"
aws autoscaling create-auto-scaling-group --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --launch-template LaunchTemplateName="$LT_NAME",Version='$Default' --min-size 1 --max-size 3 --desired-capacity 1 --vpc-zone-identifier "$PUB_SUBNET_IDS" --target-group-arns "$TG_ARN" --health-check-type ELB --health-check-grace-period 120 --tags "ResourceId=$ASG_NAME,ResourceType=auto-scaling-group,Key=Name,Value=$ASG_NAME,PropagateAtLaunch=true" "ResourceId=$ASG_NAME,ResourceType=auto-scaling-group,Key=$LAB_TAG_KEY,Value=$LAB_TAG_VALUE,PropagateAtLaunch=true"
aws autoscaling enable-metrics-collection --region "$REGION" --auto-scaling-group-name "$ASG_NAME" --granularity 1Minute
for i in {1..40}; do c=$(aws autoscaling describe-auto-scaling-groups --region "$REGION" --auto-scaling-group-names "$ASG_NAME" --query "AutoScalingGroups[0].Instances[?LifecycleState=='InService'] | length(@)" --output text); [ "$c" -ge 1 ] && break; sleep 15; done
log "REST COMPLETE"
echo "ALB_DNS=http://$ALB_DNS"
SCRIPT
chmod +x fcj_lab6_rest_v2.sh
./fcj_lab6_rest_v2.sh 2>&1 | tee fcj_lab6_rest_v2.log
