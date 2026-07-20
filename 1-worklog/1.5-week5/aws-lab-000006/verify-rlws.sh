#!/usr/bin/env bash
set -Eeuo pipefail

source ~/rlws-state.env
REGION=${REGION:-ap-southeast-1}
echo "=== VERIFY $PREFIX ==="

for i in "$PUBINST" "$PRIINST" "$CGWINST"; do
  echo "Waiting SSM online: $i"
  for n in {1..30}; do
    status=$(aws ssm describe-instance-information --region "$REGION" --filters Key=InstanceIds,Values="$i" --query 'InstanceInformationList[0].PingStatus' --output text 2>/dev/null || true)
    echo "$i SSM=$status"
    [ "$status" = "Online" ] && break
    sleep 10
  done
done

run_cmd(){
  local iid="$1"; shift
  local label="$1"; shift
  local command="$*"
  echo "--- $label on $iid: $command"
  cid=$(aws ssm send-command --region "$REGION" --instance-ids "$iid" --document-name AWS-RunShellScript --comment "$label" --parameters commands="$command" --query Command.CommandId --output text)
  sleep 8
  for n in {1..20}; do
    st=$(aws ssm get-command-invocation --region "$REGION" --command-id "$cid" --instance-id "$iid" --query Status --output text 2>/dev/null || true)
    if [ "$st" = "Success" ] || [ "$st" = "Failed" ] || [ "$st" = "Cancelled" ] || [ "$st" = "TimedOut" ]; then
      break
    fi
    sleep 5
  done
  aws ssm get-command-invocation --region "$REGION" --command-id "$cid" --instance-id "$iid" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json
}

run_cmd "$PUBINST" "public-ping-private" "ping -c 4 $PRIIP"
run_cmd "$PRIINST" "private-ping-internet" "ping -c 4 amazon.com"
run_cmd "$CGWINST" "customer-gateway-basic" "ip route; ping -c 4 $PRIIP || true"

echo "--- Reachability analysis"
aws ec2 describe-network-insights-analyses --region "$REGION" --network-insights-analysis-ids "$ANALYSIS" --query 'NetworkInsightsAnalyses[0].{Status:Status,NetworkPathFound:NetworkPathFound,Explanation:Explanations[0].ExplanationCode}' --output json

echo "--- VPN telemetry"
aws ec2 describe-vpn-connections --region "$REGION" --vpn-connection-ids "$VPNCONN" --query 'VpnConnections[0].VgwTelemetry[*].{OutsideIp:OutsideIpAddress,Status:Status,Message:StatusMessage}' --output table

echo "=== VERIFY_COMPLETE $PREFIX ==="
