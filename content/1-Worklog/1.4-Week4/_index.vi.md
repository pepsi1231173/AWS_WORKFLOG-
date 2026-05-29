---
title: 'Worklog Tuần 4'
date: 2024-05-11
weight: 1
chapter: false
pre: ' <b> 1.4. </b> '
---

{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

### Mục tiêu tuần 4:

- Kết nối, làm quen với các thành viên trong First Cloud Journey.
- Hiểu dịch vụ AWS cơ bản, cách dùng console & CLI.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc                                                                                                                                                                                   | Ngày bắt đầu | Ngày hoàn thành | Nguồn tài liệu                            |
| --- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | ----------------------------------------- |
| 2   | - Làm quen với các thành viên FCJ <br> - Đọc và lưu ý các nội quy, quy định tại đơn vị thực tập                                                                                             | 11/05/2026   | 11/05/2026      |
| 3   | - Tìm hiểu AWS và các loại dịch vụ <br>&emsp; + Compute <br>&emsp; + Storage <br>&emsp; + Networking <br>&emsp; + Database <br>&emsp; + ... <br>                                            | 12/05/2026   | 12/05/2026      | <https://cloudjourney.awsstudygroup.com/> |
| 4   | - Tạo AWS Free Tier account <br> - Tìm hiểu AWS Console & AWS CLI <br> - **Thực hành:** <br>&emsp; + Tạo AWS account <br>&emsp; + Cài AWS CLI & cấu hình <br> &emsp; + Cách sử dụng AWS CLI | 13/05/2026   | 13/05/2026      | <https://cloudjourney.awsstudygroup.com/> |
| 5   | - Tìm hiểu EC2 cơ bản: <br>&emsp; + Instance types <br>&emsp; + AMI <br>&emsp; + EBS <br>&emsp; + ... <br> - Các cách remote SSH vào EC2 <br> - Tìm hiểu Elastic IP <br>                    | 14/05/2026   | 14/05/2026      | <https://cloudjourney.awsstudygroup.com/> |
| 6   | - **Thực hành:** <br>&emsp; + Tạo EC2 instance <br>&emsp; + Kết nối SSH <br>&emsp; + Gắn EBS volume                                                                                         | 15/05/2026   | 15/05/2026      | <https://cloudjourney.awsstudygroup.com/> |

### Kết quả đạt được tuần 4:

Bước 1: Tạo AWS Free Tier Account

- Truy cập AWS Console
- Đăng ký tài khoản Free Tier
- Xác minh email và thanh toán
- Thiết lập MFA

Bước 2: Làm quen AWS Console

- Tìm hiểu Dashboard
- Tìm kiếm dịch vụ
- Chuyển đổi Region
- Kiểm tra Billing Dashboard

Các dịch vụ đã tìm hiểu:

- EC2
- S3
- IAM
- VPC
- RDS
- Lambda
- CloudWatch

Bước 3: Cài đặt AWS CLI

```bash
aws --version
```

```bash
aws configure
```

Nhập:

- Access Key ID
- Secret Access Key
- Default Region
- Output Format

Kiểm tra cấu hình:

```bash
aws sts get-caller-identity
```

Bước 4: Tìm hiểu Amazon EC2

- EC2 Instance
- AMI
- Security Group
- Key Pair
- Elastic IP
- EBS Volume

Bước 5: Tạo EC2 Instance

- Launch EC2 Instance
- Chọn Ubuntu AMI
- Chọn t2.micro
- Tạo Key Pair
- Mở SSH Port 22 và HTTP Port 80

Bước 6: SSH vào EC2

```bash
ssh -i key.pem ubuntu@public-ip
```

Các lệnh cơ bản:

sudo apt update

```bash
ls
```

```bash
pwd
```

Bước 7: Gắn EBS Volume

```bash
lsblk
```

sudo mount /dev/xvdf /mnt

```bash
df -h
```

Kết quả đạt được tuần 4

- Hiểu AWS Cloud và các dịch vụ cơ bản
- Tạo thành công AWS Free Tier Account
- Sử dụng AWS Management Console thành thạo hơn
- Cài đặt và sử dụng AWS CLI
- Tạo và quản lý EC2 Instance
- SSH vào EC2 thành công
- Gắn và quản lý EBS Volume
- Hiểu cơ bản về Security Group
- Làm quen với quản trị Linux Server trên AWS
