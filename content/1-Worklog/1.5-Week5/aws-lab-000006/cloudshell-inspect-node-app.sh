BASE=$(aws ec2 describe-instances --region ap-southeast-1 \
  --filters Name=tag:Workshop,Values=FCJ-ASG-Lab-000006 Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')
DNS=$(aws ec2 describe-instances --region ap-southeast-1 --instance-ids "$BASE" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 \
  -i fcj-key-rerun.pem ec2-user@"$DNS" \
  "cd /home/ec2-user/000004-EC2; echo __PKG__; cat package.json; echo __APPJS__; sed -n '1,180p' app.js; echo __PM2_DESCRIBE__; sudo pm2 describe fcj-management; echo __LOGS__; sudo pm2 logs --lines 50 --nostream" || true
