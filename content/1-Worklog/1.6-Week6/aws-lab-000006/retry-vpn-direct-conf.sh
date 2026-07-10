#!/usr/bin/env bash
set -Eeuo pipefail
export AWS_PAGER=""
source ~/rlws-state.env
REGION=${REGION:-ap-southeast-1}
export PREFIX

python3 - <<'PY' > ssm-vpn-direct.json
import json
import os
import xml.etree.ElementTree as ET

prefix = os.environ["PREFIX"]
root = ET.parse(f"{prefix}-vpn-config.xml").getroot()
tunnels = []
for tunnel in root.findall(".//ipsec_tunnel"):
    tunnels.append({
        "cgw_out": tunnel.find("customer_gateway/tunnel_outside_address/ip_address").text,
        "vgw_out": tunnel.find("vpn_gateway/tunnel_outside_address/ip_address").text,
        "psk": tunnel.find("ike/pre_shared_key").text,
    })

leftid = tunnels[0]["cgw_out"]
conf = f"""version 2.0

config setup
    uniqueids=no
    protostack=netkey

conn %default
    authby=secret
    type=tunnel
    left=%defaultroute
    leftid={leftid}
    leftsubnet=10.20.0.0/16
    rightsubnet=10.10.0.0/16
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
    encapsulation=yes
    auto=start

conn aws-tunnel-1
    right={tunnels[0]['vgw_out']}

conn aws-tunnel-2
    right={tunnels[1]['vgw_out']}
"""
secrets = "\n".join([f"{leftid} {t['vgw_out']}: PSK \"{t['psk']}\"" for t in tunnels]) + "\n"
remote = f"""set -euxo pipefail
sudo tee /etc/ipsec.conf >/dev/null <<'EOFCONF'
{conf}
EOFCONF
sudo tee /etc/ipsec.secrets >/dev/null <<'EOFSECRET'
{secrets}
EOFSECRET
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w net.ipv4.conf.default.rp_filter=0
sudo sysctl -w net.ipv4.conf.all.rp_filter=0
sudo systemctl restart ipsec
sleep 15
sudo ipsec auto --status | egrep 'aws-tunnel|STATE|ESTABLISHED|erouted' || true
sudo ipsec whack --trafficstatus || true
"""
print(json.dumps({"commands": [remote]}))
PY

CMD=$(aws ssm send-command --region "$REGION" --instance-ids "$CGWINST" --document-name AWS-RunShellScript --comment "${PREFIX}-retry-vpn-direct-conf" --parameters file://ssm-vpn-direct.json --query Command.CommandId --output text)
sleep 8
for n in {1..30}; do
  STATUS=$(aws ssm get-command-invocation --region "$REGION" --command-id "$CMD" --instance-id "$CGWINST" --query Status --output text 2>/dev/null || true)
  if [ "$STATUS" = "Success" ] || [ "$STATUS" = "Failed" ] || [ "$STATUS" = "TimedOut" ]; then
    break
  fi
  sleep 5
done
aws ssm get-command-invocation --region "$REGION" --command-id "$CMD" --instance-id "$CGWINST" --query '{Status:Status,Output:StandardOutputContent,Error:StandardErrorContent}' --output json
sleep 60
aws ec2 describe-vpn-connections --region "$REGION" --vpn-connection-ids "$VPNCONN" --query 'VpnConnections[0].VgwTelemetry[*].{OutsideIp:OutsideIpAddress,Status:Status,Message:StatusMessage}' --output table
