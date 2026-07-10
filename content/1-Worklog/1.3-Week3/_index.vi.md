---
title: 'Worklog Tuần 3'
date: 2026-05-04
weight: 3
chapter: false
pre: ' <b> 1.3. </b> '
---

{{% notice warning %}}
**Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn, kể cả warning này.
{{% /notice %}}

### Mục tiêu tuần 3:

- Hoàn thành Lab 2: làm quen tài khoản AWS, AWS Console, CloudShell/CLI và tài nguyên EC2 cơ bản.
- Hoàn thành Lab 3: thực hành các thành phần VPC networking, kiểm tra endpoint, NAT Gateway và các bước kiểm tra VPN.
- Ghi lại minh chứng cho account, EC2, VPC, subnet, route table, security group, endpoint và VPN.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | --------- | ------------ | --------------- | ---------- |
| 2 | - Lab 2: đăng nhập AWS Console và kiểm tra quyền truy cập tài khoản. <br> - Mở CloudShell/CLI và xác nhận môi trường làm việc. | 04/05/2026 | 04/05/2026 | Hoàn thành |
| 3 | - Lab 2: xem lại EC2 fundamentals, key pairs, security groups và thông tin instance. <br> - Ghi lại minh chứng quản lý EC2 cơ bản. | 05/05/2026 | 05/05/2026 | Hoàn thành |
| 4 | - Lab 3: kiểm tra VPC, subnets, route tables và security groups. <br> - Xác nhận EC2 instances trong network đã cấu hình. | 06/05/2026 | 06/05/2026 | Hoàn thành |
| 5 | - Lab 3: kiểm tra NAT Gateway, VPC endpoint và kết quả reachability analyzer. | 07/05/2026 | 07/05/2026 | Hoàn thành |
| 6 | - Lab 3: kiểm tra VPN connection, customer gateway và route propagation. <br> - Tổng hợp hình ảnh minh chứng lab. | 08/05/2026 | 08/05/2026 | Hoàn thành |

### Kết quả đạt được tuần 3:

### Lab 2:

- Thực hành truy cập AWS Console và sử dụng CloudShell/CLI cơ bản.
- Kiểm tra thông tin EC2 instance, key pairs và security groups.
- Hiểu quy trình kiểm tra tài khoản AWS và tài nguyên compute cơ bản.

### Lab 3:

- Kiểm tra cấu hình VPC, subnet, route table và security group.
- Xác nhận cấu hình NAT Gateway và VPC endpoint.
- Dùng minh chứng reachability để hiểu cách kiểm tra đường đi mạng.
- Kiểm tra VPN connection và customer gateway details.

### Hình ảnh minh chứng lab:

#### aws-lab-000002 - Tài khoản AWS, Console, CLI và nền tảng EC2 (18 ảnh)

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

#### aws-lab-000003 - VPC, networking, VPN và kiểm tra endpoint (20 ảnh)

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

