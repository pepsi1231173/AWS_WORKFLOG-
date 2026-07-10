---
title: 'Week 4 Worklog'
date: 2026-05-14
weight: 4
chapter: false
pre: ' <b> 1.4. </b> '
---

{{% notice warning %}}
**Note:** The following information is for reference purposes only. Please **do not copy verbatim** for your own report, including this warning.
{{% /notice %}}

### Week 4 Objectives:

- Complete Lab 4: practice EC2 storage, EBS snapshot, custom AMI, and IAM policy verification.
- Complete Lab 5: deploy Amazon RDS with subnet groups, security groups, EC2 access, snapshot, and restore workflow.
- Document infrastructure screenshots for EC2, EBS, AMI, IAM, VPC, and RDS resources.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Status |
| --- | ---- | ---------- | --------------- | ------ |
| 2 | - Lab 4: inspect CloudShell, VPC, subnets, security groups, and EC2 instances. | 11/05/2026 | 11/05/2026 | Done |
| 3 | - Lab 4: verify EBS volumes, create snapshots, create custom AMI, and review IAM group/user/policy checks. | 12/05/2026 | 12/05/2026 | Done |
| 4 | - Lab 5: prepare VPC, public subnet, DB subnets, EC2 security group, and RDS security group. | 13/05/2026 | 13/05/2026 | Done |
| 5 | - Lab 5: create DB subnet group, launch EC2 instance, and deploy Amazon RDS database. | 14/05/2026 | 14/05/2026 | Done |
| 6 | - Lab 5: verify database snapshot, restore workflow, and connection test result. | 15/05/2026 | 15/05/2026 | Done |

### Week 4 Achievements:

### Lab 4:

- Reviewed VPC, subnet, security group, and EC2 inventory from the AWS Console/CloudShell.
- Checked EBS volumes and EBS snapshots for EC2 storage management.
- Created or verified a custom AMI from an EC2 instance.
- Reviewed IAM group, user, and policy evidence for access control checks.

### Lab 5:

- Prepared networking resources for Amazon RDS deployment.
- Created DB subnet group and security group rules for database access.
- Launched EC2 and Amazon RDS resources for database connectivity testing.
- Verified RDS snapshot/restore workflow and final test evidence.

### Lab Evidence:

#### aws-lab-000004 - EC2 storage, custom AMI, and IAM policy checks (12 images)

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

#### aws-lab-000005 - Amazon RDS deployment, snapshot, and restore (13 images)

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

