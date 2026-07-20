#!/usr/bin/env bash
set -Eeuo pipefail
export AWS_PAGER=""

REGION=ap-southeast-1
PROJECT=AwsStudyGroup000005RDS
PREFIX=${PREFIX:-RDS5-$(date +%m%d%H%M)}
STATE=~/rds5-state.env
LOG=~/rds5-deploy.log
exec > >(tee -a "$LOG") 2>&1

save() {
  local key="$1"
  local value="$2"
  sed -i "/^${key}=/d" "$STATE" 2>/dev/null || true
  printf '%s=%q\n' "$key" "$value" >> "$STATE"
}

tag_ec2() {
  aws ec2 create-tags --region "$REGION" --resources "$@" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" >/dev/null
}

name_ec2() {
  aws ec2 create-tags --region "$REGION" --resources "$1" --tags Key=Name,Value="$2" Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" >/dev/null
}

json_for_ssm() {
  local script_path="$1"
  local json_path="$2"
  python3 - "$script_path" "$json_path" <<'PY'
import json, sys
script_path, json_path = sys.argv[1], sys.argv[2]
with open(script_path, "r", encoding="utf-8") as f:
    script = f.read()
with open(json_path, "w", encoding="utf-8") as f:
    json.dump({"commands": [script]}, f)
PY
}

echo "=== LAB 000005 RDS DEPLOY: $PREFIX in $REGION ==="
aws configure set region "$REGION"
ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
azs=($(aws ec2 describe-availability-zones --region "$REGION" --query "AvailabilityZones[?State=='available'].ZoneName" --output text))
AZ1=${azs[0]}
AZ2=${azs[1]:-${azs[0]}}

DB_ID=$(echo "${PREFIX}-mysql" | tr '[:upper:]' '[:lower:]')
RESTORE_ID=$(echo "${PREFIX}-mysql-restore" | tr '[:upper:]' '[:lower:]')
SNAP_ID=$(echo "${PREFIX}-snapshot" | tr '[:upper:]' '[:lower:]')
DB_NAME=first_cloud_users
DB_USER=admin
DB_PASS="RdsLab5!$(date +%s)"

: > "$STATE"
save PREFIX "$PREFIX"
save REGION "$REGION"
save PROJECT "$PROJECT"
save ACCOUNT "$ACCOUNT"
save DB_ID "$DB_ID"
save RESTORE_ID "$RESTORE_ID"
save SNAP_ID "$SNAP_ID"
save DB_NAME "$DB_NAME"
save DB_USER "$DB_USER"
save DB_PASS "$DB_PASS"

echo "=== 2.1 Create VPC, subnets, internet gateway and route table ==="
VPC=$(aws ec2 create-vpc --region "$REGION" --cidr-block 10.50.0.0/16 --query Vpc.VpcId --output text)
name_ec2 "$VPC" "$PREFIX-VPC"
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPC" --enable-dns-hostnames '{"Value":true}'
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPC" --enable-dns-support '{"Value":true}'
PUB=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.50.1.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text)
DBSUB1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.50.11.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text)
DBSUB2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.50.12.0/24 --availability-zone "$AZ2" --query Subnet.SubnetId --output text)
name_ec2 "$PUB" "$PREFIX-Public-Subnet"
name_ec2 "$DBSUB1" "$PREFIX-DB-Private-Subnet-AZ1"
name_ec2 "$DBSUB2" "$PREFIX-DB-Private-Subnet-AZ2"
aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$PUB" --map-public-ip-on-launch
IGW=$(aws ec2 create-internet-gateway --region "$REGION" --query InternetGateway.InternetGatewayId --output text)
name_ec2 "$IGW" "$PREFIX-IGW"
aws ec2 attach-internet-gateway --region "$REGION" --vpc-id "$VPC" --internet-gateway-id "$IGW"
RT=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$VPC" --query RouteTable.RouteTableId --output text)
name_ec2 "$RT" "$PREFIX-Public-RT"
aws ec2 create-route --region "$REGION" --route-table-id "$RT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW" >/dev/null
ASSOC=$(aws ec2 associate-route-table --region "$REGION" --route-table-id "$RT" --subnet-id "$PUB" --query AssociationId --output text)
save VPC "$VPC"
save PUB "$PUB"
save DBSUB1 "$DBSUB1"
save DBSUB2 "$DBSUB2"
save IGW "$IGW"
save RT "$RT"
save ASSOC "$ASSOC"

echo "=== 2.2 Create EC2 Security Group ==="
EC2SG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-EC2-Web-App-SG" --description "Lab 000005 EC2 web app SG" --query GroupId --output text)
name_ec2 "$EC2SG" "$PREFIX-EC2-Web-App-SG"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$EC2SG" --ip-permissions \
  IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description="SSH lab access"}]' \
  IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0,Description="HTTP"}]' \
  IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=0.0.0.0/0,Description="HTTPS"}]' \
  IpProtocol=tcp,FromPort=5000,ToPort=5000,IpRanges='[{CidrIp=0.0.0.0/0,Description="Node app"}]' >/dev/null
save EC2SG "$EC2SG"

echo "=== 2.3 Create RDS Security Group ==="
RDSSG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-RDS-MySQL-SG" --description "Lab 000005 RDS MySQL SG" --query GroupId --output text)
name_ec2 "$RDSSG" "$PREFIX-RDS-MySQL-SG"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$RDSSG" --ip-permissions "[{\"IpProtocol\":\"tcp\",\"FromPort\":3306,\"ToPort\":3306,\"UserIdGroupPairs\":[{\"GroupId\":\"$EC2SG\",\"Description\":\"MySQL from EC2 web app SG\"}]}]" >/dev/null
save RDSSG "$RDSSG"

echo "=== 2.4 Create DB Subnet Group ==="
DBSUBGROUP=$(echo "${PREFIX}-db-subnet-group" | tr '[:upper:]' '[:lower:]')
aws rds create-db-subnet-group --region "$REGION" --db-subnet-group-name "$DBSUBGROUP" --db-subnet-group-description "Lab 000005 RDS subnet group" --subnet-ids "$DBSUB1" "$DBSUB2" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-DB-Subnet-Group" >/dev/null
save DBSUBGROUP "$DBSUBGROUP"

echo "=== 3. Create EC2 instance ==="
ROLE=${PREFIX}-EC2-SSM-Role
PROFILE=${PREFIX}-EC2-Profile
cat > trust-ec2.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
JSON
aws iam create-role --role-name "$ROLE" --assume-role-policy-document file://trust-ec2.json >/dev/null
aws iam attach-role-policy --role-name "$ROLE" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore >/dev/null
aws iam create-instance-profile --instance-profile-name "$PROFILE" >/dev/null
aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE" --role-name "$ROLE" >/dev/null
sleep 15
AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)
KEY=${PREFIX}-key
aws ec2 create-key-pair --region "$REGION" --key-name "$KEY" --key-type rsa --query KeyMaterial --output text > "$KEY.pem"
chmod 400 "$KEY.pem"
EC2=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI" --instance-type t3.micro --key-name "$KEY" --iam-instance-profile Name="$PROFILE" --subnet-id "$PUB" --security-group-ids "$EC2SG" --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-EC2-App},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
aws ec2 wait instance-running --region "$REGION" --instance-ids "$EC2"
EC2IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$EC2" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
EC2PRIV=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$EC2" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
save ROLE "$ROLE"
save PROFILE "$PROFILE"
save AMI "$AMI"
save KEY "$KEY"
save EC2 "$EC2"
save EC2IP "$EC2IP"
save EC2PRIV "$EC2PRIV"

echo "=== 4. Create RDS database instance ==="
aws rds create-db-instance \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --allocated-storage 20 \
  --storage-type gp2 \
  --db-name "$DB_NAME" \
  --master-username "$DB_USER" \
  --master-user-password "$DB_PASS" \
  --vpc-security-group-ids "$RDSSG" \
  --db-subnet-group-name "$DBSUBGROUP" \
  --backup-retention-period 1 \
  --no-publicly-accessible \
  --no-multi-az \
  --no-deletion-protection \
  --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-RDS-MySQL" >/dev/null
echo "Waiting for RDS instance $DB_ID..."
aws rds wait db-instance-available --region "$REGION" --db-instance-identifier "$DB_ID"
DB_ENDPOINT=$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[0].Endpoint.Address' --output text)
save DB_ENDPOINT "$DB_ENDPOINT"

echo "=== 5. Application Deployment ==="
for n in {1..45}; do
  SSM=$(aws ssm describe-instance-information --region "$REGION" --filters Key=InstanceIds,Values="$EC2" --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null || true)
  echo "SSM=$SSM"
  [ "$SSM" = "Online" ] && break
  sleep 10
done

cat > app-setup.sh <<'REMOTE'
set -euxo pipefail
sudo dnf install -y git nodejs npm
cd /home/ec2-user
rm -rf AWS-FCJ-Management rds-lab-app
git clone https://github.com/AWS-First-Cloud-Journey/AWS-FCJ-Management || true
mkdir -p rds-lab-app
cd rds-lab-app
cat > package.json <<'EOF'
{"scripts":{"start":"node index.js"},"dependencies":{"express":"^4.19.2","mysql2":"^3.10.0"}}
EOF
cat > index.js <<'EOF'
const express = require('express');
const mysql = require('mysql2/promise');
const app = express();
const port = 5000;
const db = { host: process.env.DB_HOST, user: process.env.DB_USER, password: process.env.DB_PASS, database: process.env.DB_NAME };
const seedUsers = [
 ['Amanda','Nunes','anunes@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Alexander','Volkanovski','avolkanovski@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Khabib','Nurmagomedov','knurmagomedov@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Kamaru','Usman','kusman@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Israel','Adesanya','iadesanya@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Henry','Cejudo','hcejudo@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Valentina','Shevchenko','vshevchenko@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Tyron','Woodley','twoodley@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Rose','Namajunas','rnamajunas@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Tony','Ferguson','tferguson@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Jorge','Masvidal','jmasvidal@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Nate','Diaz','ndiaz@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Conor','McGregor','cmcGregor@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Cris','Cyborg','ccyborg@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Tecia','Torres','ttorres@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Ronda','Rousey','rrousey@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Holly','Holm','hholm@ufc.com','012345 678910','I love AWS FCJ','active'],
 ['Joanna','Jedrzejczyk','jjedrzejczyk@ufc.com','012345 678910','I love AWS FCJ','active']
];
async function init() {
 const conn = await mysql.createConnection(db);
 await conn.execute("CREATE TABLE IF NOT EXISTS user (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, first_name VARCHAR(45) NOT NULL, last_name VARCHAR(45) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE, phone VARCHAR(20) NOT NULL, comments TEXT NOT NULL, status ENUM('active','inactive') NOT NULL DEFAULT 'active') ENGINE=InnoDB");
 for (const u of seedUsers) await conn.execute('INSERT IGNORE INTO user (first_name,last_name,email,phone,comments,status) VALUES (?,?,?,?,?,?)', u);
 await conn.end();
}
async function queryUsers() {
 const conn = await mysql.createConnection(db);
 const [rows] = await conn.query('SELECT * FROM user ORDER BY id LIMIT 50');
 await conn.end();
 return rows;
}
app.get('/health', async (req, res) => {
 try {
  const rows = await queryUsers();
  res.json({status:'ok', users: rows.length, dbHost: db.host});
 } catch (e) {
  res.status(500).json({status:'error', message:e.message});
 }
});
app.get('/', async (req, res) => {
 try {
  const rows = await queryUsers();
  res.send(`<!doctype html><title>AWS FCJ RDS Lab</title><style>body{font-family:Arial;margin:32px;background:#f7f9fb;color:#17202a}table{border-collapse:collapse;width:100%;background:white}td,th{border:1px solid #d6dde5;padding:8px}th{background:#232f3e;color:white}.ok{color:#067d62;font-weight:bold}</style><h1>AWS FCJ Management - RDS Lab 000005</h1><p class="ok">Connected to Amazon RDS MySQL: ${db.host}</p><p>Total users: ${rows.length}</p><table><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Status</th></tr>${rows.map(r=>`<tr><td>${r.id}</td><td>${r.first_name} ${r.last_name}</td><td>${r.email}</td><td>${r.phone}</td><td>${r.status}</td></tr>`).join('')}</table>`);
 } catch (e) {
  res.status(500).send(`<h1>DB error</h1><pre>${e.stack}</pre>`);
 }
});
init().then(()=>app.listen(port, '0.0.0.0', ()=>console.log(`RDS lab app listening on ${port}`))).catch(e=>{ console.error(e); process.exit(1); });
EOF
npm install
cat > /home/ec2-user/rds-lab-app/.env <<'EOF'
DB_HOST=__DB_ENDPOINT__
DB_NAME=__DB_NAME__
DB_USER=__DB_USER__
DB_PASS=__DB_PASS__
EOF
sudo tee /etc/systemd/system/rds-lab-app.service >/dev/null <<'EOF'
[Unit]
Description=RDS Lab 000005 Node App
After=network.target
[Service]
Type=simple
WorkingDirectory=/home/ec2-user/rds-lab-app
EnvironmentFile=/home/ec2-user/rds-lab-app/.env
ExecStart=/usr/bin/node /home/ec2-user/rds-lab-app/index.js
Restart=always
User=ec2-user
[Install]
WantedBy=multi-user.target
EOF
sudo systemctl daemon-reload
sudo systemctl enable --now rds-lab-app
sleep 8
curl -s http://127.0.0.1:5000/health
REMOTE
sed -i "s|__DB_ENDPOINT__|$DB_ENDPOINT|g; s|__DB_NAME__|$DB_NAME|g; s|__DB_USER__|$DB_USER|g; s|__DB_PASS__|$DB_PASS|g" app-setup.sh
json_for_ssm app-setup.sh app-setup-params.json
APP_CMD=$(aws ssm send-command --region "$REGION" --instance-ids "$EC2" --document-name AWS-RunShellScript --comment "$PREFIX-deploy-node-rds-app" --parameters file://app-setup-params.json --query Command.CommandId --output text)
save APP_CMD "$APP_CMD"
for n in {1..70}; do
  APP_STATUS=$(aws ssm get-command-invocation --region "$REGION" --command-id "$APP_CMD" --instance-id "$EC2" --query Status --output text 2>/dev/null || true)
  echo "App deploy SSM status=$APP_STATUS"
  [[ "$APP_STATUS" =~ ^(Success|Failed|TimedOut|Cancelled)$ ]] && break
  sleep 10
done
aws ssm get-command-invocation --region "$REGION" --command-id "$APP_CMD" --instance-id "$EC2" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json
[ "$APP_STATUS" = "Success" ]

APP_URL="http://$EC2IP:5000"
HEALTH_URL="$APP_URL/health"
for n in {1..20}; do
  if curl -fsS --max-time 10 "$HEALTH_URL"; then
    break
  fi
  sleep 10
done
save APP_URL "$APP_URL"
save HEALTH_URL "$HEALTH_URL"

echo "=== 6. Backup and Restore ==="
aws rds create-db-snapshot --region "$REGION" --db-instance-identifier "$DB_ID" --db-snapshot-identifier "$SNAP_ID" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-Manual-Snapshot" >/dev/null
aws rds wait db-snapshot-completed --region "$REGION" --db-snapshot-identifier "$SNAP_ID"
aws rds restore-db-instance-from-db-snapshot --region "$REGION" --db-instance-identifier "$RESTORE_ID" --db-snapshot-identifier "$SNAP_ID" --db-instance-class db.t3.micro --db-subnet-group-name "$DBSUBGROUP" --vpc-security-group-ids "$RDSSG" --no-publicly-accessible --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-RDS-Restore" >/dev/null
aws rds wait db-instance-available --region "$REGION" --db-instance-identifier "$RESTORE_ID"
RESTORE_ENDPOINT=$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$RESTORE_ID" --query 'DBInstances[0].Endpoint.Address' --output text)
save RESTORE_ENDPOINT "$RESTORE_ENDPOINT"

cat > restore-verify-remote.sh <<'REMOTE'
set -euxo pipefail
cd /home/ec2-user/rds-lab-app
RESTORE_ENDPOINT=__RESTORE_ENDPOINT__ DB_USER=__DB_USER__ DB_PASS=__DB_PASS__ DB_NAME=__DB_NAME__ node - <<'EOF'
const mysql = require('mysql2/promise');
(async()=>{
 const conn = await mysql.createConnection({host:process.env.RESTORE_ENDPOINT, user:process.env.DB_USER, password:process.env.DB_PASS, database:process.env.DB_NAME});
 const [rows] = await conn.query('SELECT COUNT(*) AS users FROM user');
 console.log(JSON.stringify({restoreEndpoint:process.env.RESTORE_ENDPOINT, users: rows[0].users}));
 await conn.end();
})().catch(e=>{ console.error(e); process.exit(1); });
EOF
REMOTE
sed -i "s|__RESTORE_ENDPOINT__|$RESTORE_ENDPOINT|g; s|__DB_USER__|$DB_USER|g; s|__DB_PASS__|$DB_PASS|g; s|__DB_NAME__|$DB_NAME|g" restore-verify-remote.sh
SSH_OPTS="-i $KEY.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10"
for n in {1..30}; do
  if ssh $SSH_OPTS "ec2-user@$EC2IP" 'echo ssh-ready' >/dev/null 2>&1; then
    break
  fi
  sleep 10
done
scp $SSH_OPTS restore-verify-remote.sh "ec2-user@$EC2IP:/tmp/restore-verify-remote.sh" >/dev/null
RESTORE_VERIFY_OUTPUT=$(ssh $SSH_OPTS "ec2-user@$EC2IP" 'bash /tmp/restore-verify-remote.sh')
echo "RESTORE_VERIFY_OUTPUT=$RESTORE_VERIFY_OUTPUT"
save RESTORE_VERIFY_OUTPUT "$RESTORE_VERIFY_OUTPUT"

echo "=== FINAL SUMMARY $PREFIX ==="
grep -v '^DB_PASS=' "$STATE"
echo "--- App health"
curl -fsS --max-time 10 "$HEALTH_URL" || true
echo
echo "--- RDS original"
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[0].{Status:DBInstanceStatus,Endpoint:Endpoint.Address,Engine:Engine,Class:DBInstanceClass,Public:PubliclyAccessible}' --output table
echo "--- Snapshot"
aws rds describe-db-snapshots --region "$REGION" --db-snapshot-identifier "$SNAP_ID" --query 'DBSnapshots[0].{Status:Status,Snapshot:DBSnapshotIdentifier,Source:DBInstanceIdentifier}' --output table
echo "--- RDS restored"
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$RESTORE_ID" --query 'DBInstances[0].{Status:DBInstanceStatus,Endpoint:Endpoint.Address,Engine:Engine,Class:DBInstanceClass,Public:PubliclyAccessible}' --output table
echo "=== DEPLOY_COMPLETE $PREFIX ==="
