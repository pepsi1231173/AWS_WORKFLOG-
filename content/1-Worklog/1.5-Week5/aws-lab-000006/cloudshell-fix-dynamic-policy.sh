clear
LB_ARN=$(aws elbv2 describe-load-balancers --region ap-southeast-1 --names FCJ-Management-LB --query 'LoadBalancers[0].LoadBalancerArn' --output text)
TG_ARN=$(aws elbv2 describe-target-groups --region ap-southeast-1 --names FCJ-Management-TG --query 'TargetGroups[0].TargetGroupArn' --output text)
RESOURCE_LABEL="$(echo "$LB_ARN" | sed 's#.*loadbalancer/##')/targetgroup/$(echo "$TG_ARN" | sed 's#.*targetgroup/##')"
cat > dynamic-policy.json <<POLICY
{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ALBRequestCountPerTarget",
    "ResourceLabel": "$RESOURCE_LABEL"
  },
  "TargetValue": 500.0
}
POLICY
aws autoscaling put-scaling-policy --region ap-southeast-1 \
  --auto-scaling-group-name FCJ-Management-ASG \
  --policy-name "Request Over 500 per target" \
  --policy-type TargetTrackingScaling \
  --target-tracking-configuration file://dynamic-policy.json >/dev/null
echo "__SCALING_POLICIES__"
aws autoscaling describe-policies --region ap-southeast-1 --auto-scaling-group-name FCJ-Management-ASG \
  --query 'ScalingPolicies[].[PolicyName,PolicyType]' --output table
echo "__SCHEDULED_ACTIONS__"
aws autoscaling describe-scheduled-actions --region ap-southeast-1 --auto-scaling-group-name FCJ-Management-ASG \
  --query 'ScheduledUpdateGroupActions[].[ScheduledActionName,DesiredCapacity,MinSize,MaxSize,StartTime]' --output table
