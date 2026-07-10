source fcj_lab_state.env
BASE=$(aws ec2 describe-instances --region ap-southeast-1 \
  --filters Name=tag:Workshop,Values=FCJ-ASG-Lab-000006 Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')
DNS=$(aws ec2 describe-instances --region ap-southeast-1 --instance-ids "$BASE" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
echo "BASE=$BASE DNS=$DNS"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 \
  -i fcj-key-rerun.pem ec2-user@"$DNS" \
  "mysql -h '$DB_ENDPOINT' -P 3306 -u '$DB_USER' -p'$DB_PASS' <<'SQL'
ALTER USER 'admin'@'%' IDENTIFIED WITH mysql_native_password BY '123Vodanhphai';
CREATE USER IF NOT EXISTS 'fcjapp'@'%' IDENTIFIED WITH mysql_native_password BY '123Vodanhphai';
GRANT ALL PRIVILEGES ON awsfcjuser.* TO 'fcjapp'@'%';
FLUSH PRIVILEGES;
SQL
sudo sed -i \"s/DB_USER=.*/DB_USER='fcjapp'/\" /home/ec2-user/000004-EC2/.env
cd /home/ec2-user/000004-EC2
sudo pm2 restart fcj-management
sleep 5
sudo pm2 list
sudo ss -ltnp | grep -E ':3000|:80' || true" || true
curl -I --connect-timeout 5 "http://$DNS:3000/" || true
