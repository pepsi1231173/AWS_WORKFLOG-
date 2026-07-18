---
title: 'Week 5 - Auto Scaling Web Architecture and AWS Budgets'
date: 2026-05-24
weight: 5
chapter: false
pre: ' <b> 1.5. </b> '
---

### Week 5 Objectives:

- Complete Lab 6: deploy a scalable web architecture using VPC, RDS, EC2, AMI, Launch Template, Auto Scaling Group, Target Group, ALB, and CloudWatch.
- Complete Lab 7: create AWS Budgets for cost, usage, Reserved Instances, and Savings Plans tracking.
- Verify application access through the ALB DNS name and record budget evidence.

### Tasks to be carried out this week:

| Day | Task | Start Date | Completion Date | Status |
| --- | ---- | ---------- | --------------- | ------ |
| 2 | - Lab 6: create VPC, subnets, security groups, and RDS database for the scalable app environment. | 18/05/2026 | 18/05/2026 | Done |
| 3 | - Lab 6: launch EC2 instances, create AMI, and prepare Launch Template. | 19/05/2026 | 19/05/2026 | Done |
| 4 | - Lab 6: configure Target Group, Application Load Balancer, and Auto Scaling Group. | 20/05/2026 | 20/05/2026 | Done |
| 5 | - Lab 6: test ALB DNS access, verify application result, and review CloudWatch evidence. | 21/05/2026 | 21/05/2026 | Done |
| 6 | - Lab 7: create budget templates, cost budget, usage budget, RI budget, and Savings Plans budget. | 22/05/2026 | 22/05/2026 | Done |
| 7 | - Lab 7: verify the budget list and document all budget screenshots. | 23/05/2026 | 23/05/2026 | Done |

### Week 5 Achievements:

### Lab 6:

- Built the network foundation with VPC, subnets, and security groups.
- Deployed RDS and EC2 resources for the application environment.
- Created AMI and Launch Template for repeatable EC2 provisioning.
- Configured Target Group, Application Load Balancer, and Auto Scaling Group.
- Verified application access through ALB DNS and reviewed monitoring evidence.

### Lab 7:

- Created AWS Budgets from templates and custom budget forms.
- Configured cost and usage budgets for spending visibility.
- Created Reserved Instance and Savings Plans budget examples.
- Verified the created budget list from the AWS Billing console.

### Lab Evidence:

#### aws-lab-000006 - Scalable web architecture with ALB, Auto Scaling, RDS, and CloudWatch (14 images)

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

#### aws-lab-000007 - AWS Budgets for cost, usage, RI, and Savings Plans tracking (7 images)

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/01-cloudshell-created-budgets.png" alt="aws-lab-000007 - 01-cloudshell-created-budgets" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/02-budget-list-created.png" alt="aws-lab-000007 - 02-budget-list-created" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/03-template-cost-budget.png" alt="aws-lab-000007 - 03-template-cost-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/04-cost-budget.png" alt="aws-lab-000007 - 04-cost-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/05-usage-budget.png" alt="aws-lab-000007 - 05-usage-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/06-ri-budget.png" alt="aws-lab-000007 - 06-ri-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000007/screenshots-ui/07-savings-plans-budget.png" alt="aws-lab-000007 - 07-savings-plans-budget" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

