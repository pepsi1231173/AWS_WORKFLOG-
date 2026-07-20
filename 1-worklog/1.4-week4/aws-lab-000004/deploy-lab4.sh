#!/usr/bin/env bash
set -u
AWS_PAGER=""

REGION="ap-southeast-1"
PREFIX="LAB4-0705"
PROJECT="AwsStudyGroup000004EC2"
STATE="$HOME/lab4-state.env"

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
    echo "LINUX_PUBLIC_SUBNET_2='${LINUX_PUBLIC_SUBNET_2:-}'"
    echo "LINUX_PRIVATE_SUBNET_1='${LINUX_PRIVATE_SUBNET_1:-}'"
    echo "LINUX_PRIVATE_SUBNET_2='${LINUX_PRIVATE_SUBNET_2:-}'"
    echo "WINDOWS_PUBLIC_SUBNET_1='${WINDOWS_PUBLIC_SUBNET_1:-}'"
    echo "WINDOWS_PUBLIC_SUBNET_2='${WINDOWS_PUBLIC_SUBNET_2:-}'"
    echo "WINDOWS_PRIVATE_SUBNET_1='${WINDOWS_PRIVATE_SUBNET_1:-}'"
    echo "WINDOWS_PRIVATE_SUBNET_2='${WINDOWS_PRIVATE_SUBNET_2:-}'"
    echo "LINUX_SG_ID='${LINUX_SG_ID:-}'"
    echo "WINDOWS_SG_ID='${WINDOWS_SG_ID:-}'"
    echo "LINUX_INSTANCE_ID='${LINUX_INSTANCE_ID:-}'"
    echo "WINDOWS_INSTANCE_ID='${WINDOWS_INSTANCE_ID:-}'"
    echo "AMI_INSTANCE_ID='${AMI_INSTANCE_ID:-}'"
    echo "LINUX_VOLUME_ID='${LINUX_VOLUME_ID:-}'"
    echo "SNAPSHOT_ID='${SNAPSHOT_ID:-}'"
    echo "CUSTOM_AMI_ID='${CUSTOM_AMI_ID:-}'"
    echo "LINUX_PUBLIC_IP='${LINUX_PUBLIC_IP:-}'"
    echo "WINDOWS_PUBLIC_IP='${WINDOWS_PUBLIC_IP:-}'"
    echo "AMI_PUBLIC_IP='${AMI_PUBLIC_IP:-}'"
    echo "ROLE_NAME='${ROLE_NAME:-}'"
    echo "PROFILE_NAME='${PROFILE_NAME:-}'"
    echo "IAM_GROUP='${IAM_GROUP:-}'"
    echo "IAM_USER='${IAM_USER:-}'"
  } > "$STATE"
}

tag_resource() {
  local resource_id="$1"
  local name="$2"
  aws ec2 create-tags --region "$REGION" --resources "$resource_id" \
    --tags "Key=Name,Value=$name" "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" >/dev/null
}

create_vpc_stack() {
  local kind="$1"
  local cidr="$2"
  local public1="$3"
  local public2="$4"
  local private1="$5"
  local private2="$6"
  local prefix_name="$PREFIX-$kind"
  local az1="${REGION}a"
  local az2="${REGION}b"

  log "Create $kind VPC" >&2
  local vpc_id
  vpc_id=$(aws ec2 create-vpc --region "$REGION" --cidr-block "$cidr" --tag-specifications \
    "ResourceType=vpc,Tags=[{Key=Name,Value=$prefix_name-vpc},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Vpc.VpcId --output text)
  aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$vpc_id" --enable-dns-support "{\"Value\":true}"
  aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$vpc_id" --enable-dns-hostnames "{\"Value\":true}"

  local igw_id
  igw_id=$(aws ec2 create-internet-gateway --region "$REGION" --tag-specifications \
    "ResourceType=internet-gateway,Tags=[{Key=Name,Value=$prefix_name-igw},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query InternetGateway.InternetGatewayId --output text)
  aws ec2 attach-internet-gateway --region "$REGION" --internet-gateway-id "$igw_id" --vpc-id "$vpc_id"

  local pub1 pub2 priv1 priv2
  pub1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$public1" --availability-zone "$az1" --tag-specifications \
    "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-public-1a},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Subnet.SubnetId --output text)
  pub2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$public2" --availability-zone "$az2" --tag-specifications \
    "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-public-1b},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Subnet.SubnetId --output text)
  priv1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$private1" --availability-zone "$az1" --tag-specifications \
    "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-private-1a},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Subnet.SubnetId --output text)
  priv2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$private2" --availability-zone "$az2" --tag-specifications \
    "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-private-1b},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Subnet.SubnetId --output text)

  aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$pub1" --map-public-ip-on-launch
  aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$pub2" --map-public-ip-on-launch

  local pub_rt priv_rt
  pub_rt=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$vpc_id" --tag-specifications \
    "ResourceType=route-table,Tags=[{Key=Name,Value=$prefix_name-public-rt},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query RouteTable.RouteTableId --output text)
  aws ec2 create-route --region "$REGION" --route-table-id "$pub_rt" --destination-cidr-block 0.0.0.0/0 --gateway-id "$igw_id" >/dev/null
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$pub_rt" --subnet-id "$pub1" >/dev/null
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$pub_rt" --subnet-id "$pub2" >/dev/null

  priv_rt=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$vpc_id" --tag-specifications \
    "ResourceType=route-table,Tags=[{Key=Name,Value=$prefix_name-private-rt},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query RouteTable.RouteTableId --output text)
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$priv_rt" --subnet-id "$priv1" >/dev/null
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$priv_rt" --subnet-id "$priv2" >/dev/null

  echo "$vpc_id $pub1 $pub2 $priv1 $priv2"
}

log "Lab 000004 deploy start in $REGION with prefix $PREFIX"

ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
log "AWS account $ACCOUNT_ID"

ROLE_NAME="$PREFIX-EC2-SSM-Role"
PROFILE_NAME="$PREFIX-EC2-Profile"
IAM_GROUP="$PREFIX-IAM-Governance-Group"
IAM_USER="$PREFIX-demo-user"

log "Create EC2 instance profile for SSM"
cat > /tmp/lab4-trust.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
JSON
aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file:///tmp/lab4-trust.json >/dev/null 2>&1 || true
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null 2>&1 || true
aws iam create-instance-profile --instance-profile-name "$PROFILE_NAME" >/dev/null 2>&1 || true
aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE_NAME" --role-name "$ROLE_NAME" >/dev/null 2>&1 || true
sleep 12
save_state

read LINUX_VPC_ID LINUX_PUBLIC_SUBNET_1 LINUX_PUBLIC_SUBNET_2 LINUX_PRIVATE_SUBNET_1 LINUX_PRIVATE_SUBNET_2 < <(create_vpc_stack Linux 10.40.0.0/16 10.40.1.0/24 10.40.2.0/24 10.40.101.0/24 10.40.102.0/24)
read WINDOWS_VPC_ID WINDOWS_PUBLIC_SUBNET_1 WINDOWS_PUBLIC_SUBNET_2 WINDOWS_PRIVATE_SUBNET_1 WINDOWS_PRIVATE_SUBNET_2 < <(create_vpc_stack Windows 10.41.0.0/16 10.41.1.0/24 10.41.2.0/24 10.41.101.0/24 10.41.102.0/24)
save_state

log "Create security groups"
LINUX_SG_ID=$(aws ec2 create-security-group --region "$REGION" --group-name "$PREFIX-Linux-SG" --description "$PREFIX Linux SG" --vpc-id "$LINUX_VPC_ID" --query GroupId --output text)
tag_resource "$LINUX_SG_ID" "$PREFIX-Linux-SG"
for port in 22 80 443 3000 8080; do
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$LINUX_SG_ID" --ip-permissions "IpProtocol=tcp,FromPort=$port,ToPort=$port,IpRanges=[{CidrIp=0.0.0.0/0,Description=Lab4-$port}]" >/dev/null 2>&1 || true
done

WINDOWS_SG_ID=$(aws ec2 create-security-group --region "$REGION" --group-name "$PREFIX-Windows-SG" --description "$PREFIX Windows SG" --vpc-id "$WINDOWS_VPC_ID" --query GroupId --output text)
tag_resource "$WINDOWS_SG_ID" "$PREFIX-Windows-SG"
for port in 3389 80 443 3000 5985; do
  aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$WINDOWS_SG_ID" --ip-permissions "IpProtocol=tcp,FromPort=$port,ToPort=$port,IpRanges=[{CidrIp=0.0.0.0/0,Description=Lab4-$port}]" >/dev/null 2>&1 || true
done
save_state

log "Create key pairs"
aws ec2 delete-key-pair --region "$REGION" --key-name "$PREFIX-kp-linux" >/dev/null 2>&1 || true
aws ec2 delete-key-pair --region "$REGION" --key-name "$PREFIX-kp-windows" >/dev/null 2>&1 || true
aws ec2 create-key-pair --region "$REGION" --key-name "$PREFIX-kp-linux" --key-type rsa --query KeyMaterial --output text > "$HOME/$PREFIX-kp-linux.pem"
aws ec2 create-key-pair --region "$REGION" --key-name "$PREFIX-kp-windows" --key-type rsa --query KeyMaterial --output text > "$HOME/$PREFIX-kp-windows.pem"
chmod 400 "$HOME/$PREFIX-kp-linux.pem" "$HOME/$PREFIX-kp-windows.pem"

log "Resolve latest AMIs"
LINUX_AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)
WINDOWS_AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-windows-latest/Windows_Server-2025-English-Full-Base --query Parameter.Value --output text 2>/dev/null || true)
if [ -z "$WINDOWS_AMI" ] || [ "$WINDOWS_AMI" = "None" ]; then
  WINDOWS_AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-windows-latest/Windows_Server-2022-English-Full-Base --query Parameter.Value --output text)
fi
echo "Linux AMI: $LINUX_AMI"
echo "Windows AMI: $WINDOWS_AMI"

cat > /tmp/lab4-linux-userdata.sh <<'EOF'
#!/bin/bash
set -eux
dnf install -y httpd mariadb105-server php php-mysqli git nodejs npm
systemctl enable --now httpd mariadb
mysql <<'SQL'
CREATE DATABASE IF NOT EXISTS awsuser;
CREATE USER IF NOT EXISTS 'appuser'@'localhost' IDENTIFIED BY 'Lab4Demo!123';
GRANT ALL PRIVILEGES ON awsuser.* TO 'appuser'@'localhost';
USE awsuser;
CREATE TABLE IF NOT EXISTS user (
  id INT NOT NULL AUTO_INCREMENT,
  first_name VARCHAR(45) NOT NULL,
  last_name VARCHAR(45) NOT NULL,
  email VARCHAR(80) NOT NULL,
  phone VARCHAR(45) NOT NULL,
  comments TEXT NOT NULL,
  status VARCHAR(10) NOT NULL DEFAULT 'active',
  PRIMARY KEY (id)
) ENGINE=InnoDB;
INSERT INTO user(first_name,last_name,email,phone,comments,status)
VALUES ('Cloud','Journey','cloudjourney@example.com','0900000000','LAB4 Linux application seed data','active')
ON DUPLICATE KEY UPDATE first_name=first_name;
SQL
cat > /var/www/html/index.php <<'PHP'
<?php
$mysqli = new mysqli("localhost", "appuser", "Lab4Demo!123", "awsuser");
if ($_SERVER["REQUEST_METHOD"] === "POST") {
  $stmt = $mysqli->prepare("INSERT INTO user(first_name,last_name,email,phone,comments,status) VALUES (?,?,?,?,?,?)");
  $status = "active";
  $stmt->bind_param("ssssss", $_POST["first_name"], $_POST["last_name"], $_POST["email"], $_POST["phone"], $_POST["comments"], $status);
  $stmt->execute();
}
$result = $mysqli->query("SELECT id, first_name, last_name, email, phone, comments, status FROM user ORDER BY id DESC");
?>
<!doctype html><html><head><meta charset="utf-8"><title>AWS User Management - Linux</title>
<style>body{font-family:Arial;margin:32px;background:#f6f8fb;color:#16202a}main{max-width:1050px;margin:auto;background:white;border:1px solid #d5d9d9;border-radius:8px;padding:24px}input,textarea{padding:9px;margin:4px;border:1px solid #9ba7b6;border-radius:4px}button{background:#ff9900;border:0;border-radius:4px;padding:10px 16px;font-weight:700}table{border-collapse:collapse;width:100%;margin-top:20px}th,td{border-bottom:1px solid #ddd;padding:10px;text-align:left}.badge{color:#067d62;font-weight:700}</style></head>
<body><main><h1>AWS User Management</h1><p>Lab 000004 deployed on Amazon Linux 2023 with Apache, PHP, MariaDB, and Node.js installed.</p>
<form method="post"><input name="first_name" placeholder="First name" required><input name="last_name" placeholder="Last name" required><input name="email" placeholder="Email" required><input name="phone" placeholder="Phone" required><textarea name="comments" placeholder="Comments" required></textarea><button>Add user</button></form>
<table><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Comments</th><th>Status</th></tr>
<?php while($row=$result->fetch_assoc()): ?><tr><td><?=htmlspecialchars($row["id"])?></td><td><?=htmlspecialchars($row["first_name"]." ".$row["last_name"])?></td><td><?=htmlspecialchars($row["email"])?></td><td><?=htmlspecialchars($row["phone"])?></td><td><?=htmlspecialchars($row["comments"])?></td><td class="badge"><?=htmlspecialchars($row["status"])?></td></tr><?php endwhile; ?>
</table></main></body></html>
PHP
cat > /opt/lab4-node-server.js <<'NODE'
const http = require("http");
http.createServer((req, res) => {
  res.writeHead(200, {"content-type":"text/html"});
  res.end("<h1>AWS User Management Node.js check</h1><p>Lab 000004 Node.js runtime is running on Amazon Linux 2023.</p>");
}).listen(3000, "0.0.0.0");
NODE
cat > /etc/systemd/system/lab4-node.service <<'UNIT'
[Unit]
Description=Lab4 Node.js check server
After=network.target
[Service]
ExecStart=/usr/bin/node /opt/lab4-node-server.js
Restart=always
User=root
[Install]
WantedBy=multi-user.target
UNIT
systemctl daemon-reload
systemctl enable --now lab4-node
EOF

cat > /tmp/lab4-windows-userdata.ps1 <<'EOF'
<powershell>
New-Item -ItemType Directory -Force -Path C:\Lab4 | Out-Null
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
New-NetFirewallRule -DisplayName "LAB4 HTTP 80" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
New-NetFirewallRule -DisplayName "LAB4 Node Demo 3000" -Direction Inbound -Protocol TCP -LocalPort 3000 -Action Allow
$html = @"
<!doctype html>
<html>
<head><meta charset="utf-8"><title>AWS User Management - Windows</title>
<style>body{font-family:Segoe UI,Arial;margin:32px;background:#f6f8fb;color:#16202a}main{max-width:1050px;margin:auto;background:white;border:1px solid #d5d9d9;border-radius:8px;padding:24px}input,textarea{padding:9px;margin:4px;border:1px solid #9ba7b6;border-radius:4px}button{background:#0078d4;color:white;border:0;border-radius:4px;padding:10px 16px;font-weight:700}table{border-collapse:collapse;width:100%;margin-top:20px}th,td{border-bottom:1px solid #ddd;padding:10px;text-align:left}.badge{color:#107c10;font-weight:700}</style></head>
<body><main><h1>AWS User Management</h1><p>Lab 000004 deployed on Microsoft Windows Server with IIS. This represents the Windows application workflow after XAMPP/Node.js setup.</p>
<form><input placeholder="First name"><input placeholder="Last name"><input placeholder="Email"><input placeholder="Phone"><textarea placeholder="Comments"></textarea><button type="button">Add user</button></form>
<table><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Comments</th><th>Status</th></tr><tr><td>1</td><td>Cloud Journey</td><td>cloudjourney@example.com</td><td>0900000000</td><td>LAB4 Windows application seed data</td><td class="badge">active</td></tr></table>
</main></body></html>
"@
Set-Content -Path C:\inetpub\wwwroot\index.html -Value $html -Encoding UTF8
</powershell>
EOF

log "Launch Linux instance"
LINUX_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" \
  --image-id "$LINUX_AMI" --instance-type t3.micro --key-name "$PREFIX-kp-linux" \
  --subnet-id "$LINUX_PUBLIC_SUBNET_1" --security-group-ids "$LINUX_SG_ID" \
  --iam-instance-profile Name="$PROFILE_NAME" \
  --user-data file:///tmp/lab4-linux-userdata.sh \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-Linux-instance},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" "ResourceType=volume,Tags=[{Key=Name,Value=$PREFIX-Linux-root},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
  --query Instances[0].InstanceId --output text)
save_state

log "Launch Windows instance"
WINDOWS_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" \
  --image-id "$WINDOWS_AMI" --instance-type t3.small --key-name "$PREFIX-kp-windows" \
  --subnet-id "$WINDOWS_PUBLIC_SUBNET_1" --security-group-ids "$WINDOWS_SG_ID" \
  --iam-instance-profile Name="$PROFILE_NAME" \
  --user-data file:///tmp/lab4-windows-userdata.ps1 \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-Windows-instance},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" "ResourceType=volume,Tags=[{Key=Name,Value=$PREFIX-Windows-root},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
  --query Instances[0].InstanceId --output text)
save_state

log "Wait for EC2 status checks"
aws ec2 wait instance-status-ok --region "$REGION" --instance-ids "$LINUX_INSTANCE_ID"
aws ec2 wait instance-status-ok --region "$REGION" --instance-ids "$WINDOWS_INSTANCE_ID"
LINUX_PUBLIC_IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$LINUX_INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
WINDOWS_PUBLIC_IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$WINDOWS_INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
LINUX_VOLUME_ID=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$LINUX_INSTANCE_ID" --query 'Reservations[0].Instances[0].BlockDeviceMappings[0].Ebs.VolumeId' --output text)
save_state
echo "LINUX_APP_URL=http://$LINUX_PUBLIC_IP/"
echo "LINUX_NODE_URL=http://$LINUX_PUBLIC_IP:3000/"
echo "WINDOWS_APP_URL=http://$WINDOWS_PUBLIC_IP/"

log "Create EBS snapshot"
SNAPSHOT_ID=$(aws ec2 create-snapshot --region "$REGION" --volume-id "$LINUX_VOLUME_ID" --description "$PREFIX Linux root snapshot" \
  --tag-specifications "ResourceType=snapshot,Tags=[{Key=Name,Value=$PREFIX-Linux-root-snapshot},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
  --query SnapshotId --output text)
save_state
aws ec2 wait snapshot-completed --region "$REGION" --snapshot-ids "$SNAPSHOT_ID"

log "Create custom AMI from Linux instance"
CUSTOM_AMI_ID=$(aws ec2 create-image --region "$REGION" --instance-id "$LINUX_INSTANCE_ID" --name "$PREFIX-Linux-Custom-AMI" --description "$PREFIX custom AMI from Linux instance" --no-reboot --query ImageId --output text)
save_state
aws ec2 wait image-available --region "$REGION" --image-ids "$CUSTOM_AMI_ID"
aws ec2 create-tags --region "$REGION" --resources "$CUSTOM_AMI_ID" --tags "Key=Name,Value=$PREFIX-Linux-Custom-AMI" "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" >/dev/null

log "Launch instance from custom AMI"
AMI_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" \
  --image-id "$CUSTOM_AMI_ID" --instance-type t3.micro --key-name "$PREFIX-kp-linux" \
  --subnet-id "$LINUX_PUBLIC_SUBNET_2" --security-group-ids "$LINUX_SG_ID" \
  --iam-instance-profile Name="$PROFILE_NAME" \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-From-Custom-AMI},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" "ResourceType=volume,Tags=[{Key=Name,Value=$PREFIX-AMI-instance-root},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
  --query Instances[0].InstanceId --output text)
save_state
aws ec2 wait instance-running --region "$REGION" --instance-ids "$AMI_INSTANCE_ID"

log "Modify custom AMI instance type from t3.micro to t3.small"
aws ec2 stop-instances --region "$REGION" --instance-ids "$AMI_INSTANCE_ID" >/dev/null
aws ec2 wait instance-stopped --region "$REGION" --instance-ids "$AMI_INSTANCE_ID"
aws ec2 modify-instance-attribute --region "$REGION" --instance-id "$AMI_INSTANCE_ID" --instance-type '{"Value":"t3.small"}'
aws ec2 start-instances --region "$REGION" --instance-ids "$AMI_INSTANCE_ID" >/dev/null
aws ec2 wait instance-running --region "$REGION" --instance-ids "$AMI_INSTANCE_ID"
AMI_PUBLIC_IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$AMI_INSTANCE_ID" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
save_state
echo "AMI_APP_URL=http://$AMI_PUBLIC_IP/"

log "Create IAM governance policies"
aws iam create-group --group-name "$IAM_GROUP" >/dev/null 2>&1 || true
aws iam create-user --user-name "$IAM_USER" >/dev/null 2>&1 || true
aws iam add-user-to-group --group-name "$IAM_GROUP" --user-name "$IAM_USER" >/dev/null 2>&1 || true

create_policy() {
  local name="$1"
  local file="$2"
  aws iam create-policy --policy-name "$name" --policy-document "file://$file" --tags "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" >/tmp/policy.json 2>/dev/null || true
  local arn
  arn=$(aws iam list-policies --scope Local --query "Policies[?PolicyName=='$name'].Arn | [0]" --output text)
  if [ "$arn" != "None" ]; then
    aws iam attach-group-policy --group-name "$IAM_GROUP" --policy-arn "$arn" >/dev/null 2>&1 || true
  fi
}

cat > /tmp/lab4-region.json <<JSON
{"Version":"2012-10-17","Statement":[{"Sid":"DenyOutsideSingapore","Effect":"Deny","Action":"ec2:*","Resource":"*","Condition":{"StringNotEquals":{"aws:RequestedRegion":"$REGION"}}}]}
JSON
cat > /tmp/lab4-family.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Sid":"AllowOnlyT3RunInstances","Effect":"Deny","Action":"ec2:RunInstances","Resource":"*","Condition":{"StringNotLike":{"ec2:InstanceType":"t3.*"}}}]}
JSON
cat > /tmp/lab4-size.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Sid":"DenyLargeInstanceTypes","Effect":"Deny","Action":"ec2:RunInstances","Resource":"*","Condition":{"ForAnyValue:StringLike":{"ec2:InstanceType":["*.large","*.xlarge","*.2xlarge","*.4xlarge","*.8xlarge","*.12xlarge","*.16xlarge","*.24xlarge"]}}}]}
JSON
cat > /tmp/lab4-ebs.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Sid":"AllowOnlyGp3Volumes","Effect":"Deny","Action":["ec2:CreateVolume","ec2:RunInstances"],"Resource":"*","Condition":{"StringNotEqualsIfExists":{"ec2:VolumeType":"gp3"}}}]}
JSON
cat > /tmp/lab4-ip.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Sid":"RestrictDeletesBySourceIp","Effect":"Deny","Action":["ec2:TerminateInstances","ec2:DeleteVolume","ec2:DeleteSnapshot"],"Resource":"*","Condition":{"NotIpAddress":{"aws:SourceIp":"0.0.0.0/0"}}}]}
JSON
cat > /tmp/lab4-time.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Sid":"RestrictDeletesByTimeWindow","Effect":"Deny","Action":["ec2:TerminateInstances","ec2:DeleteVolume","ec2:DeleteSnapshot"],"Resource":"*","Condition":{"DateLessThan":{"aws:CurrentTime":"2026-01-01T00:00:00Z"}}}]}
JSON

create_policy "$PREFIX-RestrictRegion" /tmp/lab4-region.json
create_policy "$PREFIX-LimitEC2Family" /tmp/lab4-family.json
create_policy "$PREFIX-LimitEC2Size" /tmp/lab4-size.json
create_policy "$PREFIX-RestrictEBSVolumeType" /tmp/lab4-ebs.json
create_policy "$PREFIX-RestrictDeleteByIP" /tmp/lab4-ip.json
create_policy "$PREFIX-RestrictDeleteByTime" /tmp/lab4-time.json
save_state

log "Final verification"
aws ec2 describe-instances --region "$REGION" --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Reservations[].Instances[].{Name:Tags[?Key==`Name`]|[0].Value,InstanceId:InstanceId,State:State.Name,Type:InstanceType,PublicIp:PublicIpAddress}' --output table
aws ec2 describe-snapshots --region "$REGION" --owner-ids self --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Snapshots[].{Name:Tags[?Key==`Name`]|[0].Value,SnapshotId:SnapshotId,State:State,VolumeId:VolumeId}' --output table
aws ec2 describe-images --region "$REGION" --owners self --filters "Name=tag:LabPrefix,Values=$PREFIX" --query 'Images[].{Name:Name,ImageId:ImageId,State:State}' --output table
aws iam list-policies --scope Local --query "Policies[?starts_with(PolicyName, '$PREFIX')].[PolicyName,Arn]" --output table
echo "LAB4_DEPLOY_DONE $PREFIX"
