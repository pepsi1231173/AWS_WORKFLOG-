source fcj_lab_state.env
BASE=$(aws ec2 describe-instances --region ap-southeast-1 \
  --filters Name=tag:Workshop,Values=FCJ-ASG-Lab-000006 Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')
DNS=$(aws ec2 describe-instances --region ap-southeast-1 --instance-ids "$BASE" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
echo "BASE=$BASE DNS=$DNS"
curl -I --connect-timeout 5 "http://$DNS:3000/" || true
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 \
  -i fcj-key-rerun.pem ec2-user@"$DNS" \
  "sudo pm2 list; sudo pm2 logs --lines 80 --nostream; sudo ss -ltnp | grep -E ':3000|:80' || true; sudo cat /home/ec2-user/000004-EC2/.env" || true
