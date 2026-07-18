---
title: 'Worklog Tuần 5'
date: 2026-05-24
weight: 5
chapter: false
pre: ' <b> 1.5. </b> '
---

### Mục tiêu tuần 5:

- Hoàn thành Lab 6: triển khai kiến trúc web có khả năng mở rộng với VPC, RDS, EC2, AMI, Launch Template, Auto Scaling Group, Target Group, ALB và CloudWatch.
- Hoàn thành Lab 7: tạo AWS Budgets cho cost, usage, Reserved Instances và Savings Plans.
- Kiểm tra truy cập ứng dụng qua ALB DNS và ghi lại minh chứng budgets.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | --------- | ------------ | --------------- | ---------- |
| 2 | - Lab 6: tạo VPC, subnets, security groups và RDS database cho môi trường ứng dụng mở rộng. | 18/05/2026 | 18/05/2026 | Hoàn thành |
| 3 | - Lab 6: khởi tạo EC2 instances, tạo AMI và chuẩn bị Launch Template. | 19/05/2026 | 19/05/2026 | Hoàn thành |
| 4 | - Lab 6: cấu hình Target Group, Application Load Balancer và Auto Scaling Group. | 20/05/2026 | 20/05/2026 | Hoàn thành |
| 5 | - Lab 6: kiểm tra truy cập ALB DNS, xác nhận kết quả ứng dụng và xem CloudWatch evidence. | 21/05/2026 | 21/05/2026 | Hoàn thành |
| 6 | - Lab 7: tạo budget templates, cost budget, usage budget, RI budget và Savings Plans budget. | 22/05/2026 | 22/05/2026 | Hoàn thành |
| 7 | - Lab 7: kiểm tra danh sách budgets đã tạo và ghi lại toàn bộ minh chứng. | 23/05/2026 | 23/05/2026 | Hoàn thành |

### Kết quả đạt được tuần 5:

### Lab 6:

- Xây dựng nền tảng network với VPC, subnets và security groups.
- Triển khai RDS và EC2 cho môi trường ứng dụng.
- Tạo AMI và Launch Template để triển khai EC2 lặp lại.
- Cấu hình Target Group, Application Load Balancer và Auto Scaling Group.
- Xác nhận ứng dụng truy cập được qua ALB DNS và xem minh chứng monitoring.

### Lab 7:

- Tạo AWS Budgets từ template và form cấu hình tùy chỉnh.
- Cấu hình cost budget và usage budget để theo dõi chi phí/sử dụng.
- Tạo ví dụ Reserved Instance budget và Savings Plans budget.
- Kiểm tra danh sách budgets đã tạo trong AWS Billing console.

### Hình ảnh minh chứng lab:

#### aws-lab-000006 - Kiến trúc web mở rộng với ALB, Auto Scaling, RDS và CloudWatch (14 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/01-app-alb-result.png" alt="aws-lab-000006 - 01-app-alb-result" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/02-vpc-created.png" alt="aws-lab-000006 - 02-vpc-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/03-subnets-created.png" alt="aws-lab-000006 - 03-subnets-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/04-security-groups-created.png" alt="aws-lab-000006 - 04-security-groups-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/05-rds-available.png" alt="aws-lab-000006 - 05-rds-available" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/06-ec2-instances.png" alt="aws-lab-000006 - 06-ec2-instances" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/07-ami-created.png" alt="aws-lab-000006 - 07-ami-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/08-launch-template-created.png" alt="aws-lab-000006 - 08-launch-template-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/09-target-group-healthy.png" alt="aws-lab-000006 - 09-target-group-healthy" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/10-load-balancer-active.png" alt="aws-lab-000006 - 10-load-balancer-active" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/11-auto-scaling-group.png" alt="aws-lab-000006 - 11-auto-scaling-group" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/12-cloudwatch-custom-metrics.png" alt="aws-lab-000006 - 12-cloudwatch-custom-metrics" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/13-asg-details.png" alt="aws-lab-000006 - 13-asg-details" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000006/screenshots-000006-final-1280/14-asg-automatic-scaling.png" alt="aws-lab-000006 - 14-asg-automatic-scaling" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

#### aws-lab-000007 - AWS Budgets cho cost, usage, RI và Savings Plans (7 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/01-cloudshell-created-budgets.png" alt="aws-lab-000007 - 01-cloudshell-created-budgets" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/02-budget-list-created.png" alt="aws-lab-000007 - 02-budget-list-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/03-template-cost-budget.png" alt="aws-lab-000007 - 03-template-cost-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/04-cost-budget.png" alt="aws-lab-000007 - 04-cost-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/05-usage-budget.png" alt="aws-lab-000007 - 05-usage-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/06-ri-budget.png" alt="aws-lab-000007 - 06-ri-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/07-savings-plans-budget.png" alt="aws-lab-000007 - 07-savings-plans-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

