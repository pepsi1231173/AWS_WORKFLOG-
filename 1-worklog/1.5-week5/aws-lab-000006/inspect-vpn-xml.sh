#!/usr/bin/env bash
set -Eeuo pipefail

source ~/rlws-state.env
XML="${PREFIX}-vpn-config.xml"
export XML
python3 - <<'PY'
import xml.etree.ElementTree as ET
import os
xml = os.environ.get("XML")
root = ET.parse(xml).getroot()
for idx, tunnel in enumerate(root.findall(".//ipsec_tunnel"), 1):
    print("TUNNEL", idx)
    for path in [
        "customer_gateway/tunnel_outside_address/ip_address",
        "vpn_gateway/tunnel_outside_address/ip_address",
        "customer_gateway/tunnel_inside_address/ip_address",
        "vpn_gateway/tunnel_inside_address/ip_address",
        "ike/pre_shared_key",
    ]:
        el = tunnel.find(path)
        print(path, "=", el.text if el is not None else None)
PY
