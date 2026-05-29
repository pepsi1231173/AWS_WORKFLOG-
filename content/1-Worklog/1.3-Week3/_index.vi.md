---
title: 'Worklog Tuần 3'
date: 2026-05-04
weight: 1
chapter: false
pre: ' <b> 1.3. </b> '
---

{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

### Mục tiêu tuần 3:

- Kết nối, làm quen với các thành viên trong First Cloud Journey.
- Hiểu dịch vụ AWS cơ bản, cách dùng console & CLI.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc                                                                                                                                                                                                                                                                                                                                                                                | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ---------- | ---------- |
| 2   | - Tìm hiểu kiến thức cơ bản về AWS Networking <br> &emsp; + VPC <br> &emsp; + Public & Private Subnet <br> &emsp; + Route Table <br> &emsp; + Internet Gateway <br> &emsp; + Security Group                                                                                                                                                                                              | 04/05/2026   | 04/05/2026      |            | Hoàn thành |
| 3   | - Tìm hiểu kiến thức cơ bản về Amazon RDS <br> &emsp; + DB Instance <br> &emsp; + MySQL Engine <br> &emsp; + DB Subnet Group <br> &emsp; + Multi-AZ <br> &emsp; + Backup & Snapshot<br>                                                                                                                                                                                                  | 05/05/2026   | 05/05/2026      | Hoàn thành |
| 4   | - **Thực hành:** <br> &emsp; + Tạo VPC và Subnets <br> &emsp; + Tạo Security Groups <br> &emsp; + Khởi tạo EC2 Instance <br> &emsp                                                                                                                                                                                                                                                       | 06/05/2026   | 06/05/2026      | Hoàn Thành |
| 5   | - Tìm hiểu kiến thức cơ bản về Amazon EC2 <br> &emsp; + Kiến trúc Amazon EC2 <br> &emsp; + Instance Types (Compute, Memory, Storage, Network Performance) <br> &emsp; + Amazon Machine Images (AMI) <br> &emsp; + Amazon EBS Volumes <br> &emsp; + Instance Store Volumes <br> &emsp; + Security Groups <br> &emsp; + Key Pairs <br> &emsp; + IAM Roles <br> &emsp; + Elastic IP Address | 07/05/2026   | 07/05/2026      | Hoàn thành |
| 6   | - **Thực hành:** <br> &emsp; + Khởi tạo Amazon EC2 Instance <br> &emsp; + Cấu hình Security Group Rules <br> &emsp; + Tạo và sử dụng Key Pair để SSH <br> &emsp; + Kết nối EC2 bằng SSH <br> &emsp; + Gắn và mount Amazon EBS Volume <br> &emsp; + Giám sát EC2 bằng Amazon CloudWatch <br> &emsp; + Tạo Tags để quản lý tài nguyên EC2                                                  | 08/05/2025   | 08/05/2025      | Hoàn thành |

### Kết quả đạt được tuần 3:

### Bước 1: Tìm hiểu AWS Networking và Amazon RDS

- Tìm hiểu về VPC, Subnets, Route Tables và Security Groups
- Tìm hiểu các khái niệm về Amazon RDS và quy trình triển khai cơ sở dữ liệu
- Hiểu về DB Instance, MySQL Engine, Backup và Multi-AZ

### Bước 2: Tạo hạ tầng AWS

- Tạo VPC và Subnets tùy chỉnh
- Cấu hình Internet Gateway và Security Groups
- Khởi tạo Amazon EC2 Instance

### Bước 3: Tạo và kết nối Amazon RDS

- Tạo cơ sở dữ liệu Amazon RDS MySQL
- Cấu hình DB Subnet Group
- Kết nối EC2 tới RDS bằng MySQL Client

```bash
sudo yum install mariadb105 -y
```

### Bước 4: Tìm hiểu và thực hành Amazon EC2

- Tìm hiểu kiến trúc EC2, AMI, EBS và Elastic IP
- Kết nối tới EC2 bằng SSH
- Gắn và mount Amazon EBS Volume
- Giám sát tài nguyên EC2 bằng Amazon CloudWatch

```bash
ssh -i key.pem ec2-user@public-ip
```

```bash
lsblk
```

```bash
df -h
```

### Thành quả tuần 3

- Hiểu các khái niệm về AWS Networking và hạ tầng Cloud
- Tạo và cấu hình thành công tài nguyên EC2 và RDS
- Kết nối thành công EC2 tới cơ sở dữ liệu RDS
- Tìm hiểu quản trị Linux Server và các thao tác MySQL
- Tìm hiểu giám sát EC2 và quản lý tài nguyên AWS
- Cải thiện kỹ năng triển khai hạ tầng Cloud thực tế
