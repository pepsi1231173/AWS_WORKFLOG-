---
title: 'Week 3 Worklog'
date: 2026-05-04
weight: 3
chapter: false
pre: ' <b> 1.3. </b> '
---

{{% notice warning %}}
**Note:** The following information is for reference purposes only. Please **do not copy verbatim** for your own report, including this warning.
{{% /notice %}}

### Week 3 Objectives:

- Complete Lab 2: get familiar with AWS account access, AWS Console, CloudShell/CLI, and basic EC2 resources.
- Complete Lab 3: practice VPC networking components, endpoint verification, NAT Gateway, and VPN-related checks.
- Record evidence for account, EC2, VPC, subnet, route table, security group, endpoint, and VPN verification steps.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Status |
| --- | ---- | ---------- | --------------- | ------ |
| 2 | - Lab 2: sign in to AWS Console and review account access. <br> - Open CloudShell/CLI and verify the working environment. | 04/05/2026 | 04/05/2026 | Done |
| 3 | - Lab 2: review EC2 fundamentals, key pairs, security groups, and instance details. <br> - Capture evidence for basic EC2 management. | 05/05/2026 | 05/05/2026 | Done |
| 4 | - Lab 3: inspect VPC, subnets, route tables, and security groups. <br> - Verify EC2 instances inside the configured network. | 06/05/2026 | 06/05/2026 | Done |
| 5 | - Lab 3: review NAT Gateway, VPC endpoint, and reachability analyzer results. | 07/05/2026 | 07/05/2026 | Done |
| 6 | - Lab 3: verify VPN connection, customer gateway, and route propagation details. <br> - Summarize the lab evidence. | 08/05/2026 | 08/05/2026 | Done |

### Week 3 Achievements:

### Lab 2:

- Practiced AWS Console access and basic CloudShell/CLI usage.
- Reviewed EC2 instance information, key pairs, and security groups.
- Understood the basic workflow for checking AWS account and compute resources.

### Lab 3:

- Reviewed VPC, subnet, route table, and security group configuration.
- Verified NAT Gateway and VPC endpoint configuration.
- Used reachability evidence to understand network path validation.
- Reviewed VPN connection and customer gateway details.

### Lab Evidence:

#### aws-lab-000002 - AWS account, Console, CLI, and EC2 fundamentals (18 images)

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-07%20234758.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-07 234758" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20000720.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 000720" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20000834.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 000834" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20001507.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 001507" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20003021.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 003021" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20003854.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 003854" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20004233.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 004233" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20005605.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 005605" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20005621.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 005621" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20010339.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 010339" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20010348.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 010348" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20011306.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 011306" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20014336.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 014336" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20014350.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 014350" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20014611.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 014611" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20015038.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 015038" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20015202.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 015202" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000002/%E1%BA%A2nh%20ch%E1%BB%A5p%20m%C3%A0n%20h%C3%ACnh%202026-05-08%20015246.png" alt="aws-lab-000002 - Ảnh chụp màn hình 2026-05-08 015246" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

#### aws-lab-000003 - VPC, networking, VPN, and endpoint verification (20 images)

<img src="/images/1-Worklog/labs/aws-lab-000003/01-vpc-list.png" alt="aws-lab-000003 - 01-vpc-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/02-subnets-list.png" alt="aws-lab-000003 - 02-subnets-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/03-route-tables-list.png" alt="aws-lab-000003 - 03-route-tables-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/04-security-groups-list.png" alt="aws-lab-000003 - 04-security-groups-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/05-ec2-instances-list.png" alt="aws-lab-000003 - 05-ec2-instances-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/06-nat-gateways-list.png" alt="aws-lab-000003 - 06-nat-gateways-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/07-vpc-endpoints-list.png" alt="aws-lab-000003 - 07-vpc-endpoints-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/08-reachability-analyzer.png" alt="aws-lab-000003 - 08-reachability-analyzer" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/09-cloudwatch-alarms.png" alt="aws-lab-000003 - 09-cloudwatch-alarms" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/10-vpn-connections-list.png" alt="aws-lab-000003 - 10-vpn-connections-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/11-customer-gateways-list.png" alt="aws-lab-000003 - 11-customer-gateways-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/12-main-vpc-detail.png" alt="aws-lab-000003 - 12-main-vpc-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/13-public-subnet-detail.png" alt="aws-lab-000003 - 13-public-subnet-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/14-private-subnet-detail.png" alt="aws-lab-000003 - 14-private-subnet-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/15-public-ec2-detail.png" alt="aws-lab-000003 - 15-public-ec2-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/16-private-ec2-detail.png" alt="aws-lab-000003 - 16-private-ec2-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/17-nat-gateway-detail.png" alt="aws-lab-000003 - 17-nat-gateway-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/18-vpc-endpoint-detail.png" alt="aws-lab-000003 - 18-vpc-endpoint-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/19-vpn-connection-detail.png" alt="aws-lab-000003 - 19-vpn-connection-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000003/20-customer-gateway-detail.png" alt="aws-lab-000003 - 20-customer-gateway-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

