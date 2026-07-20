echo "__AMI__"
aws ec2 describe-images --region ap-southeast-1 --owners self \
  --filters Name=name,Values=FCJ-Management-AMI \
  --query 'Images[].[ImageId,State,CreationDate]' --output table
echo "__LT__"
aws ec2 describe-launch-templates --region ap-southeast-1 \
  --launch-template-names FCJ-Management-template \
  --query 'LaunchTemplates[].[LaunchTemplateId,LaunchTemplateName]' --output table 2>/dev/null || true
echo "__LB__"
aws elbv2 describe-load-balancers --region ap-southeast-1 --names FCJ-Management-LB \
  --query 'LoadBalancers[].[LoadBalancerName,State.Code,DNSName]' --output table 2>/dev/null || true
echo "__ASG__"
aws autoscaling describe-auto-scaling-groups --region ap-southeast-1 --auto-scaling-group-names FCJ-Management-ASG \
  --query 'AutoScalingGroups[].[AutoScalingGroupName,DesiredCapacity,MinSize,MaxSize,length(Instances)]' --output table
