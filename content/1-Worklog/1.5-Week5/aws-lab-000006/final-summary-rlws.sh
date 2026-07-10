#!/usr/bin/env bash
set -Eeuo pipefail
export AWS_PAGER=""
source ~/rlws-state.env
REGION=${REGION:-ap-southeast-1}

echo "=== FINAL WORKSHOP SUMMARY: $PREFIX ($REGION) ==="
echo "Main VPC: $VPC"
echo "Subnets: $PUB1 $PUB2 $PRI1 $PRI2"
echo "EC2 Public:  $PUBINST public=$PUBIP private=10.10.1.160"
echo "EC2 Private: $PRIINST private=$PRIIP"
echo "NAT Gateways: $NAT1 $NAT2"
echo "Reachability analysis: $ANALYSIS"
aws ec2 describe-network-insights-analyses --region "$REGION" --network-insights-analysis-ids "$ANALYSIS" --query 'NetworkInsightsAnalyses[0].{Status:Status,NetworkPathFound:NetworkPathFound}' --output table

run_short(){
  local iid="$1"; shift
  local label="$1"; shift
  local command="$*"
  echo "--- $label"
  cid=$(aws ssm send-command --region "$REGION" --instance-ids "$iid" --document-name AWS-RunShellScript --comment "$label" --parameters commands="$command" --query Command.CommandId --output text)
  sleep 6
  aws ssm get-command-invocation --region "$REGION" --command-id "$cid" --instance-id "$iid" --query '{Status:Status,Output:StandardOutputContent}' --output text
}

run_short "$PUBINST" "public-ping-private" "ping -c 2 $PRIIP"
run_short "$PRIINST" "private-https-through-nat" "curl -Is --max-time 15 https://aws.amazon.com | head -n 3"

echo "--- VPN connection: $VPNCONN"
aws ec2 describe-vpn-connections --region "$REGION" --vpn-connection-ids "$VPNCONN" --query 'VpnConnections[0].VgwTelemetry[*].{OutsideIp:OutsideIpAddress,Status:Status}' --output table
echo "=== SUMMARY_DONE ==="
