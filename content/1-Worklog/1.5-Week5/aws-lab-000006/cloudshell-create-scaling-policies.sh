LB_ARN=$(aws elbv2 describe-load-balancers --region ap-southeast-1 --names FCJ-Management-LB --query 'LoadBalancers[0].LoadBalancerArn' --output text)
TG_ARN=$(aws elbv2 describe-target-groups --region ap-southeast-1 --names FCJ-Management-TG --query 'TargetGroups[0].TargetGroupArn' --output text)
RESOURCE_LABEL="$(echo "$LB_ARN" | sed 's#.*loadbalancer/##')/$(echo "$TG_ARN" | sed 's#.*targetgroup/##')"
cat > dynamic-policy.json <<POLICY
{
  "PredefinedMetricSpecification": {
    "PredefinedMetricType": "ALBRequestCountPerTarget",
    "ResourceLabel": "$RESOURCE_LABEL"
  },
  "TargetValue": 500.0,
  "EstimatedInstanceWarmup": 60
}
POLICY
aws autoscaling put-scaling-policy --region ap-southeast-1 \
  --auto-scaling-group-name FCJ-Management-ASG \
  --policy-name "Request Over 500 per target" \
  --policy-type TargetTrackingScaling \
  --target-tracking-configuration file://dynamic-policy.json
START_TIME=$(date -u -d '+20 minutes' +%Y-%m-%dT%H:%M:%SZ)
aws autoscaling put-scheduled-update-group-action --region ap-southeast-1 \
  --auto-scaling-group-name FCJ-Management-ASG \
  --scheduled-action-name "Rush hour" \
  --start-time "$START_TIME" \
  --min-size 1 --max-size 3 --desired-capacity 2
echo "__SCALING_POLICIES__"
aws autoscaling describe-policies --region ap-southeast-1 --auto-scaling-group-name FCJ-Management-ASG \
  --query 'ScalingPolicies[].[PolicyName,PolicyType]' --output table
echo "__SCHEDULED_ACTIONS__"
aws autoscaling describe-scheduled-actions --region ap-southeast-1 --auto-scaling-group-name FCJ-Management-ASG \
  --query 'ScheduledUpdateGroupActions[].[ScheduledActionName,DesiredCapacity,MinSize,MaxSize,StartTime]' --output table
