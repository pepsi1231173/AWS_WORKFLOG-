#!/usr/bin/env bash
set -Eeuo pipefail

source ~/rlws-state.env
REGION=${REGION:-ap-southeast-1}
XML="${PREFIX}-vpn-config.xml"
export PREFIX

python3 - <<'PY' > ssm-vpn-params.json
import json
import os
import xml.etree.ElementTree as ET

prefix = os.environ["PREFIX"]
xml = f"{prefix}-vpn-config.xml"
root = ET.parse(xml).getroot()
tunnels = []
for tunnel in root.findall(".//ipsec_tunnel"):
    tunnels.append({
        "cgw_out": tunnel.find("customer_gateway/tunnel_outside_address/ip_address").text,
        "vgw_out": tunnel.find("vpn_gateway/tunnel_outside_address/ip_address").text,
        "psk": tunnel.find("ike/pre_shared_key").text,
    })

leftid = tunnels[0]["cgw_out"]
conf = f"""config setup
    uniqueids=no
    protostack=netkey

conn %default
    authby=secret
    type=tunnel
    left=%defaultroute
    leftid={leftid}
    leftsubnet=10.20.0.0/16
    rightsubnet=10.10.0.0/16
    keyexchange=ike
    ikev2=never
    ike=aes128-sha1;modp1024
    phase2alg=aes128-sha1;modp1024
    ikelifetime=8h
    salifetime=1h
    pfs=yes
    keyingtries=%forever
    dpddelay=10
    dpdtimeout=30
    dpdaction=restart
    auto=start

conn aws-tunnel-1
    right={tunnels[0]['vgw_out']}

conn aws-tunnel-2
    right={tunnels[1]['vgw_out']}
"""
secrets = "\n".join([f"{leftid} {t['vgw_out']}: PSK \"{t['psk']}\"" for t in tunnels]) + "\n"
remote = f"""set -euxo pipefail
sudo dnf install -y libreswan
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.default.rp_filter=0
sudo sysctl -w net.ipv4.conf.all.rp_filter=0
sudo tee /etc/ipsec.d/aws.conf >/dev/null <<'EOFCONF'
{conf}
EOFCONF
sudo tee /etc/ipsec.d/aws.secrets >/dev/null <<'EOFSECRET'
{secrets}
EOFSECRET
sudo systemctl enable ipsec
sudo systemctl restart ipsec
sleep 20
sudo ipsec status || true
sudo ipsec trafficstatus || true
"""
print(json.dumps({"commands": [remote]}))
PY

echo "Sending VPN config to $CGWINST"
CMD=$(aws ssm send-command --region "$REGION" --instance-ids "$CGWINST" --document-name AWS-RunShellScript --comment "${PREFIX}-configure-vpn-cgw" --parameters file://ssm-vpn-params.json --query Command.CommandId --output text)
echo "SSM command: $CMD"
sleep 15
for n in {1..60}; do
  STATUS=$(aws ssm get-command-invocation --region "$REGION" --command-id "$CMD" --instance-id "$CGWINST" --query Status --output text 2>/dev/null || true)
  echo "SSM status: $STATUS"
  if [ "$STATUS" = "Success" ] || [ "$STATUS" = "Failed" ] || [ "$STATUS" = "Cancelled" ] || [ "$STATUS" = "TimedOut" ]; then
    break
  fi
  sleep 10
done
aws ssm get-command-invocation --region "$REGION" --command-id "$CMD" --instance-id "$CGWINST" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json

echo "Waiting for VPN telemetry to update..."
sleep 45
aws ec2 describe-vpn-connections --region "$REGION" --vpn-connection-ids "$VPNCONN" --query 'VpnConnections[0].VgwTelemetry[*].{OutsideIp:OutsideIpAddress,Status:Status,Message:StatusMessage}' --output table

echo "Testing private subnet NAT with HTTPS instead of ICMP..."
cat > ssm-nat-params.json <<'JSON'
{"commands":["curl -Is --max-time 15 https://aws.amazon.com | head -n 5"]}
JSON
NATCMD=$(aws ssm send-command --region "$REGION" --instance-ids "$PRIINST" --document-name AWS-RunShellScript --comment "${PREFIX}-private-nat-curl" --parameters file://ssm-nat-params.json --query Command.CommandId --output text)
sleep 8
aws ssm get-command-invocation --region "$REGION" --command-id "$NATCMD" --instance-id "$PRIINST" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json

echo "=== VPN_CONFIG_ATTEMPT_COMPLETE $PREFIX ==="
