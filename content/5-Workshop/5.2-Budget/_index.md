---
title: "AWS Budget Setup"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

#### Objective

In this step, the team configures **AWS Budgets** to monitor the cost of AWS resources used for the RoughLife online multiplayer system. This is an important step to reduce the risk of unexpected costs during the testing and evidence collection process.

The budget is configured with a monthly cost limit and email alerts. When the actual or forecasted cost exceeds the configured threshold, AWS sends a notification to the registered email address.

#### Implementation Steps

1. Open **Billing and Cost Management** in the AWS Console.
2. Select **Budgets** under the **Budgets and Planning** section.
3. Create a new budget named `RoughLife-Monthly-Budget`.
4. Set the monthly budget amount to **10 USD**.
5. Configure alert thresholds such as 85% and 100%.
6. Enter the email address that will receive budget notifications.
7. Create the budget and verify its status.

#### Budget Configuration Evidence

![Budget setting](/images/5-Workshop/5.2-Budget/01_BudgetSetting.png)

The image above shows the monthly budget configuration for the RoughLife project. The budget amount is set to 10 USD to help control AWS costs during testing.

![Budget alert setup](/images/5-Workshop/5.2-Budget/01_AlertSetup.png)

The image above shows the alert configuration. AWS will send an email notification when the actual cost exceeds the configured threshold.

#### Result

After completing this step, the AWS Budget was created successfully and displayed a healthy status. This helps the team monitor AWS spending while testing the cloud infrastructure for RoughLife.