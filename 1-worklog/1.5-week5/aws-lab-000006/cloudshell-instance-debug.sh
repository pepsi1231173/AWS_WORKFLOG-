BASE=$(aws ec2 describe-instances --region ap-southeast-1 \
  --filters Name=tag:Workshop,Values=FCJ-ASG-Lab-000006 Name=instance-state-name,Values=running \
  --query 'Reservations[].Instances[0].InstanceId' --output text | awk '{print $NF}')
echo "BASE=$BASE"
aws ec2 get-console-output --region ap-southeast-1 --instance-id "$BASE" --latest --output text | tail -120 || true
