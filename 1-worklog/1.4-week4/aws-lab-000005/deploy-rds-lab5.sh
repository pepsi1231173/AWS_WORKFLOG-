#!/usr/bin/env bash
set -Eeuo pipefail
export AWS_PAGER=""

REGION=ap-southeast-1
PROJECT=AwsStudyGroup000005RDS
PREFIX=RDS5-$(date +%m%d%H%M)
STATE=~/rds5-state.env
LOG=~/rds5-deploy.log
exec > >(tee -a "$LOG") 2>&1

echo "=== LAB 000005 RDS DEPLOY: $PREFIX in $REGION ==="
aws configure set region "$REGION"
ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
echo "Account=$ACCOUNT"

azs=($(aws ec2 describe-availability-zones --region "$REGION" --query "AvailabilityZones[?State=='available'].ZoneName" --output text))
AZ1=${azs[0]}
AZ2=${azs[1]:-${azs[0]}}
echo "AZ1=$AZ1 AZ2=$AZ2"

DB_ID=$(echo "${PREFIX}-mysql" | tr '[:upper:]' '[:lower:]')
RESTORE_ID=$(echo "${PREFIX}-mysql-restore" | tr '[:upper:]' '[:lower:]')
SNAP_ID=$(echo "${PREFIX}-snapshot" | tr '[:upper:]' '[:lower:]')
DB_NAME=first_cloud_users
DB_USER=admin
DB_PASS="RdsLab5!$(date +%s)"

save(){ echo "$1=$2" >> "$STATE"; }
: > "$STATE"
save PREFIX "$PREFIX"; save REGION "$REGION"; save PROJECT "$PROJECT"; save ACCOUNT "$ACCOUNT"
save DB_ID "$DB_ID"; save RESTORE_ID "$RESTORE_ID"; save SNAP_ID "$SNAP_ID"; save DB_NAME "$DB_NAME"; save DB_USER "$DB_USER"; save DB_PASS "$DB_PASS"

tag_ec2(){ aws ec2 create-tags --region "$REGION" --resources "$@" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" >/dev/null; }
name_ec2(){ aws ec2 create-tags --region "$REGION" --resources "$1" --tags Key=Name,Value="$2" Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" >/dev/null; }

echo "=== 2.1 Create VPC, public/private subnets, IGW and route table ==="
VPC=$(aws ec2 create-vpc --region "$REGION" --cidr-block 10.50.0.0/16 --query Vpc.VpcId --output text)
name_ec2 "$VPC" "$PREFIX-VPC"
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPC" --enable-dns-hostnames
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPC" --enable-dns-support
PUB=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.50.1.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text); name_ec2 "$PUB" "$PREFIX-Public-Subnet"
DBSUB1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.50.11.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text); name_ec2 "$DBSUB1" "$PREFIX-DB-Private-Subnet-AZ1"
DBSUB2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.50.12.0/24 --availability-zone "$AZ2" --query Subnet.SubnetId --output text); name_ec2 "$DBSUB2" "$PREFIX-DB-Private-Subnet-AZ2"
aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$PUB" --map-public-ip-on-launch
IGW=$(aws ec2 create-internet-gateway --region "$REGION" --query InternetGateway.InternetGatewayId --output text); name_ec2 "$IGW" "$PREFIX-IGW"
aws ec2 attach-internet-gateway --region "$REGION" --vpc-id "$VPC" --internet-gateway-id "$IGW"
RT=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$VPC" --query RouteTable.RouteTableId --output text); name_ec2 "$RT" "$PREFIX-Public-RT"
aws ec2 create-route --region "$REGION" --route-table-id "$RT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW" >/dev/null
ASSOC=$(aws ec2 associate-route-table --region "$REGION" --route-table-id "$RT" --subnet-id "$PUB" --query AssociationId --output text)
save VPC "$VPC"; save PUB "$PUB"; save DBSUB1 "$DBSUB1"; save DBSUB2 "$DBSUB2"; save IGW "$IGW"; save RT "$RT"; save ASSOC "$ASSOC"

echo "=== 2.2 Create EC2 Security Group ==="
EC2SG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-EC2-Web-App-SG" --description "Lab 000005 EC2 web app SG" --query GroupId --output text)
name_ec2 "$EC2SG" "$PREFIX-EC2-Web-App-SG"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$EC2SG" --ip-permissions \
  IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description="SSH lab access"}]' \
  IpProtocol=tcp,FromPort=80,ToPort=80,IpRanges='[{CidrIp=0.0.0.0/0,Description="HTTP"}]' \
  IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=0.0.0.0/0,Description="HTTPS"}]' \
  IpProtocol=tcp,FromPort=5000,ToPort=5000,IpRanges='[{CidrIp=0.0.0.0/0,Description="Node app"}]' >/dev/null || true
save EC2SG "$EC2SG"

echo "=== 2.3 Create RDS Security Group ==="
RDSSG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-RDS-MySQL-SG" --description "Lab 000005 RDS MySQL SG" --query GroupId --output text)
name_ec2 "$RDSSG" "$PREFIX-RDS-MySQL-SG"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$RDSSG" --ip-permissions IpProtocol=tcp,FromPort=3306,ToPort=3306,UserIdGroupPairs="[{GroupId=$EC2SG,Description='MySQL from EC2 web app SG'}]" >/dev/null
save RDSSG "$RDSSG"

echo "=== 2.4 Create DB Subnet Group ==="
DBSUBGROUP=$(echo "${PREFIX}-db-subnet-group" | tr '[:upper:]' '[:lower:]')
aws rds create-db-subnet-group --region "$REGION" --db-subnet-group-name "$DBSUBGROUP" --db-subnet-group-description "Lab 000005 RDS subnet group" --subnet-ids "$DBSUB1" "$DBSUB2" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-DB-Subnet-Group" >/dev/null
save DBSUBGROUP "$DBSUBGROUP"

echo "=== IAM role/profile for SSM-managed EC2 ==="
ROLE=${PREFIX}-EC2-SSM-Role
PROFILE=${PREFIX}-EC2-Profile
cat > trust-ec2.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
JSON
aws iam create-role --role-name "$ROLE" --assume-role-policy-document file://trust-ec2.json >/dev/null || true
aws iam attach-role-policy --role-name "$ROLE" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore || true
aws iam create-instance-profile --instance-profile-name "$PROFILE" >/dev/null || true
aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE" --role-name "$ROLE" >/dev/null || true
save ROLE "$ROLE"; save PROFILE "$PROFILE"
sleep 12

echo "=== 3. Create EC2 instance ==="
AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)
KEY=${PREFIX}-key
aws ec2 create-key-pair --region "$REGION" --key-name "$KEY" --key-type rsa --query KeyMaterial --output text > "$KEY.pem"
chmod 400 "$KEY.pem"
EC2=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI" --instance-type t3.micro --key-name "$KEY" --iam-instance-profile Name="$PROFILE" --subnet-id "$PUB" --security-group-ids "$EC2SG" --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-EC2-App},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
aws ec2 wait instance-running --region "$REGION" --instance-ids "$EC2"
EC2IP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$EC2" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
EC2PRIV=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$EC2" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
save AMI "$AMI"; save KEY "$KEY"; save EC2 "$EC2"; save EC2IP "$EC2IP"; save EC2PRIV "$EC2PRIV"

echo "=== 4. Create RDS database instance ==="
aws rds create-db-instance \
  --region "$REGION" \
  --db-instance-identifier "$DB_ID" \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --allocated-storage 20 \
  --storage-type gp3 \
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
echo "Waiting for RDS instance $DB_ID to become available..."
aws rds wait db-instance-available --region "$REGION" --db-instance-identifier "$DB_ID"
DB_ENDPOINT=$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[0].Endpoint.Address' --output text)
save DB_ENDPOINT "$DB_ENDPOINT"

echo "=== 5. Deploy application and seed database ==="
echo "Waiting for EC2 SSM Online..."
for n in {1..40}; do
  SSM=$(aws ssm describe-instance-information --region "$REGION" --filters Key=InstanceIds,Values="$EC2" --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null || true)
  echo "SSM=$SSM"
  [ "$SSM" = "Online" ] && break
  sleep 10
done

cat > app-setup-params.json <<JSON
{
  "commands": [
    "set -euxo pipefail\nsudo dnf install -y git nodejs npm\ncd /home/ec2-user\nrm -rf AWS-FCJ-Management rds-lab-app\ngit clone https://github.com/AWS-First-Cloud-Journey/AWS-FCJ-Management || true\nmkdir -p rds-lab-app\ncd rds-lab-app\ncat > package.json <<'EOFJSON'\n{\"scripts\":{\"start\":\"node index.js\"},\"dependencies\":{\"express\":\"^4.19.2\",\"mysql2\":\"^3.10.0\"}}\nEOFJSON\ncat > index.js <<'EOFAPP'\nconst express = require('express');\nconst mysql = require('mysql2/promise');\nconst app = express();\nconst port = 5000;\nconst db = { host: process.env.DB_HOST, user: process.env.DB_USER, password: process.env.DB_PASS, database: process.env.DB_NAME };\nconst seedUsers = [\n ['Amanda','Nunes','anunes@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Alexander','Volkanovski','avolkanovski@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Khabib','Nurmagomedov','knurmagomedov@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Kamaru','Usman','kusman@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Israel','Adesanya','iadesanya@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Henry','Cejudo','hcejudo@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Valentina','Shevchenko','vshevchenko@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Tyron','Woodley','twoodley@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Rose','Namajunas','rnamajunas@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Tony','Ferguson','tferguson@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Jorge','Masvidal','jmasvidal@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Nate','Diaz','ndiaz@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Conor','McGregor','cmcGregor@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Cris','Cyborg','ccyborg@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Tecia','Torres','ttorres@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Ronda','Rousey','rrousey@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Holly','Holm','hholm@ufc.com','012345 678910','I love AWS FCJ','active'],\n ['Joanna','Jedrzejczyk','jjedrzejczyk@ufc.com','012345 678910','I love AWS FCJ','active']\n];\nasync function init() {\n const conn = await mysql.createConnection(db);\n await conn.execute(`CREATE TABLE IF NOT EXISTS user (id INT NOT NULL AUTO_INCREMENT PRIMARY KEY, first_name VARCHAR(45) NOT NULL, last_name VARCHAR(45) NOT NULL, email VARCHAR(100) NOT NULL UNIQUE, phone VARCHAR(15) NOT NULL, comments TEXT NOT NULL, status ENUM('active','inactive') NOT NULL DEFAULT 'active') ENGINE=InnoDB`);\n for (const u of seedUsers) await conn.execute('INSERT IGNORE INTO user (first_name,last_name,email,phone,comments,status) VALUES (?,?,?,?,?,?)', u);\n await conn.end();\n}\nasync function queryUsers() { const conn = await mysql.createConnection(db); const [rows] = await conn.query('SELECT * FROM user ORDER BY id LIMIT 50'); await conn.end(); return rows; }\napp.get('/health', async (req, res) => { try { const rows = await queryUsers(); res.json({status:'ok', users: rows.length, dbHost: db.host}); } catch (e) { res.status(500).json({status:'error', message:e.message}); } });\napp.get('/', async (req, res) => {\n try { const rows = await queryUsers(); res.send(`<!doctype html><title>AWS FCJ RDS Lab</title><style>body{font-family:Arial;margin:32px;background:#f7f9fb;color:#17202a}table{border-collapse:collapse;width:100%;background:white}td,th{border:1px solid #d6dde5;padding:8px}th{background:#232f3e;color:white}.ok{color:#067d62;font-weight:bold}</style><h1>AWS FCJ Management - RDS Lab 000005</h1><p class=\"ok\">Connected to Amazon RDS MySQL: ${db.host}</p><p>Total users: ${rows.length}</p><table><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Status</th></tr>${rows.map(r=>`<tr><td>${r.id}</td><td>${r.first_name} ${r.last_name}</td><td>${r.email}</td><td>${r.phone}</td><td>${r.status}</td></tr>`).join('')}</table>`); } catch (e) { res.status(500).send(`<h1>DB error</h1><pre>${e.stack}</pre>`); }\n});\ninit().then(()=>app.listen(port, '0.0.0.0', ()=>console.log(`RDS lab app listening on ${port}`))).catch(e=>{ console.error(e); process.exit(1); });\nEOFAPP\nnpm install\ncat > /home/ec2-user/rds-lab-app/.env <<'EOFENV'\nDB_HOST=$DB_ENDPOINT\nDB_NAME=$DB_NAME\nDB_USER=$DB_USER\nDB_PASS=$DB_PASS\nEOFENV\nsudo tee /etc/systemd/system/rds-lab-app.service >/dev/null <<'EOFSVC'\n[Unit]\nDescription=RDS Lab 000005 Node App\nAfter=network.target\n[Service]\nType=simple\nWorkingDirectory=/home/ec2-user/rds-lab-app\nEnvironmentFile=/home/ec2-user/rds-lab-app/.env\nExecStart=/usr/bin/node /home/ec2-user/rds-lab-app/index.js\nRestart=always\nUser=ec2-user\n[Install]\nWantedBy=multi-user.target\nEOFSVC\nsudo systemctl daemon-reload\nsudo systemctl enable --now rds-lab-app\nsleep 8\ncurl -s http://127.0.0.1:5000/health\n"
  ]
}
JSON
APP_CMD=$(aws ssm send-command --region "$REGION" --instance-ids "$EC2" --document-name AWS-RunShellScript --comment "$PREFIX-deploy-node-rds-app" --parameters file://app-setup-params.json --query Command.CommandId --output text)
save APP_CMD "$APP_CMD"
sleep 15
for n in {1..60}; do
  APP_STATUS=$(aws ssm get-command-invocation --region "$REGION" --command-id "$APP_CMD" --instance-id "$EC2" --query Status --output text 2>/dev/null || true)
  echo "App deploy SSM status=$APP_STATUS"
  if [ "$APP_STATUS" = "Success" ] || [ "$APP_STATUS" = "Failed" ] || [ "$APP_STATUS" = "TimedOut" ] || [ "$APP_STATUS" = "Cancelled" ]; then
    break
  fi
  sleep 10
done
aws ssm get-command-invocation --region "$REGION" --command-id "$APP_CMD" --instance-id "$EC2" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json

APP_URL="http://$EC2IP:5000"
HEALTH_URL="$APP_URL/health"
echo "Testing public app: $HEALTH_URL"
for n in {1..20}; do
  if curl -fsS --max-time 10 "$HEALTH_URL"; then
    break
  fi
  sleep 10
done
save APP_URL "$APP_URL"; save HEALTH_URL "$HEALTH_URL"

echo "=== 6. Backup and Restore ==="
aws rds create-db-snapshot --region "$REGION" --db-instance-identifier "$DB_ID" --db-snapshot-identifier "$SNAP_ID" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-Manual-Snapshot" >/dev/null
echo "Waiting for snapshot $SNAP_ID..."
aws rds wait db-snapshot-completed --region "$REGION" --db-snapshot-identifier "$SNAP_ID"
aws rds restore-db-instance-from-db-snapshot --region "$REGION" --db-instance-identifier "$RESTORE_ID" --db-snapshot-identifier "$SNAP_ID" --db-instance-class db.t3.micro --db-subnet-group-name "$DBSUBGROUP" --vpc-security-group-ids "$RDSSG" --no-publicly-accessible --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" Key=Name,Value="$PREFIX-RDS-Restore" >/dev/null
echo "Waiting for restored RDS instance $RESTORE_ID..."
aws rds wait db-instance-available --region "$REGION" --db-instance-identifier "$RESTORE_ID"
RESTORE_ENDPOINT=$(aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$RESTORE_ID" --query 'DBInstances[0].Endpoint.Address' --output text)
save RESTORE_ENDPOINT "$RESTORE_ENDPOINT"

cat > restore-verify-params.json <<JSON
{
  "commands": [
    "set -euxo pipefail\ncd /home/ec2-user/rds-lab-app\nnode - <<'EOFNODE'\nconst mysql = require('mysql2/promise');\n(async()=>{ const conn = await mysql.createConnection({host:'$RESTORE_ENDPOINT', user:'$DB_USER', password:'$DB_PASS', database:'$DB_NAME'}); const [rows] = await conn.query('SELECT COUNT(*) AS users FROM user'); console.log(JSON.stringify({restoreEndpoint:'$RESTORE_ENDPOINT', users: rows[0].users})); await conn.end(); })().catch(e=>{console.error(e); process.exit(1);});\nEOFNODE\n"
  ]
}
JSON
RESTORE_VERIFY_CMD=$(aws ssm send-command --region "$REGION" --instance-ids "$EC2" --document-name AWS-RunShellScript --comment "$PREFIX-verify-restored-rds" --parameters file://restore-verify-params.json --query Command.CommandId --output text)
save RESTORE_VERIFY_CMD "$RESTORE_VERIFY_CMD"
sleep 10
aws ssm get-command-invocation --region "$REGION" --command-id "$RESTORE_VERIFY_CMD" --instance-id "$EC2" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json

echo "=== FINAL SUMMARY $PREFIX ==="
cat "$STATE"
echo "--- App health"
curl -fsS --max-time 10 "$HEALTH_URL" || true
echo
echo "--- RDS original"
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$DB_ID" --query 'DBInstances[0].{Status:DBInstanceStatus,Endpoint:Endpoint.Address,Engine:Engine,Class:DBInstanceClass}' --output table
echo "--- RDS restored"
aws rds describe-db-instances --region "$REGION" --db-instance-identifier "$RESTORE_ID" --query 'DBInstances[0].{Status:DBInstanceStatus,Endpoint:Endpoint.Address,Engine:Engine,Class:DBInstanceClass}' --output table
echo "=== DEPLOY_COMPLETE $PREFIX ==="
