LB_DNS=$(aws elbv2 describe-load-balancers --region ap-southeast-1 --names FCJ-Management-LB --query 'LoadBalancers[0].DNSName' --output text)
TG_ARN=$(aws elbv2 describe-target-groups --region ap-southeast-1 --names FCJ-Management-TG --query 'TargetGroups[0].TargetGroupArn' --output text)
echo "LB_DNS=$LB_DNS"
echo "TG_ARN=$TG_ARN"
aws elbv2 describe-load-balancers --region ap-southeast-1 --names FCJ-Management-LB \
  --query 'LoadBalancers[].[LoadBalancerName,State.Code,DNSName]' --output table
aws elbv2 describe-target-health --region ap-southeast-1 --target-group-arn "$TG_ARN" \
  --query 'TargetHealthDescriptions[].[Target.Id,Target.Port,TargetHealth.State]' --output table
curl -I --connect-timeout 8 "http://$LB_DNS/" || true
