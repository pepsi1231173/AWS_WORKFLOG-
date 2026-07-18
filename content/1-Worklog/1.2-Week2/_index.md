---
title: 'Week 2 - Unity Basics and AWS IAM'
date: 2026-04-27
weight: 2
chapter: false
pre: '<b>1.2.</b>'
---

## 🎯 Week 2 Objectives

- Become familiar with the Unity Engine environment and the basic game development process.
- Learn the fundamentals of AWS Identity and Access Management (IAM).
- Build a solid foundation for deploying Unity-related services on AWS in future weeks.

---

## 📅 Weekly Plan & Tracking

| Day | Date       | Tasks                                                                                                                                              | Status | Notes |
| --- | ---------- | -------------------------------------------------------------------------------------------------------------------------------------------------- | ------ | ----- |
| Mon | 27/04/2026 | - Install Unity Hub and Unity Editor.<br>- Explore the Unity workspace, including Scene, Game, Hierarchy, and Inspector windows.                   | Done   |       |
| Tue | 28/04/2026 | - Study Unity core concepts:<br>&nbsp;&nbsp; + GameObject<br>&nbsp;&nbsp;+ Component<br>&nbsp;&nbsp;+ Transform<br>- Build a basic practice scene. | Done   |       |
| Wed | 29/04/2026 | - Learn C# scripting in Unity.<br>- Implement a simple player movement script.<br>- Understand the MonoBehaviour execution lifecycle.              | Done   |       |
| Thu | 30/04/2026 | - Explore AWS IAM fundamentals.<br>- Learn about Users, User Groups, Roles, and Policies.                                                          | Done   |       |
| Fri | 01/05/2026 | - Create an IAM administrator group.<br>- Configure permissions.<br>- Add a user to the group for testing.                                         | Done   |       |

---

## 🔐 AWS IAM Implementation (Detailed)

### Step 1: Create a User Group - Open the AWS Management Console.

- Navigate to **IAM → User Groups**.
- Select **Create group**.
- Create a group named `AdminGroup`.

### Step 2: Attach Permissions

- Attach the following managed policy:
- `AdministratorAccess`> **Note:** This permission is suitable for learning and development. In production environments, permissions should always follow the **Principle of Least Privilege**.

👉 Note: In production, should follow **Principle of Least Privilege**

---

### Step 3: Create IAM User

- Go to **IAM → Users**.
- Choose **Create user**.
- Enable the following access methods:

* AWS Management Console access.
* Programmatic access for AWS CLI.

---

### Step 4: Add User to Group

- Assign the newly created user to `AdminGroup`.
- Confirm that the user's permissions are inherited from the group.

---

### Step 5: Configure AWS CLI

Run the following command and enter the required AWS credentials:

```bash
aws configure
```
