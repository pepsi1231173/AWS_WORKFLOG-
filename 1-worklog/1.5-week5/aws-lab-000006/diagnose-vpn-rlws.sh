#!/usr/bin/env bash
set -Eeuo pipefail
export AWS_PAGER=""
source ~/rlws-state.env
REGION=${REGION:-ap-southeast-1}

cat > ssm-diagnose-vpn.json <<'JSON'
{"commands":["sudo ipsec status || true\nsudo ipsec auto --status || true\nsudo journalctl -u ipsec -n 80 --no-pager || true\nsudo cat /etc/ipsec.d/aws.conf || true"]}
JSON

CMD=$(aws ssm send-command --region "$REGION" --instance-ids "$CGWINST" --document-name AWS-RunShellScript --comment "${PREFIX}-diagnose-vpn" --parameters file://ssm-diagnose-vpn.json --query Command.CommandId --output text)
sleep 8
for n in {1..20}; do
  STATUS=$(aws ssm get-command-invocation --region "$REGION" --command-id "$CMD" --instance-id "$CGWINST" --query Status --output text 2>/dev/null || true)
  if [ "$STATUS" = "Success" ] || [ "$STATUS" = "Failed" ] || [ "$STATUS" = "TimedOut" ]; then
    break
  fi
  sleep 5
done
aws ssm get-command-invocation --region "$REGION" --command-id "$CMD" --instance-id "$CGWINST" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output text
