BASE=$(aws ec2 describe-instances --region ap-southeast-1 \
  --filters Name=tag:Workshop,Values=FCJ-ASG-Lab-000006 Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')
DNS=$(aws ec2 describe-instances --region ap-southeast-1 --instance-ids "$BASE" \
  --query 'Reservations[0].Instances[0].PublicDnsName' --output text)
echo "URL=http://$DNS:3000/"
curl -I --connect-timeout 5 "http://$DNS:3000/" || true
