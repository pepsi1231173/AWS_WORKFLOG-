source fcj_lab_state.env
BASE=$(aws ec2 describe-instances --region ap-southeast-1 \
  --filters Name=tag:Workshop,Values=FCJ-ASG-Lab-000006 Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')
DNS=$(aws ec2 describe-instances --region ap-southeast-1 --instance-ids "$BASE" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
echo "BASE=$BASE"
echo "DNS=$DNS"
aws ec2 authorize-security-group-ingress --region ap-southeast-1 --group-id "$APP_SG_ID" \
  --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description=TempSSHDebug}]' >/dev/null 2>&1 || true
chmod 400 fcj-key-rerun.pem
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -o ConnectTimeout=10 \
  -i fcj-key-rerun.pem ec2-user@"$DNS" \
  "sudo tail -160 /var/log/cloud-init-output.log; echo __APP__; ls -la /home/ec2-user/000004-EC2 2>/dev/null || true; ps aux | grep -E 'node|pm2' | grep -v grep || true; sudo ss -ltnp | grep -E ':3000|:80' || true" || true
