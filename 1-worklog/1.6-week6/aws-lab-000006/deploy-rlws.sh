#!/usr/bin/env bash
set -Eeuo pipefail

REGION=ap-southeast-1
PROJECT=RoughLifeAwsWorkshop
PREFIX=RLWS-$(date +%m%d%H%M)
LOG=~/rlws-deploy.log
STATE=~/rlws-state.env
exec > >(tee -a "$LOG") 2>&1

echo "=== RoughLife AWS Workshop deploy: $PREFIX in $REGION ==="
aws configure set region "$REGION"
ACCOUNT=$(aws sts get-caller-identity --query Account --output text)
echo "Account=$ACCOUNT Region=$REGION"

azs=($(aws ec2 describe-availability-zones --region "$REGION" --query "AvailabilityZones[?State=='available'].ZoneName" --output text))
AZ1=${azs[0]}
AZ2=${azs[1]:-${azs[0]}}
echo "AZ1=$AZ1 AZ2=$AZ2"

save(){ echo "$1=$2" >> "$STATE"; }
: > "$STATE"
save PREFIX "$PREFIX"; save REGION "$REGION"; save PROJECT "$PROJECT"; save ACCOUNT "$ACCOUNT"
tag(){ aws ec2 create-tags --region "$REGION" --resources "$@" --tags Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" >/dev/null; }
name(){ aws ec2 create-tags --region "$REGION" --resources "$1" --tags Key=Name,Value="$2" Key=Project,Value="$PROJECT" Key=Workshop,Value="$PREFIX" >/dev/null; }

# IAM roles for EC2 Session Manager and VPC Flow Logs.
ROLE=${PREFIX}-EC2-SSM-Role
PROFILE=${PREFIX}-EC2-Profile
cat > trust-ec2.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"ec2.amazonaws.com"},"Action":"sts:AssumeRole"}]}
JSON
aws iam create-role --role-name "$ROLE" --assume-role-policy-document file://trust-ec2.json >/dev/null || true
aws iam attach-role-policy --role-name "$ROLE" --policy-arn arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore || true
aws iam create-instance-profile --instance-profile-name "$PROFILE" >/dev/null || true
aws iam add-role-to-instance-profile --instance-profile-name "$PROFILE" --role-name "$ROLE" >/dev/null || true
sleep 12
save ROLE "$ROLE"; save PROFILE "$PROFILE"

FLOW_ROLE=${PREFIX}-FlowLogs-Role
cat > trust-flow.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Principal":{"Service":"vpc-flow-logs.amazonaws.com"},"Action":"sts:AssumeRole"}]}
JSON
cat > flow-policy.json <<'JSON'
{"Version":"2012-10-17","Statement":[{"Effect":"Allow","Action":["logs:CreateLogGroup","logs:CreateLogStream","logs:PutLogEvents","logs:DescribeLogGroups","logs:DescribeLogStreams"],"Resource":"*"}]}
JSON
aws iam create-role --role-name "$FLOW_ROLE" --assume-role-policy-document file://trust-flow.json >/dev/null || true
aws iam put-role-policy --role-name "$FLOW_ROLE" --policy-name flowlogsDeliveryRolePolicy --policy-document file://flow-policy.json >/dev/null || true
FLOW_ARN=$(aws iam get-role --role-name "$FLOW_ROLE" --query Role.Arn --output text)
save FLOW_ROLE "$FLOW_ROLE"

# Main VPC: 10.10.0.0/16.
VPC=$(aws ec2 create-vpc --region "$REGION" --cidr-block 10.10.0.0/16 --query Vpc.VpcId --output text)
name "$VPC" "$PREFIX-Main-VPC"
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPC" --enable-dns-hostnames
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPC" --enable-dns-support
save VPC "$VPC"

PUB1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.10.1.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text); name "$PUB1" "$PREFIX-Public-Subnet-AZ1"
PUB2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.10.2.0/24 --availability-zone "$AZ2" --query Subnet.SubnetId --output text); name "$PUB2" "$PREFIX-Public-Subnet-AZ2"
PRI1=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.10.3.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text); name "$PRI1" "$PREFIX-Private-Subnet-AZ1"
PRI2=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPC" --cidr-block 10.10.4.0/24 --availability-zone "$AZ2" --query Subnet.SubnetId --output text); name "$PRI2" "$PREFIX-Private-Subnet-AZ2"
for s in "$PUB1" "$PUB2"; do aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$s" --map-public-ip-on-launch; done
save PUB1 "$PUB1"; save PUB2 "$PUB2"; save PRI1 "$PRI1"; save PRI2 "$PRI2"

IGW=$(aws ec2 create-internet-gateway --region "$REGION" --query InternetGateway.InternetGatewayId --output text); name "$IGW" "$PREFIX-IGW"
aws ec2 attach-internet-gateway --region "$REGION" --vpc-id "$VPC" --internet-gateway-id "$IGW"
save IGW "$IGW"
PUBRT=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$VPC" --query RouteTable.RouteTableId --output text); name "$PUBRT" "$PREFIX-Public-RT"
aws ec2 create-route --region "$REGION" --route-table-id "$PUBRT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$IGW" >/dev/null
aws ec2 associate-route-table --region "$REGION" --route-table-id "$PUBRT" --subnet-id "$PUB1" >/dev/null
aws ec2 associate-route-table --region "$REGION" --route-table-id "$PUBRT" --subnet-id "$PUB2" >/dev/null
PRIRT1=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$VPC" --query RouteTable.RouteTableId --output text); name "$PRIRT1" "$PREFIX-Private-RT-AZ1"
PRIRT2=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$VPC" --query RouteTable.RouteTableId --output text); name "$PRIRT2" "$PREFIX-Private-RT-AZ2"
aws ec2 associate-route-table --region "$REGION" --route-table-id "$PRIRT1" --subnet-id "$PRI1" >/dev/null
aws ec2 associate-route-table --region "$REGION" --route-table-id "$PRIRT2" --subnet-id "$PRI2" >/dev/null
save PUBRT "$PUBRT"; save PRIRT1 "$PRIRT1"; save PRIRT2 "$PRIRT2"

PUBSG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-Public-SG" --description "Public subnet SG" --query GroupId --output text); name "$PUBSG" "$PREFIX-Public-SG"
PRISG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-Private-SG" --description "Private subnet SG" --query GroupId --output text); name "$PRISG" "$PREFIX-Private-SG"
EPSG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPC" --group-name "$PREFIX-VPCEndpoints-SG" --description "VPC endpoints SG" --query GroupId --output text); name "$EPSG" "$PREFIX-VPCEndpoints-SG"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$PUBSG" --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description="SSH lab access"}]' IpProtocol=icmp,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=10.10.0.0/16,Description="ICMP in main VPC"},{CidrIp=10.20.0.0/16,Description="ICMP from VPN VPC"}]' >/dev/null || true
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$PRISG" --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,UserIdGroupPairs="[{GroupId=$PUBSG,Description='SSH from public SG'}]" IpProtocol=icmp,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=10.10.0.0/16,Description="ICMP in main VPC"},{CidrIp=10.20.0.0/16,Description="ICMP from VPN VPC"}]' >/dev/null || true
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$EPSG" --ip-permissions IpProtocol=tcp,FromPort=443,ToPort=443,IpRanges='[{CidrIp=10.10.0.0/16,Description="HTTPS from VPC"}]' >/dev/null || true
save PUBSG "$PUBSG"; save PRISG "$PRISG"; save EPSG "$EPSG"

LOGGROUP=/aws/vpc/flowlogs/$PREFIX
aws logs create-log-group --region "$REGION" --log-group-name "$LOGGROUP" >/dev/null || true
FLOW=$(aws ec2 create-flow-logs --region "$REGION" --resource-type VPC --resource-ids "$VPC" --traffic-type ALL --log-destination-type cloud-watch-logs --log-group-name "$LOGGROUP" --deliver-logs-permission-arn "$FLOW_ARN" --tag-specifications "ResourceType=vpc-flow-log,Tags=[{Key=Name,Value=$PREFIX-VPC-FlowLogs},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query FlowLogIds[0] --output text)
save LOGGROUP "$LOGGROUP"; save FLOW "$FLOW"

for svc in ssm ssmmessages ec2messages; do
  ep=$(aws ec2 create-vpc-endpoint --region "$REGION" --vpc-id "$VPC" --service-name "com.amazonaws.$REGION.$svc" --vpc-endpoint-type Interface --subnet-ids "$PRI1" "$PRI2" --security-group-ids "$EPSG" --private-dns-enabled --query VpcEndpoint.VpcEndpointId --output text)
  name "$ep" "$PREFIX-$svc-endpoint"; save "EP_${svc}" "$ep"
done

# NAT gateways.
EIP1=$(aws ec2 allocate-address --region "$REGION" --domain vpc --query AllocationId --output text); tag "$EIP1"; aws ec2 create-tags --region "$REGION" --resources "$EIP1" --tags Key=Name,Value="$PREFIX-EIP-NAT-AZ1" >/dev/null
EIP2=$(aws ec2 allocate-address --region "$REGION" --domain vpc --query AllocationId --output text); tag "$EIP2"; aws ec2 create-tags --region "$REGION" --resources "$EIP2" --tags Key=Name,Value="$PREFIX-EIP-NAT-AZ2" >/dev/null
NAT1=$(aws ec2 create-nat-gateway --region "$REGION" --subnet-id "$PUB1" --allocation-id "$EIP1" --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=$PREFIX-NAT-Gateway-AZ1},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query NatGateway.NatGatewayId --output text)
NAT2=$(aws ec2 create-nat-gateway --region "$REGION" --subnet-id "$PUB2" --allocation-id "$EIP2" --tag-specifications "ResourceType=natgateway,Tags=[{Key=Name,Value=$PREFIX-NAT-Gateway-AZ2},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query NatGateway.NatGatewayId --output text)
echo "Waiting for NAT gateways: $NAT1 $NAT2"
aws ec2 wait nat-gateway-available --region "$REGION" --nat-gateway-ids "$NAT1" "$NAT2"
aws ec2 create-route --region "$REGION" --route-table-id "$PRIRT1" --destination-cidr-block 0.0.0.0/0 --nat-gateway-id "$NAT1" >/dev/null
aws ec2 create-route --region "$REGION" --route-table-id "$PRIRT2" --destination-cidr-block 0.0.0.0/0 --nat-gateway-id "$NAT2" >/dev/null
save NAT1 "$NAT1"; save NAT2 "$NAT2"

# EC2 instances.
AMI=$(aws ssm get-parameter --region "$REGION" --name /aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64 --query Parameter.Value --output text)
KEY=${PREFIX}-key
aws ec2 create-key-pair --region "$REGION" --key-name "$KEY" --key-type rsa --query KeyMaterial --output text > "$KEY.pem"
chmod 400 "$KEY.pem"
save KEY "$KEY"; save AMI "$AMI"
PUBINST=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI" --instance-type t3.micro --key-name "$KEY" --iam-instance-profile Name="$PROFILE" --subnet-id "$PUB1" --security-group-ids "$PUBSG" --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-EC2-Public},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
PRIINST=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI" --instance-type t3.micro --key-name "$KEY" --iam-instance-profile Name="$PROFILE" --subnet-id "$PRI1" --security-group-ids "$PRISG" --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-EC2-Private},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
echo "Waiting for EC2 instances: $PUBINST $PRIINST"
aws ec2 wait instance-running --region "$REGION" --instance-ids "$PUBINST" "$PRIINST"
save PUBINST "$PUBINST"; save PRIINST "$PRIINST"
PUBIP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$PUBINST" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
PRIIP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$PRIINST" --query 'Reservations[0].Instances[0].PrivateIpAddress' --output text)
save PUBIP "$PUBIP"; save PRIIP "$PRIIP"

# Reachability Analyzer.
PUBENI=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$PUBINST" --query 'Reservations[0].Instances[0].NetworkInterfaces[0].NetworkInterfaceId' --output text)
PRIENI=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$PRIINST" --query 'Reservations[0].Instances[0].NetworkInterfaces[0].NetworkInterfaceId' --output text)
PATHID=$(aws ec2 create-network-insights-path --region "$REGION" --source "$PUBENI" --destination "$PRIENI" --protocol tcp --destination-port 22 --tag-specifications "ResourceType=network-insights-path,Tags=[{Key=Name,Value=$PREFIX-Public-to-Private-SSH},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query NetworkInsightsPath.NetworkInsightsPathId --output text)
ANALYSIS=$(aws ec2 start-network-insights-analysis --region "$REGION" --network-insights-path-id "$PATHID" --query NetworkInsightsAnalysis.NetworkInsightsAnalysisId --output text)
save PATHID "$PATHID"; save ANALYSIS "$ANALYSIS"

# EC2 Instance Connect Endpoint, optional module.
set +e
EIC=$(aws ec2 create-instance-connect-endpoint --region "$REGION" --subnet-id "$PRI1" --security-group-ids "$EPSG" --no-preserve-client-ip --tag-specifications "ResourceType=instance-connect-endpoint,Tags=[{Key=Name,Value=$PREFIX-EIC-Endpoint},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query Ec2InstanceConnectEndpoint.Ec2InstanceConnectEndpointId --output text 2>/tmp/eic.err)
if [ $? -eq 0 ]; then save EIC "$EIC"; else echo "EIC endpoint skipped: $(cat /tmp/eic.err)"; save EIC "SKIPPED"; fi
set -e

aws cloudwatch put-metric-alarm --region "$REGION" --alarm-name "$PREFIX-EC2-Public-CPUHigh" --alarm-description "Workshop public EC2 CPU alarm" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value="$PUBINST" --evaluation-periods 1 --treat-missing-data notBreaching
aws cloudwatch put-metric-alarm --region "$REGION" --alarm-name "$PREFIX-EC2-Private-CPUHigh" --alarm-description "Workshop private EC2 CPU alarm" --metric-name CPUUtilization --namespace AWS/EC2 --statistic Average --period 300 --threshold 70 --comparison-operator GreaterThanThreshold --dimensions Name=InstanceId,Value="$PRIINST" --evaluation-periods 1 --treat-missing-data notBreaching
save ALARM1 "$PREFIX-EC2-Public-CPUHigh"; save ALARM2 "$PREFIX-EC2-Private-CPUHigh"

# VPN environment VPC and Site-to-Site VPN resources.
VPNVPC=$(aws ec2 create-vpc --region "$REGION" --cidr-block 10.20.0.0/16 --query Vpc.VpcId --output text); name "$VPNVPC" "$PREFIX-VPN-VPC"
aws ec2 modify-vpc-attribute --region "$REGION" --vpc-id "$VPNVPC" --enable-dns-hostnames
VPNSUB=$(aws ec2 create-subnet --region "$REGION" --vpc-id "$VPNVPC" --cidr-block 10.20.1.0/24 --availability-zone "$AZ1" --query Subnet.SubnetId --output text); name "$VPNSUB" "$PREFIX-VPN-Public-Subnet"
aws ec2 modify-subnet-attribute --region "$REGION" --subnet-id "$VPNSUB" --map-public-ip-on-launch
VPNIGW=$(aws ec2 create-internet-gateway --region "$REGION" --query InternetGateway.InternetGatewayId --output text); name "$VPNIGW" "$PREFIX-VPN-IGW"
aws ec2 attach-internet-gateway --region "$REGION" --vpc-id "$VPNVPC" --internet-gateway-id "$VPNIGW"
VPNRT=$(aws ec2 create-route-table --region "$REGION" --vpc-id "$VPNVPC" --query RouteTable.RouteTableId --output text); name "$VPNRT" "$PREFIX-VPN-Public-RT"
aws ec2 create-route --region "$REGION" --route-table-id "$VPNRT" --destination-cidr-block 0.0.0.0/0 --gateway-id "$VPNIGW" >/dev/null
aws ec2 associate-route-table --region "$REGION" --route-table-id "$VPNRT" --subnet-id "$VPNSUB" >/dev/null
VPNSG=$(aws ec2 create-security-group --region "$REGION" --vpc-id "$VPNVPC" --group-name "$PREFIX-CustomerGateway-SG" --description "Customer gateway SG" --query GroupId --output text); name "$VPNSG" "$PREFIX-CustomerGateway-SG"
aws ec2 authorize-security-group-ingress --region "$REGION" --group-id "$VPNSG" --ip-permissions IpProtocol=tcp,FromPort=22,ToPort=22,IpRanges='[{CidrIp=0.0.0.0/0,Description="SSH lab access"}]' IpProtocol=udp,FromPort=500,ToPort=500,IpRanges='[{CidrIp=0.0.0.0/0,Description="IKE"}]' IpProtocol=udp,FromPort=4500,ToPort=4500,IpRanges='[{CidrIp=0.0.0.0/0,Description="NAT-T"}]' IpProtocol=50,IpRanges='[{CidrIp=0.0.0.0/0,Description="ESP"}]' IpProtocol=icmp,FromPort=-1,ToPort=-1,IpRanges='[{CidrIp=10.10.0.0/16,Description="ICMP from main VPC"},{CidrIp=10.20.0.0/16,Description="ICMP local"}]' >/dev/null || true
CGWINST=$(aws ec2 run-instances --region "$REGION" --image-id "$AMI" --instance-type t3.micro --key-name "$KEY" --iam-instance-profile Name="$PROFILE" --subnet-id "$VPNSUB" --security-group-ids "$VPNSG" --associate-public-ip-address --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$PREFIX-EC2-Customer-Gateway},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query Instances[0].InstanceId --output text)
aws ec2 wait instance-running --region "$REGION" --instance-ids "$CGWINST"
aws ec2 modify-instance-attribute --region "$REGION" --instance-id "$CGWINST" --no-source-dest-check
CGWIP=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$CGWINST" --query 'Reservations[0].Instances[0].PublicIpAddress' --output text)
CGWENI=$(aws ec2 describe-instances --region "$REGION" --instance-ids "$CGWINST" --query 'Reservations[0].Instances[0].NetworkInterfaces[0].NetworkInterfaceId' --output text)
VGW=$(aws ec2 create-vpn-gateway --region "$REGION" --type ipsec.1 --amazon-side-asn 64512 --query VpnGateway.VpnGatewayId --output text); name "$VGW" "$PREFIX-Virtual-Private-Gateway"
aws ec2 attach-vpn-gateway --region "$REGION" --vpc-id "$VPC" --vpn-gateway-id "$VGW" >/dev/null
echo "Waiting for VGW attach..."
sleep 45
CGW=$(aws ec2 create-customer-gateway --region "$REGION" --type ipsec.1 --public-ip "$CGWIP" --bgp-asn 65000 --query CustomerGateway.CustomerGatewayId --output text); name "$CGW" "$PREFIX-Customer-Gateway"
VPNCONN=$(aws ec2 create-vpn-connection --region "$REGION" --type ipsec.1 --customer-gateway-id "$CGW" --vpn-gateway-id "$VGW" --options StaticRoutesOnly=true --tag-specifications "ResourceType=vpn-connection,Tags=[{Key=Name,Value=$PREFIX-Site-to-Site-VPN},{Key=Project,Value=$PROJECT},{Key=Workshop,Value=$PREFIX}]" --query VpnConnection.VpnConnectionId --output text)
aws ec2 create-vpn-connection-route --region "$REGION" --vpn-connection-id "$VPNCONN" --destination-cidr-block 10.20.0.0/16 >/dev/null || true
aws ec2 create-route --region "$REGION" --route-table-id "$PUBRT" --destination-cidr-block 10.20.0.0/16 --gateway-id "$VGW" >/dev/null || true
aws ec2 create-route --region "$REGION" --route-table-id "$PRIRT1" --destination-cidr-block 10.20.0.0/16 --gateway-id "$VGW" >/dev/null || true
aws ec2 create-route --region "$REGION" --route-table-id "$PRIRT2" --destination-cidr-block 10.20.0.0/16 --gateway-id "$VGW" >/dev/null || true
aws ec2 create-route --region "$REGION" --route-table-id "$VPNRT" --destination-cidr-block 10.10.0.0/16 --network-interface-id "$CGWENI" >/dev/null || true
save VPNVPC "$VPNVPC"; save VPNSUB "$VPNSUB"; save VPNRT "$VPNRT"; save VPNSG "$VPNSG"; save CGWINST "$CGWINST"; save CGWIP "$CGWIP"; save VGW "$VGW"; save CGW "$CGW"; save VPNCONN "$VPNCONN"

aws ec2 describe-vpn-connections --region "$REGION" --vpn-connection-ids "$VPNCONN" --query 'VpnConnections[0].CustomerGatewayConfiguration' --output text > "${PREFIX}-vpn-config.xml"

cat "$STATE"
echo "=== DEPLOYMENT_COMPLETE $PREFIX ==="
