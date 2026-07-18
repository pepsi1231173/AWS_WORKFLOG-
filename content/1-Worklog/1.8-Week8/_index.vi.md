---
title: 'Worklog Tuần 8'
date: 2026-06-14
weight: 8
chapter: false
pre: ' <b> 1.8. </b> '
---

### Mục tiêu tuần 8:

- Hoàn thành Lab 15: triển khai ứng dụng Docker với VPC, RDS, ECR và EC2.
- Hoàn thành Lab 28: thực hành quản lý IAM policy, MFA trust policy, chuyển role và kiểm tra quyền EC2.
- Ghi lại hình ảnh minh chứng triển khai và dọn dẹp tài nguyên cho cả hai lab.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | --------- | ------------ | --------------- | ---------- |
| 2 | - Lab 15: tạo VPC, subnet, security group và IAM role cho môi trường triển khai. <br> - Chuẩn bị ECR repositories cho frontend và backend container images. | 08/06/2026 | 08/06/2026 | Hoàn thành |
| 3 | - Lab 15: tạo và cấu hình Amazon RDS. <br> - Khởi tạo EC2 instance và key pair để chạy ứng dụng Docker. | 09/06/2026 | 09/06/2026 | Hoàn thành |
| 4 | - Lab 15: build và chạy Docker frontend/backend. <br> - Push frontend và backend images lên Amazon ECR. | 10/06/2026 | 10/06/2026 | Hoàn thành |
| 5 | - Lab 15: kiểm tra ứng dụng đã triển khai. <br> - Dọn dẹp EC2, RDS, ECR, security group, IAM role và VPC resources. | 11/06/2026 | 11/06/2026 | Hoàn thành |
| 6 | - Lab 28: tạo IAM admin group, IAM user, custom policies và IAM role. <br> - Cấu hình trust policy có yêu cầu MFA. | 12/06/2026 | 12/06/2026 | Hoàn thành |
| 7 | - Lab 28: kiểm tra quyền EC2, tag và luồng switch role. <br> - Dọn dẹp EC2 instance, IAM role, policies, user và group. | 13/06/2026 | 13/06/2026 | Hoàn thành |

### Kết quả đạt được tuần 8:

### Lab 15:

- Tạo VPC, subnet, security group và IAM role cho môi trường ứng dụng Docker.
- Tạo Amazon ECR repositories cho frontend và backend container images.
- Cấu hình Amazon RDS và EC2 để phục vụ triển khai ứng dụng.
- Build, chạy và kiểm tra Docker frontend/backend services.
- Push container images lên Amazon ECR.
- Dọn dẹp EC2, RDS, ECR, security group, IAM role và VPC resources sau khi hoàn tất lab.

### Lab 28:

- Tạo IAM admin group và IAM user để thực hành quản lý truy cập.
- Tạo và kiểm tra IAM policies cho quyền EC2 và kiểm soát theo tag.
- Cấu hình IAM role permissions và trust policy có điều kiện MFA.
- Kiểm tra tạo EC2 instance, instance tags và luồng switch role.
- Dọn dẹp EC2, IAM role, policies, user và group sau khi kiểm tra.

### Hình ảnh minh chứng lab:

#### aws-lab-000015 - Triển khai Docker app với VPC, RDS, ECR và EC2 (22 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000015/02-vpc-created-ui.png" alt="aws-lab-000015 - 02-vpc-created-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/03-subnets-created-ui.png" alt="aws-lab-000015 - 03-subnets-created-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/04-security-groups-created-ui.png" alt="aws-lab-000015 - 04-security-groups-created-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/05-iam-role-ecr-ui.png" alt="aws-lab-000015 - 05-iam-role-ecr-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/06b-ecr-repositories-ui.png" alt="aws-lab-000015 - 06b-ecr-repositories-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/06-ecr-repositories-ui.png" alt="aws-lab-000015 - 06-ecr-repositories-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/07b-rds-available-ui.png" alt="aws-lab-000015 - 07b-rds-available-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/07-rds-creating-ui.png" alt="aws-lab-000015 - 07-rds-creating-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/08b-ec2-instance-detail-ui.png" alt="aws-lab-000015 - 08b-ec2-instance-detail-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/08-ec2-instance-ui.png" alt="aws-lab-000015 - 08-ec2-instance-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/09-key-pair-ui.png" alt="aws-lab-000015 - 09-key-pair-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/10b-docker-frontend-app-ui.png" alt="aws-lab-000015 - 10b-docker-frontend-app-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/11b-docker-backend-api-ui.png" alt="aws-lab-000015 - 11b-docker-backend-api-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/13b-ecr-frontend-image-ui.png" alt="aws-lab-000015 - 13b-ecr-frontend-image-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/13-ecr-frontend-image-ui.png" alt="aws-lab-000015 - 13-ecr-frontend-image-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/14-ecr-backend-image-ui.png" alt="aws-lab-000015 - 14-ecr-backend-image-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/16-cleanup-vpc-no-match-ui.png" alt="aws-lab-000015 - 16-cleanup-vpc-no-match-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/17-cleanup-rds-no-db-ui.png" alt="aws-lab-000015 - 17-cleanup-rds-no-db-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/18-cleanup-ecr-no-repos-ui.png" alt="aws-lab-000015 - 18-cleanup-ecr-no-repos-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/19-cleanup-security-groups-no-match-ui.png" alt="aws-lab-000015 - 19-cleanup-security-groups-no-match-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/20-cleanup-iam-role-not-found-ui.png" alt="aws-lab-000015 - 20-cleanup-iam-role-not-found-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000015/21-cleanup-ec2-no-active-ui.png" alt="aws-lab-000015 - 21-cleanup-ec2-no-active-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

#### aws-lab-000028 - Quản lý IAM policy, MFA và role switching (21 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000028/02-iam-admin-group-ui.png" alt="aws-lab-000028 - 02-iam-admin-group-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/03-iam-admin-user-ui.png" alt="aws-lab-000028 - 03-iam-admin-user-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/04-iam-policies-list-ui.png" alt="aws-lab-000028 - 04-iam-policies-list-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/05-iam-role-permissions-ui.png" alt="aws-lab-000028 - 05-iam-role-permissions-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/06b-iam-role-trust-mfa-ui.png" alt="aws-lab-000028 - 06b-iam-role-trust-mfa-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/06c-iam-role-trust-mfa-ui.png" alt="aws-lab-000028 - 06c-iam-role-trust-mfa-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/06d-iam-role-trust-mfa-ui.png" alt="aws-lab-000028 - 06d-iam-role-trust-mfa-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/06-iam-role-trust-mfa-ui.png" alt="aws-lab-000028 - 06-iam-role-trust-mfa-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/07b-policy-run-instances-ui.png" alt="aws-lab-000028 - 07b-policy-run-instances-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/07c-policy-run-instances-json-ui.png" alt="aws-lab-000028 - 07c-policy-run-instances-json-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/07-policy-run-instances-ui.png" alt="aws-lab-000028 - 07-policy-run-instances-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/08-ec2-example-instance-ui.png" alt="aws-lab-000028 - 08-ec2-example-instance-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/09d-ec2-tags-ui.png" alt="aws-lab-000028 - 09d-ec2-tags-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/09-ec2-example-detail-ui.png" alt="aws-lab-000028 - 09-ec2-example-detail-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/10b-switch-role-result-ui.png" alt="aws-lab-000028 - 10b-switch-role-result-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/10-switch-role-page-ui.png" alt="aws-lab-000028 - 10-switch-role-page-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/12-cleanup-ec2-example-terminated-ui.png" alt="aws-lab-000028 - 12-cleanup-ec2-example-terminated-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/13-cleanup-role-not-found-ui.png" alt="aws-lab-000028 - 13-cleanup-role-not-found-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/14-cleanup-policy-not-found-ui.png" alt="aws-lab-000028 - 14-cleanup-policy-not-found-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/15-cleanup-user-not-found-ui.png" alt="aws-lab-000028 - 15-cleanup-user-not-found-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000028/16-cleanup-group-not-found-ui.png" alt="aws-lab-000028 - 16-cleanup-group-not-found-ui" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

