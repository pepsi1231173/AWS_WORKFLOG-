echo "__SCALING_POLICIES__"
aws autoscaling describe-policies --region ap-southeast-1 --auto-scaling-group-name FCJ-Management-ASG \
  --query 'ScalingPolicies[].[PolicyName,PolicyType]' --output table
echo "__SCHEDULED_ACTIONS__"
aws autoscaling describe-scheduled-actions --region ap-southeast-1 --auto-scaling-group-name FCJ-Management-ASG \
  --query 'ScheduledUpdateGroupActions[].[ScheduledActionName,DesiredCapacity,MinSize,MaxSize,StartTime]' --output table
echo "__ASG_CAPACITY__"
aws autoscaling describe-auto-scaling-groups --region ap-southeast-1 --auto-scaling-group-names FCJ-Management-ASG \
  --query 'AutoScalingGroups[].[AutoScalingGroupName,DesiredCapacity,MinSize,MaxSize,length(Instances)]' --output table
