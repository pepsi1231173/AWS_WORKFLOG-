echo CHECK_LAB6_STATUS
aws rds describe-db-instances \
  --region ap-southeast-1 \
  --query "DBInstances[?DBInstanceIdentifier=='fcj-management-db-instance'].{id:DBInstanceIdentifier,status:DBInstanceStatus,endpoint:Endpoint.Address}" \
  --output table
aws ec2 describe-vpcs \
  --region ap-southeast-1 \
  --filters Name=tag:Name,Values=AutoScaling-Lab \
  --query 'Vpcs[].VpcId' \
  --output table
aws autoscaling describe-auto-scaling-groups \
  --region ap-southeast-1 \
  --auto-scaling-group-names FCJ-Management-ASG \
  --query 'AutoScalingGroups[].{Name:AutoScalingGroupName,Desired:DesiredCapacity}' \
  --output table
