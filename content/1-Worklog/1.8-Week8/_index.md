---
title: 'Week 8 Worklog'
date: 2026-06-14
weight: 8
chapter: false
pre: ' <b> 1.8. </b> '
---

{{% notice warning %}}
**Note:** The following information is for reference purposes only. Please **do not copy verbatim** for your own report, including this warning.
{{% /notice %}}

### Week 8 Objectives:

- Complete Lab 15: deploy a Docker-based application using VPC, RDS, ECR, and EC2.
- Complete Lab 28: practice IAM policy management, MFA trust policy, role switching, and EC2 permission validation.
- Document deployment evidence and cleanup results for both labs.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Status |
| --- | ---- | ---------- | --------------- | ------ |
| 2 | - Lab 15: create VPC, subnets, security groups, and IAM role for the deployment environment. <br> - Prepare ECR repositories for frontend and backend container images. | 08/06/2026 | 08/06/2026 | Done |
| 3 | - Lab 15: create and configure Amazon RDS. <br> - Launch EC2 instance and key pair for running the Docker application. | 09/06/2026 | 09/06/2026 | Done |
| 4 | - Lab 15: build and run Docker frontend and backend services. <br> - Push frontend and backend images to Amazon ECR. | 10/06/2026 | 10/06/2026 | Done |
| 5 | - Lab 15: verify the deployed application and clean up EC2, RDS, ECR, security group, IAM role, and VPC resources. | 11/06/2026 | 11/06/2026 | Done |
| 6 | - Lab 28: create IAM admin group, IAM user, custom policies, and IAM role. <br> - Configure trust policy with MFA requirements. | 12/06/2026 | 12/06/2026 | Done |
| 7 | - Lab 28: test EC2 permissions, tags, and role switching. <br> - Clean up EC2 instance, IAM role, policies, user, and group. | 13/06/2026 | 13/06/2026 | Done |

### Week 8 Achievements:

### Lab 15:

- Created VPC, subnets, security groups, and IAM role for the Docker application environment.
- Created Amazon ECR repositories for frontend and backend container images.
- Configured Amazon RDS and EC2 resources for application deployment.
- Built, ran, and verified Docker frontend and backend services.
- Pushed container images to Amazon ECR.
- Cleaned up EC2, RDS, ECR, security group, IAM role, and VPC resources after the lab.

### Lab 28:

- Created IAM admin group and IAM user for access management practice.
- Created and reviewed IAM policies for EC2 permissions and tag-based controls.
- Configured IAM role permissions and trust policy with MFA conditions.
- Tested EC2 instance creation, instance tags, and role switching flow.
- Cleaned up EC2, IAM role, policies, user, and group after validation.

### Lab Evidence:

#### aws-lab-000015 - Docker app deployment with VPC, RDS, ECR, and EC2 (22 images)

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

#### aws-lab-000028 - IAM policy management, MFA, and role switching (21 images)

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

