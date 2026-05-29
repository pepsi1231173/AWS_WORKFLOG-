---
title: 'Week 3 Worklog'
date: 2026-05-04
weight: 1
chapter: false
pre: ' <b> 1.3. </b> '
---

{{% notice warning %}}
⚠️ **Note:** The following information is for reference purposes only. Please **do not copy verbatim** for your own report, including this warning.
{{% /notice %}}

### Week 3 Objectives:

- Connect and get acquainted with members of First Cloud Journey.
- Understand basic AWS services, how to use the console & CLI.

### Tasks to be carried out this week:

| Day | Task                                                                                                                                                                                                                                                                                                                                                                              | Start Date | Completion Date | Status |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | --------------- | ------ |
| 2   | - Learn AWS networking fundamentals <br> &emsp; + VPC <br> &emsp; + Public & Private Subnet <br> &emsp; + Route Table <br> &emsp; + Internet Gateway <br> &emsp; + Security Group                                                                                                                                                                                                 | 04/05/2026 | 04/05/2026      | Done   |
| 3   | - Learn Amazon RDS fundamentals <br> &emsp; + DB Instance <br> &emsp; + MySQL Engine <br> &emsp; + DB Subnet Group <br> &emsp; + Multi-AZ <br> &emsp; + Backup & Snapshot<br>                                                                                                                                                                                                     | 05/05/2026 | 05/05/2026      | Done   |
| 4   | - **Practice:** <br> &emsp; + Create VPC and Subnets <br> &emsp; + Create Security Groups <br> &emsp; + Launch EC2 Instance <br> &emsp                                                                                                                                                                                                                                            | 06/05/2026 | 06/05/2026      | Done   |
| 5   | - Learn Amazon EC2 fundamentals <br> &emsp; + Amazon EC2 architecture <br> &emsp; + Instance Types (Compute, Memory, Storage, Network Performance) <br> &emsp; + Amazon Machine Images (AMI) <br> &emsp; + Amazon EBS Volumes <br> &emsp; + Instance Store Volumes <br> &emsp; + Security Groups <br> &emsp; + Key Pairs <br> &emsp; + IAM Roles <br> &emsp; + Elastic IP Address | 07/05/2026 | 07/05/2026      | Done   |
| 6   | - **Practice:** <br> &emsp; + Launch an Amazon EC2 Instance <br> &emsp; + Configure Security Group Rules <br> &emsp; + Create and use Key Pair for SSH access <br> &emsp; + Connect to EC2 using SSH <br> &emsp; + Attach and mount Amazon EBS Volume <br> &emsp; + Monitor EC2 using Amazon CloudWatch <br> &emsp; + Create Tags for EC2 resource management                     | 08/05/2026 | 08/05/2026      | Done   |


### Week 3 Achievements

### Step 1: Learn AWS Networking and RDS Fundamentals

- Learned VPC, Subnets, Route Tables, and Security Groups
- Learned Amazon RDS concepts and DB deployment workflow
- Understood DB Instance, MySQL Engine, Backup, and Multi-AZ

### Step 2: Create AWS Infrastructure

- Created custom VPC and Subnets
- Configured Internet Gateway and Security Groups
- Launched Amazon EC2 Instance

### Step 3: Create and Connect Amazon RDS

- Created Amazon RDS MySQL Database
- Configured DB Subnet Group
- Connected EC2 to RDS using MySQL Client

```bash
sudo yum install mariadb105 -y
```

Step 4: Learn and Practice Amazon EC2

- Learned EC2 architecture, AMI, EBS, and Elastic IP
- Connected to EC2 using SSH
- Attached and mounted Amazon EBS Volume
- Monitored EC2 resources using Amazon CloudWatch

```bash
ssh -i key.pem ec2-user@public-ip
```

```bash
lsblk
```

```bash
df -h
```

## Week 3 Achievements

- Understood AWS networking and cloud infrastructure concepts
- Successfully created and configured EC2 and RDS resources
- Successfully connected EC2 to RDS database
- Learned Linux server administration and MySQL operations
- Learned EC2 monitoring and AWS resource management
- Improved practical AWS cloud deployment skills
