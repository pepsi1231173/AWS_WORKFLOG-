---
title: 'Worklog Tuần 7'
date: 2026-06-07
weight: 7
chapter: false
pre: ' <b> 1.7. </b> '
---

{{% notice warning %}}
**Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn, kể cả warning này.
{{% /notice %}}

### Mục tiêu tuần 7:

- Hoàn thành Lab 11: thực hành các dịch vụ AWS cơ bản qua console gồm S3, SNS, IAM, VPC, subnets, route table, internet gateway, security group, key pair và EC2.
- Hoàn thành Lab 14: thực hành VM Import/Export, imported AMI, khởi tạo EC2 từ imported AMI, snapshot/export buckets và kiểm tra cleanup.
- Ghi lại minh chứng console cho quá trình tạo dịch vụ, import workflow và dọn dẹp tài nguyên.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | --------- | ------------ | --------------- | ---------- |
| 2 | - Lab 11: tạo/kiểm tra S3 bucket object và SNS topic. <br> - Tạo IAM user và IAM group. | 01/06/2026 | 01/06/2026 | Hoàn thành |
| 3 | - Lab 11: tạo/kiểm tra VPC, subnets, route table, internet gateway và security group. | 02/06/2026 | 02/06/2026 | Hoàn thành |
| 4 | - Lab 11: tạo key pair, khởi tạo EC2 instance và xác nhận cleanup evidence. | 03/06/2026 | 03/06/2026 | Hoàn thành |
| 5 | - Lab 14: chuẩn bị S3 buckets và IAM vmimport role. <br> - Kiểm tra imported AMI và imported snapshot. | 04/06/2026 | 04/06/2026 | Hoàn thành |
| 6 | - Lab 14: khởi tạo EC2 từ imported AMI và xem minh chứng export/import bucket. | 05/06/2026 | 05/06/2026 | Hoàn thành |
| 7 | - Lab 14: dọn dẹp EC2, S3, AMI, snapshot, security group và vmimport role resources. | 06/06/2026 | 06/06/2026 | Hoàn thành |

### Kết quả đạt được tuần 7:

### Lab 11:

- Thực hành tạo và kiểm tra S3 bucket objects và SNS topic resources.
- Tạo IAM user và IAM group để thực hành quản lý truy cập.
- Tạo các tài nguyên VPC networking: subnets, route table, internet gateway và security group.
- Tạo key pair và khởi tạo EC2 instance từ AWS Console.
- Xác nhận minh chứng cleanup cho các tài nguyên liên quan đến VPC.

### Lab 14:

- Chuẩn bị S3 buckets và IAM vmimport role cho VM Import/Export workflow.
- Kiểm tra imported AMI và imported snapshot evidence.
- Khởi tạo EC2 instance từ imported AMI.
- Xem minh chứng export/import bucket.
- Xác nhận cleanup cho EC2, S3, AMI, snapshot, security group và vmimport role resources.

### Hình ảnh minh chứng lab:

#### aws-lab-000011 - Thực hành dịch vụ AWS cơ bản với S3, SNS, IAM, VPC và EC2 (12 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000011/01-s3-bucket-object-console.png" alt="aws-lab-000011 - 01-s3-bucket-object-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/02-sns-topic-console.png" alt="aws-lab-000011 - 02-sns-topic-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/03-iam-user-console.png" alt="aws-lab-000011 - 03-iam-user-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/04-iam-group-console.png" alt="aws-lab-000011 - 04-iam-group-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/05-vpc-console.png" alt="aws-lab-000011 - 05-vpc-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/06-subnets-console.png" alt="aws-lab-000011 - 06-subnets-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/07-route-table-console.png" alt="aws-lab-000011 - 07-route-table-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/08-internet-gateway-console.png" alt="aws-lab-000011 - 08-internet-gateway-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/09-security-group-console.png" alt="aws-lab-000011 - 09-security-group-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/10-key-pair-console.png" alt="aws-lab-000011 - 10-key-pair-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/11-ec2-instance-console.png" alt="aws-lab-000011 - 11-ec2-instance-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000011/14-cleanup-vpc-no-match-console.png" alt="aws-lab-000011 - 14-cleanup-vpc-no-match-console" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

#### aws-lab-000014 - VM Import/Export, imported AMI, khởi tạo EC2 và kiểm tra cleanup (14 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000014/20-s3-buckets-ui.png" alt="aws-lab-000014 - 20-s3-buckets-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/21-iam-vmimport-role-ui.png" alt="aws-lab-000014 - 21-iam-vmimport-role-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/22-imported-ami-ui.png" alt="aws-lab-000014 - 22-imported-ami-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/23-ec2-from-imported-ami-ui.png" alt="aws-lab-000014 - 23-ec2-from-imported-ami-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/24-imported-snapshot-ui.png" alt="aws-lab-000014 - 24-imported-snapshot-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/25-export-bucket-ui.png" alt="aws-lab-000014 - 25-export-bucket-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/26-import-bucket-vmdk-ui.png" alt="aws-lab-000014 - 26-import-bucket-vmdk-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/35-cleanup-instance-status-ui.png" alt="aws-lab-000014 - 35-cleanup-instance-status-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/40-verify-s3-after-cleanup-ui.png" alt="aws-lab-000014 - 40-verify-s3-after-cleanup-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/41-verify-ami-after-cleanup-ui.png" alt="aws-lab-000014 - 41-verify-ami-after-cleanup-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/46-verify-s3-no-lab14-ui.png" alt="aws-lab-000014 - 46-verify-s3-no-lab14-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/47-verify-snapshot-no-match-ui.png" alt="aws-lab-000014 - 47-verify-snapshot-no-match-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/48-verify-sg-no-match-ui.png" alt="aws-lab-000014 - 48-verify-sg-no-match-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000014/49-verify-vmimport-role-cleanup-ui.png" alt="aws-lab-000014 - 49-verify-vmimport-role-cleanup-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

