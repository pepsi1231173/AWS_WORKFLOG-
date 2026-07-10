---
title: "SNS Admin Alert Setup"
date: 2024-01-01
weight: 13
chapter: false
pre: " <b> 5.13. </b> "
---

#### Objective

In this step, the team configures **Amazon SNS** to create an admin alert system for the RoughLife backend. SNS is used to receive notifications from CloudWatch Alarms and send email alerts to the administrator.

In the RoughLife architecture, SNS Admin Alert works as part of the operational monitoring layer. When the Lambda Room API has errors, CloudWatch Alarm can trigger an SNS Topic to send an email notification to the admin. This helps the team detect backend issues earlier instead of only checking logs manually in the AWS Console.

The main components in this step include:

- **Amazon SNS Topic**: receives alerts from CloudWatch.
- **Email Subscription**: the admin email address that receives notifications.
- **CloudWatch Alarm Action**: sends alarm notifications to the SNS Topic.
- **Test Email**: confirms that the alert email is delivered successfully.

---

#### Implementation Steps

1. Open **Amazon SNS** in the AWS Console.
2. Create a new topic for admin alerts, for example `RoughLifeAdminAlert`.
3. Create an email subscription for the topic.
4. Confirm the subscription from the AWS confirmation email.
5. Open **Amazon CloudWatch** and create or edit an Alarm.
6. Configure the Alarm action to send notifications to the SNS Topic.
7. Send a test notification to confirm that the admin can receive alerts.

---

#### SNS Topic Creation Evidence

![SNS Topic Created](/images/5-Workshop/5.13-sns-admin-alert/12_01_SNS_Topic_Created.png)

The image above shows that the SNS Topic was created successfully. This topic acts as the notification channel that receives alerts from CloudWatch and distributes them to the admin email.

---

#### Email Subscription Confirmation Evidence

![SNS Email Subscription Confirmed](/images/5-Workshop/5.13-sns-admin-alert/12_02_SNS_Email_Subscription_Confirmed.png)

The image above shows that the email subscription was confirmed. After confirmation, SNS can send alert emails to the administrator.

---

#### CloudWatch Alarm SNS Action Evidence

![CloudWatch Alarm SNS Action](/images/5-Workshop/5.13-sns-admin-alert/12_03_CloudWatch_Alarm_SNS_Action.png)

The image above shows that the CloudWatch Alarm action was configured to send notifications to the SNS Topic. When the alarm condition is triggered, CloudWatch sends the notification to SNS, and SNS delivers the email alert.

In the RoughLife system, the alarm can be used to monitor important backend issues such as:

- Lambda Room API errors.
- Error count exceeding the configured threshold.
- Abnormal backend responses.
- API failures during room creation or room listing.

---

#### Alert Email Evidence

![SNS Test Email](/images/5-Workshop/5.13-sns-admin-alert/12_04_SNS_Test_Email.png)

The image above shows that the alert email was delivered successfully to the admin. This proves that the operational alerting system is working.

---

#### Role of SNS in the RoughLife System

SNS helps the RoughLife system notify the team when backend issues occur instead of relying only on manual log checking.

In the online multiplayer architecture, SNS can be used to alert issues such as:

- Room creation API failures.
- Lambda failing to write data to DynamoDB.
- Abnormal increase in backend errors.
- Sudden increase in cost or request count.
- Game server or matchmaking layer issues.

This alerting layer helps the team respond faster when operating the game online for multiple players.

---

#### Result

After this step, the team successfully configured SNS Admin Alert for the RoughLife system. The SNS Topic was created, the email subscription was confirmed, and CloudWatch Alarm can send notifications to the admin email.

This is an important part of the monitoring and operations layer, helping the team detect backend issues earlier during AWS online game deployment.