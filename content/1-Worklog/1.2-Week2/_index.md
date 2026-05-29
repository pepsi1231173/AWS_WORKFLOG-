---
title: 'Week 2 Worklog'
date: 2026-04-27
weight: 2
chapter: false
pre: '<b>1.2.</b>'
---

## 🎯 Week 2 Objectives

- Get familiar with Unity Engine and basic game development workflow
- Understand AWS IAM and implement secure permission management
- Prepare foundation for deploying game-related services on AWS

---

## 📅 Weekly Plan & Tracking

| Day | Date       | Tasks                                                                                                             | Status      | Notes |
| --- | ---------- | ----------------------------------------------------------------------------------------------------------------- | ----------- | ----- |
| Mon | 27/04/2026 | - Install Unity Hub & Unity Editor <br> - Explore Unity interface (Scene, Game, Inspector, Hierarchy)             | DONE        |       |
| Tue | 28/04/2026 | - Learn basic Unity concepts: <br> + GameObject <br> + Component <br> + Transform <br> - Create simple scene      | DONE        |       |
| Wed | 29/04/2026 | - Learn scripting with C# in Unity <br> - Create Player movement script <br> - Understand MonoBehaviour lifecycle | DONE        |       |
| Thu | 30/04/2026 | - Introduction to AWS IAM <br> - Understand Users, Groups, Roles, Policies                                        | DONE        |       |
| Fri | 01/05/2026 | - Practice: Create IAM Admin Group <br> - Assign permissions <br> - Add user to group                             | in progress |       |

---

## 🔐 AWS IAM Implementation (Detailed)

### Step 1: Create IAM Group

- Go to AWS Console → IAM → **User Groups**
- Click **Create group**
- Group name: `AdminGroup`

### Step 2: Attach Permissions

- Attach policy:
  - `AdministratorAccess` (for full access in development phase)

👉 Note: In production, should follow **Principle of Least Privilege**

---

### Step 3: Create IAM User

- Go to IAM → Users → Create user
- Enable:
  - AWS Management Console access
  - Programmatic access (for CLI)

---

### Step 4: Add User to Group

- Assign user to `AdminGroup`
- Verify permissions inherited from group

---

### Step 5: Configure AWS CLI

```bash
aws configure
```
