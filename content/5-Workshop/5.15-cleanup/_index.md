---
title: "AWS Resources Cleanup"
date: 2024-01-01
weight: 15
chapter: false
pre: " <b> 5.15. </b> "
---

#### Objective

After completing the AWS evidence setup for the RoughLife online game system, the team performs a **Cleanup** step to delete or disable resources that are no longer needed. The purpose of this step is to avoid unnecessary maintenance costs after the report and demo are completed.

The workshop created several AWS resources, including S3, CloudFront, WAF, Cognito, DynamoDB, Lambda, API Gateway, SNS, CloudWatch Alarm, X-Ray, and GameLift. Some services may generate cost if they remain active or continue receiving requests, so cleanup must be done carefully.

---

#### Cleanup Principles

When cleaning up AWS resources, the team follows these principles:

- Delete resources in the correct dependency order.
- Delete or disable services that may generate cost.
- Empty the S3 bucket before deleting it.
- Disable CloudFront before deleting the Distribution.
- Delete API Gateway before deleting Lambda if the API is no longer needed.
- Delete CloudWatch Alarm and SNS Topic if alerting is no longer needed.
- Delete DynamoDB tables if test data no longer needs to be stored.
- Check the Billing Dashboard after cleanup.

---

#### Recommended Cleanup Order

#### 1. Cleanup GameLift

First, check Amazon GameLift Servers.

Resources to review:

- Managed EC2 Fleet if it was created successfully.
- Anywhere Fleet if it was created successfully.
- GameLift Build.
- Fleet Alias.
- Game Session Queue.
- Custom Location if no longer needed.

In this project, fleet creation was not completed due to the quota limit. However, the `RoughLifeServer` build was uploaded to GameLift, so the build should be deleted if it is no longer needed.

---

#### 2. Cleanup CloudWatch Alarm and SNS

Open **CloudWatch** and delete the alarms created for the backend.

Then open **Amazon SNS** and delete:

- Email subscription.
- SNS Topic used for admin alerts.

This stops the alerting workflow and removes unused notification resources.

---

#### 3. Disable X-Ray Active Tracing

Open the `RoughLifeRoomApi` Lambda function, go to **Monitoring and operations tools**, and disable **Active tracing** if tracing is no longer needed.

If the Lambda function will be deleted in the next step, disabling X-Ray is optional. However, it is still a good practice if the Lambda function is kept but tracing is no longer required.

---

#### 4. Cleanup API Gateway

Open **Amazon API Gateway** and delete the HTTP API `RoughLifeRoomHttpApi`.

Resources to remove:

- `/room` route.
- `$default` stage.
- `RoughLifeRoomHttpApi` API.

If API Gateway remains active, clients can still call the public backend endpoint. Therefore, it should be deleted when the demo is finished.

---

#### 5. Cleanup Lambda

Open **AWS Lambda** and delete the `RoughLifeRoomApi` function.

Before deleting it, check:

- Function URL if one exists.
- API Gateway trigger.
- Environment variables.
- Related IAM role.

After deleting the Lambda function, the team can also delete the IAM Role and custom policies created specifically for this function.

IAM resources to review:

- `RoughLifeRoomApi` role.
- Inline policy or customer managed policy for DynamoDB access.
- Lambda execution role if it was created only for this function.

---

#### 6. Cleanup DynamoDB

Open **Amazon DynamoDB** and delete the test tables if the data is no longer needed.

Tables to delete:

- `RoughLifeRooms`
- `RoughLifePlayerSave`
- `RoughLifeMatchResult`

Before deleting the tables, the team may export test data if it is needed for evidence. Otherwise, the tables can be deleted to avoid unnecessary storage or request costs.

---

#### 7. Cleanup Cognito

Open **Amazon Cognito** and delete the RoughLife User Pool.

Items to check:

- User Pool.
- App Client.
- Hosted UI domain if configured.
- Test users if created.

After deleting the User Pool, the related App Client and authentication configuration are no longer used.

---

#### 8. Cleanup AWS WAF

Open **AWS WAF & Shield** and delete the Web ACL or Protection Pack attached to CloudFront.

Before deleting the Web ACL, remove the association from the CloudFront Distribution if AWS requires it. Then delete the Web ACL to remove unused protection rules.

---

#### 9. Cleanup CloudFront

Open **Amazon CloudFront**.

Steps:

1. Select the RoughLife Distribution.
2. Disable the Distribution.
3. Wait until the disable process is completed.
4. Delete the Distribution.
5. Delete the Origin Access Control if it is no longer used.

CloudFront usually must be disabled before it can be deleted. After deletion, the CloudFront release file domain will no longer be accessible.

---

#### 10. Cleanup S3 Release Bucket

Open **Amazon S3** and clean up the bucket `roughlife-release-bucket-letran-20260709`.

Steps:

1. Open the bucket.
2. Delete all objects in the bucket.
3. Delete object versions if versioning was enabled.
4. Delete the bucket after it is empty.

Files to remove include:

- `version.json`
- `patch_manifest.json`
- `builds/windows/RoughLife_Client_Window.zip`

---

#### 11. Check Billing and Budget

After cleanup, open **Billing and Cost Management** to check the account cost.

Items to check:

- Current month cost.
- Free Tier usage if available.
- Cost Explorer.
- Budget alerts.

The Budget can be kept to continue monitoring the AWS account. If it is no longer needed, the team can delete it at the end.

---

#### Cleanup Checklist

The team uses the following checklist to verify that unused resources are removed:

- GameLift Build/Fleet/Queue/Alias checked or deleted.
- CloudWatch Alarm deleted.
- SNS Topic and Email Subscription deleted.
- X-Ray Active tracing disabled or Lambda deleted.
- API Gateway HTTP API deleted.
- Lambda `RoughLifeRoomApi` deleted.
- Unused IAM Role/Policy deleted.
- DynamoDB tables deleted.
- Cognito User Pool deleted.
- AWS WAF Web ACL deleted.
- CloudFront Distribution disabled and deleted.
- S3 Release Bucket emptied and deleted.
- Billing Dashboard checked after cleanup.

---

#### Result

After the Cleanup step, the AWS resources used for evidence were deleted or disabled to avoid unnecessary maintenance costs. This helps the team manage the AWS account more safely after completing the online game server setup report.

The cleanup step also demonstrates responsible cloud operation: create resources for demonstration, collect evidence, and remove unused resources afterward to optimize cost.