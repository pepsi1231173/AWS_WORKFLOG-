---
title: 'Worklog Tuần 4'
date: 2026-05-14
weight: 4
chapter: false
pre: ' <b> 1.4. </b> '
---

### Mục tiêu tuần 4:

- Hoàn thành Lab 4: thực hành EC2 storage, EBS snapshot, custom AMI và kiểm tra IAM policy.
- Hoàn thành Lab 5: triển khai Amazon RDS với subnet group, security group, EC2 access, snapshot và restore.
- Ghi lại minh chứng hạ tầng cho EC2, EBS, AMI, IAM, VPC và RDS resources.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | --------- | ------------ | --------------- | ---------- |
| 2 | - Lab 4: kiểm tra CloudShell, VPC, subnets, security groups và EC2 instances. | 11/05/2026 | 11/05/2026 | Hoàn thành |
| 3 | - Lab 4: kiểm tra EBS volumes, tạo snapshots, tạo custom AMI và xem lại IAM group/user/policy. | 12/05/2026 | 12/05/2026 | Hoàn thành |
| 4 | - Lab 5: chuẩn bị VPC, public subnet, DB subnets, EC2 security group và RDS security group. | 13/05/2026 | 13/05/2026 | Hoàn thành |
| 5 | - Lab 5: tạo DB subnet group, khởi tạo EC2 instance và triển khai Amazon RDS database. | 14/05/2026 | 14/05/2026 | Hoàn thành |
| 6 | - Lab 5: kiểm tra database snapshot, restore workflow và kết quả connection test. | 15/05/2026 | 15/05/2026 | Hoàn thành |

### Kết quả đạt được tuần 4:

### Lab 4:

- Kiểm tra VPC, subnet, security group và danh sách EC2 từ AWS Console/CloudShell.
- Kiểm tra EBS volumes và EBS snapshots cho quản lý storage của EC2.
- Tạo hoặc xác nhận custom AMI từ EC2 instance.
- Kiểm tra minh chứng IAM group, user và policy cho phần access control.

### Lab 5:

- Chuẩn bị networking resources cho triển khai Amazon RDS.
- Tạo DB subnet group và security group rules cho database access.
- Khởi tạo EC2 và Amazon RDS để kiểm tra kết nối database.
- Xác nhận snapshot/restore workflow của RDS và kết quả test cuối cùng.

### Hình ảnh minh chứng lab:

#### aws-lab-000004 - EC2 storage, custom AMI và kiểm tra IAM policy (12 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/00-cloudshell-current.png" alt="aws-lab-000004 - 00-cloudshell-current" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/02-vpc-list.png" alt="aws-lab-000004 - 02-vpc-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/03-subnets.png" alt="aws-lab-000004 - 03-subnets" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/04-security-groups.png" alt="aws-lab-000004 - 04-security-groups" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/05-ec2-instances.png" alt="aws-lab-000004 - 05-ec2-instances" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/06-ebs-volumes.png" alt="aws-lab-000004 - 06-ebs-volumes" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/07-ebs-snapshots.png" alt="aws-lab-000004 - 07-ebs-snapshots" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/08-custom-ami.png" alt="aws-lab-000004 - 08-custom-ami" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/09-iam-policies.png" alt="aws-lab-000004 - 09-iam-policies" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/15-cleanup-ec2-empty.png" alt="aws-lab-000004 - 15-cleanup-ec2-empty" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/16-cleanup-vpc-empty.png" alt="aws-lab-000004 - 16-cleanup-vpc-empty" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000004/screenshots-ui/17-cleanup-ami-snapshot-empty.png" alt="aws-lab-000004 - 17-cleanup-ami-snapshot-empty" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

#### aws-lab-000005 - Triển khai Amazon RDS, snapshot và restore (13 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/00-cdp-test.png" alt="aws-lab-000005 - 00-cdp-test" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/01-vpc-details.png" alt="aws-lab-000005 - 01-vpc-details" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/02-public-subnet.png" alt="aws-lab-000005 - 02-public-subnet" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/03-db-subnet-az1.png" alt="aws-lab-000005 - 03-db-subnet-az1" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/04-ec2-security-group.png" alt="aws-lab-000005 - 04-ec2-security-group" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/05-rds-security-group.png" alt="aws-lab-000005 - 05-rds-security-group" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/06-db-subnet-group.png" alt="aws-lab-000005 - 06-db-subnet-group" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/07-ec2-instance.png" alt="aws-lab-000005 - 07-ec2-instance" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/08-rds-databases-list.png" alt="aws-lab-000005 - 08-rds-databases-list" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/09-rds-original-detail.png" alt="aws-lab-000005 - 09-rds-original-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/10-app-page.png" alt="aws-lab-000005 - 10-app-page" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/11-rds-snapshot.png" alt="aws-lab-000005 - 11-rds-snapshot" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000005/screenshots-ui/12-rds-restore-detail.png" alt="aws-lab-000005 - 12-rds-restore-detail" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

