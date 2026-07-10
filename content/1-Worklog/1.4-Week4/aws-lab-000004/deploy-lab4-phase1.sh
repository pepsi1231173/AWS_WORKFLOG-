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
    echo "ROLE_NAME='${ROLE_NAME:-}'"
    echo "PROFILE_NAME='${PROFILE_NAME:-}'"
    echo "IAM_GROUP='${IAM_GROUP:-}'"
    echo "IAM_USER='${IAM_USER:-}'"
  } > "$STATE"
}

tag_resource() {
  aws ec2 create-tags --region "$REGION" --resources "$1" \
    --tags "Key=Name,Value=$2" "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" >/dev/null
}

create_vpc_stack() {
  local kind="$1" cidr="$2" public1="$3" public2="$4" private1="$5" private2="$6"
  local prefix_name="$PREFIX-$kind" az1="${REGION}a" az2="${REGION}b"
  local vpc_id igw_id pub1 pub2 priv1 priv2 pub_rt priv_rt

  vpc_id=$(aws ec2 create-vpc --region "$REGION" --cidr-block "$cidr" --tag-specifications \
    "ResourceType=vpc,Tags=[{Key=Name,Value=$prefix_name-vpc},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query Vpc.VpcId --output text)
  aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$vpc_id" --enable-dns-support "{\"Value\":true}"
  aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$vpc_id" --enable-dns-hostnames "{\"Value\":true}"

  igw_id=$(aws ec2 create-internet-gateway --region "$REGION" --tag-specifications \
    "ResourceType=internet-gateway,Tags=[{Key=Name,Value=$prefix_name-igw},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" \
    --query InternetGateway.InternetGatewayId --output text)
  aws ec2 attach-internet-gateway --region "$REGION" --internet-gateway-id "$igw_id" --vpc-id "$vpc_id"

  pub1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$public1" --availability-zone "$az1" --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-public-1a},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query Subnet.SubnetId --output text)
  pub2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$public2" --availability-zone "$az2" --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-public-1b},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query Subnet.SubnetId --output text)
  priv1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$private1" --availability-zone "$az1" --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-private-1a},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query Subnet.SubnetId --output text)
  priv2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$vpc_id" --cidr-block "$private2" --availability-zone "$az2" --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=$prefix_name-private-1b},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query Subnet.SubnetId --output text)
  aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$pub1" --map-public-ip-on-launch
  aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$pub2" --map-public-ip-on-launch

  pub_rt=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$vpc_id" --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$prefix_name-public-rt},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query RouteTable.RouteTableId --output text)
  aws ec2 create-route --region "$REGION" --route-table-id "$pub_rt" --destination-cidr-block 0.0.0.0/0 --gateway-id "$igw_id" >/dev/null
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$pub_rt" --subnet-id "$pub1" >/dev/null
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$pub_rt" --subnet-id "$pub2" >/dev/null
  priv_rt=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$vpc_id" --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=$prefix_name-private-rt},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query RouteTable.RouteTableId --output text)
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$priv_rt" --subnet-id "$priv1" >/dev/null
  aws ec2 associate-route-table --region "$REGION" --route-table-id "$priv_rt" --subnet-id "$priv2" >/dev/null

  echo "$vpc_id $pub1 $pub2 $priv1 $priv2"
}

log "Phase 1 start"
ROLE_NAME="$PREFIX-EC2-SSM-Role"
PROFILE_NAME="$PREFIX-EC2-Profile"
IAM_GROUP="$PREFIX-IAM-Governance-Group"
IAM_USER="$PREFIX-demo-user"

cat > /tmp/lab4-trust.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
JSON
aws iam create-role --role-name "$ROLE_NAME" --assume-role-policy-document file:///tmp/lab4-trust.json >/dev/null 2>&1 || true
aws iam attach-role-policy --role-name "$ROLE_NAME" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null 2>&1 || true
aws iam create-instance-profile --instance-profile-name "$PROFILE_NAME" >/dev/null 2>&1 || true
aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE_NAME" --role-name "$ROLE_NAME" >/dev/null 2>&1 || true
sleep 10

read LINUX_VPC_ID LINUX_PUBLIC_SUBNET_1 LINUX_PUBLIC_SUBNET_2 LINUX_PRIVATE_SUBNET_1 LINUX_PRIVATE_SUBNET_2 < <(create_vpc_stack Linux 10.40.0.0/16 10.40.1.0/24 10.40.2.0/24 10.40.101.0/24 10.40.102.0/24)
read WINDOWS_VPC_ID WINDOWS_PUBLIC_SUBNET_1 WINDOWS_PUBLIC_SUBNET_2 WINDOWS_PRIVATE_SUBNET_1 WINDOWS_PRIVATE_SUBNET_2 < <(create_vpc_stack Windows 10.41.0.0/16 10.41.1.0/24 10.41.2.0/24 10.41.101.0/24 10.41.102.0/24)
save_state

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

aws ec2 delete-key-pair --region "$REGION" --key-name "$PREFIX-kp-linux" >/dev/null 2>&1 || true
aws ec2 delete-key-pair --region "$REGION" --key-name "$PREFIX-kp-windows" >/dev/null 2>&1 || true
aws ec2 create-key-pair --region "$REGION" --key-name "$PREFIX-kp-linux" --key-type rsa --query KeyMaterial --output text > "$HOME/$PREFIX-kp-linux.pem"
aws ec2 create-key-pair --region "$REGION" --key-name "$PREFIX-kp-windows" --key-type rsa --query KeyMaterial --output text > "$HOME/$PREFIX-kp-windows.pem"
chmod 400 "$HOME/$PREFIX-kp-linux.pem" "$HOME/$PREFIX-kp-windows.pem"

LINUX_AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)
WINDOWS_AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-windows-latest/Windows_Server-2022-English-Full-Base --query Parameter.Value --output text)

cat > /tmp/lab4-linux-userdata.sh <<'EOS'
#!/bin/bash
set -eux
dnf install -y httpd mariadb105-server php php-mysqli nodejs
systemctl enable --now httpd mariadb
mysql <<'SQL'
CREATE DATABASE IF NOT EXISTS awsuser;
CREATE USER IF NOT EXISTS 'appuser'@'localhost' IDENTIFIED BY 'Lab4Demo!123';
GRANT ALL PRIVILEGES ON awsuser.* TO 'appuser'@'localhost';
USE awsuser;
CREATE TABLE IF NOT EXISTS user (id INT NOT NULL AUTO_INCREMENT, first_name VARCHAR(45), last_name VARCHAR(45), email VARCHAR(80), phone VARCHAR(45), comments TEXT, status VARCHAR(10) DEFAULT 'active', PRIMARY KEY (id)) ENGINE=InnoDB;
INSERT INTO user(first_name,last_name,email,phone,comments,status) VALUES ('Cloud','Journey','cloudjourney@example.com','0900000000','LAB4 Linux application seed data','active');
SQL
cat > /var/www/html/index.php <<'PHP'
<?php $mysqli = new mysqli("localhost", "appuser", "Lab4Demo!123", "awsuser"); $result = $mysqli->query("SELECT * FROM user ORDER BY id DESC"); ?>
<!doctype html><html><head><title>AWS User Management - Linux</title><style>body{font-family:Arial;margin:32px;background:#f6f8fb}main{max-width:1050px;margin:auto;background:white;border:1px solid #d5d9d9;border-radius:8px;padding:24px}table{border-collapse:collapse;width:100%}th,td{border-bottom:1px solid #ddd;padding:10px;text-align:left}</style></head><body><main><h1>AWS User Management</h1><p>Lab 000004 on Amazon Linux 2023 with Apache, PHP, MariaDB and Node.js.</p><table><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Comments</th><th>Status</th></tr><?php while($r=$result->fetch_assoc()): ?><tr><td><?=htmlspecialchars($r["id"])?></td><td><?=htmlspecialchars($r["first_name"]." ".$r["last_name"])?></td><td><?=htmlspecialchars($r["email"])?></td><td><?=htmlspecialchars($r["phone"])?></td><td><?=htmlspecialchars($r["comments"])?></td><td><?=htmlspecialchars($r["status"])?></td></tr><?php endwhile; ?></table></main></body></html>
PHP
cat > /opt/lab4-node-server.js <<'NODE'
require("http").createServer((req,res)=>{res.writeHead(200,{"content-type":"text/html"});res.end("<h1>AWS User Management Node.js check</h1><p>Lab 000004 Node.js runtime is running.</p>")}).listen(3000,"0.0.0.0");
NODE
node /opt/lab4-node-server.js >/var/log/lab4-node.log 2>&1 &
EOS

cat > /tmp/lab4-windows-userdata.ps1 <<'EOS'
<powershell>
Install-WindowsFeature -Name Web-Server -IncludeManagementTools
New-NetFirewallRule -DisplayName "LAB4 HTTP 80" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow
$html = "<html><head><title>AWS User Management - Windows</title></head><body><h1>AWS User Management</h1><p>Lab 000004 Windows Server IIS workflow.</p><table border='1'><tr><th>ID</th><th>Name</th><th>Status</th></tr><tr><td>1</td><td>Cloud Journey</td><td>active</td></tr></table></body></html>"
Set-Content -Path C:\inetpub\wwwroot\index.html -Value $html -Encoding UTF8
</powershell>
EOS

LINUX_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" --image-id "$LINUX_AMI" --instance-type t3.micro --key-name "$PREFIX-kp-linux" --subnet-id "$LINUX_PUBLIC_SUBNET_1" --security-group-ids "$LINUX_SG_ID" --iam-instance-profile Name="$PROFILE_NAME" --user-data file:///tmp/lab4-linux-userdata.sh --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-Linux-instance},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" "ResourceType=volume,Tags=[{Key=Name,Value=$PREFIX-Linux-root},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
WINDOWS_INSTANCE_ID=$(aws ec2 run-instances --region "$REGION" --image-id "$WINDOWS_AMI" --instance-type t3.small --key-name "$PREFIX-kp-windows" --subnet-id "$WINDOWS_PUBLIC_SUBNET_1" --security-group-ids "$WINDOWS_SG_ID" --iam-instance-profile Name="$PROFILE_NAME" --user-data file:///tmp/lab4-windows-userdata.ps1 --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-Windows-instance},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" "ResourceType=volume,Tags=[{Key=Name,Value=$PREFIX-Windows-root},{Key=Project,Value=$PROJECT},{Key=LabPrefix,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
save_state

aws iam create-group --group-name "$IAM_GROUP" >/dev/null 2>&1 || true
aws iam create-user --user-name "$IAM_USER" >/dev/null 2>&1 || true
aws iam add-user-to-group --group-name "$IAM_GROUP" --user-name "$IAM_USER" >/dev/null 2>&1 || true
for name in RestrictRegion LimitEC2Family LimitEC2Size RestrictEBSVolumeType RestrictDeleteByIP RestrictDeleteByTime; do
  cat > "/tmp/$name.json" <<JSON
{"Version":"2012-10-17","Statement":[{"Effect":"Deny","Action":"ec2:*","Resource":"*"}]}
JSON
  aws iam create-policy --policy-name "$PREFIX-$name" --policy-document "file:///tmp/$name.json" --tags "Key=Project,Value=$PROJECT" "Key=LabPrefix,Value=$PREFIX" >/dev/null 2>&1 || true
  arn=$(aws iam list-policies --scope Local --query "Policies[?PolicyName=='$PREFIX-$name'].Arn | [0]" --output text)
  [ "$arn" != "None" ] && aws iam attach-group-policy --group-name "$IAM_GROUP" --policy-arn "$arn" >/dev/null 2>&1 || true
done

echo "LINUX_INSTANCE_ID=$LINUX_INSTANCE_ID"
echo "WINDOWS_INSTANCE_ID=$WINDOWS_INSTANCE_ID"
echo "LAB4_PHASE1_DONE $PREFIX"
