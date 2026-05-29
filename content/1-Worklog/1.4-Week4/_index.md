---
title: 'Week 4 Worklog'
date: 2026-05-14
weight: 1
chapter: false
pre: ' <b> 1.4. </b> '
---

{{% notice warning %}}
⚠️ **Note:** The following information is for reference purposes only. Please **do not copy verbatim** for your own report, including this warning.
{{% /notice %}}

### Week 4 Objectives:

- Create budget.
- Understand basic AWS services, how to use the console & CLI.

### Tasks to be carried out this week:

| Day | Task                                                                                                                                                                                                                                                                                                | Start Date | Completion Date | Status |
| --- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | --------------- | ------ |
| 2   | - Create Budget <br> - Create Cost Budget <br> - Create Usage Budget                                                                                                                                                                                                                                | 11/05/2026 | 11/05/2026      | Done   |
| 3   | - Create RI Budget <br>- Create Savings Plans Budget <br>                                                                                                                                                                                                                                           | 12/05/2026 | 12/05/2026      | Done   |
| 4   | - Read Introduction <br> - Take the preparation steps <br>                                                                                                                                                                                                                                          | 12/05/2026 | 12/05/2026      | Done   |
| 5   | - Learn basic CloudWatch Metrics: <br>&emsp; + Viewing Metrics <br>&emsp; + Search expressions <br>&emsp; + Math expressions <br>&emsp; + Dynamic Labels <br> - Learn basic CloudWatch Logs <br>&emsp; + CloudWatch Logs <br>&emsp;+ CloudWatch Logs Insights<br> &emsp; + CloudWatch Metric Filter | 13/05/2026 | 13/05/2026      | Done   |
| 6   | - CloudWatch Alarms<br> - CloudWatch Dashboards <br>                                                                                                                                                                                                                                                | 14/05/2026 | 14/05/2026      | Done   |

### Week 4 Achievements:

## Step 1: Create Budget

- Find and select AWS Billing and Cost Management service.
- Select **Budgets** -> **Create budget**

## Step 2: Create Cost Budget

- Find and select AWS Billing and Cost Management service.
- Select **Budgets** -> **Create budget**.
- In the Budget setup section:

* Select **Customize**
* Under **Budget types**, select **Cost budget**

- Then follow the setup steps -> **Create budget** to complete.

## Step 3: Create RI Budget

- Similar to step 2
- At **Budget setup**:

* Select **Customize**
* Select **Reservation budget**

- Then follow the setup steps -> **Create budget** to complete.

## Step 4: Create Savings Plans Budget

- Similar to step 2
- At **Budget setup**:

* Select **Customize**
* Under **Budget types**, select **Savings Plans budget**

- Then follow the setup steps ->**Create budget** to complete.

## Step 5: CloudWatch Metrics + CloudWatch Logs + CloudWatch Alarms + CloudWatch Dashboards

![alt text](image.png)

## 1. CloudWatch Metrics

### Steps Performed

- Searched for CloudWatch and opened the service.
- In the left navigation pane, selected Metrics > All metrics.
- Searched for EC2 metrics.
- Opened EC2 > Per-Instance Metrics.
- Filtered the metric CPUUtilization.
- Selected two EC2 instances to compare their CPU performance.
- Observed workload activity from the graph.
- Searched for EBSWriteBytes to analyze storage activity.

## 2. Search Expressions

### Steps Performed

1. Cleared the old graph.
2. Returned to the Browse tab.
3. Added CPUUtilization metric.
4. Clicked Graph search.
5. Added search expressions such as:
   - SEARCH("disk_used_percent", 'Average', 300)
   - SEARCH("used", 'Average', 300)

6. Changed graph style to Stacked area.

### Result

Search expressions simplified metric discovery and improved graph readability for monitoring multiple metrics.

---

## 3. Mathematical Expressions

### Steps Performed

1. Cleared previous expressions.
2. Returned to Browse tab.
3. Clicked Add math.
4. Selected Top 10 by sum.
5. Applied the expression:
   SORT(e1, SUM, DEC, 3)

### Result

The graph automatically sorted metrics based on total values, helping identify the most active resources.

---

## 4. Dynamic Labels

### Steps Performed

1. Cleared previous filters and expressions.
2. Opened the CWAgent namespace.
3. Selected dimensions:
   - ImageId
   - InstanceId
   - InstanceType
   - exe
   - process_name

4. Filtered using:
   - exe=cloudwatch
   - MetricName=procstat_memory_rss

5. Clicked Graph search.
6. Added dynamic labels using:
   ${PROP('Dim.exe')} - ${PROP('Dim.InstanceId')} - ${PROP('MetricName')}

### Result

Dynamic labels automatically updated graph names and improved metric identification.

---

## 5. CloudWatch Logs

### Steps Performed

1. Opened CloudWatch console.
2. Selected Logs > Log groups.
3. Searched for /ec2/linux/var/log/messages.
4. Opened a log stream from an EC2 instance.
5. Viewed system log entries.
6. Configured log retention to 1 week.

### Result

CloudWatch Logs stored and organized EC2 system logs for monitoring and troubleshooting purposes.

---

## 6. CloudWatch Logs Insights

### Steps Performed

1. Opened EC2 Console.
2. Connected to an EC2 instance using Session Manager.
3. Downloaded and executed logger.py script.
4. Monitored logs using:
   sudo tail -f /var/log/messages
5. Opened CloudWatch Logs Insights.
6. Ran queries such as:
   - ERROR logs
   - WARN logs
   - eth0 logs

7. Visualized query results.
8. Saved queries for future use.

### Result

Logs Insights enabled advanced log searching, filtering, and visualization for application monitoring.

---

## 7. CloudWatch Metric Filter

### Steps Performed

1. Opened the log group /ec2/linux/var/log/messages.
2. Selected Create metric filter.
3. Used ERROR as the filter pattern.
4. Configured:
   - Metric namespace: ec2-logs
   - Metric name: /var/log/messages - ERROR
   - Metric value: 1

5. Created the metric filter.

### Result

The metric filter converted ERROR log events into CloudWatch metrics for monitoring.

---

## 8. CloudWatch Alarms

### Steps Performed

1. Opened CloudWatch Alarms.
2. Clicked Create alarm.
3. Selected the custom ERROR metric.
4. Configured:
   - Period: 1 minute
   - Threshold: Greater than 10

5. Created an SNS topic for email notifications.
6. Named the alarm PythonApplicationErrorAlarm.
7. Confirmed the SNS subscription via email.

### Result

The alarm monitored application errors and sent notifications when the threshold was exceeded.

---

## 9. CloudWatch Dashboard

### Steps Performed

1. Selected the created alarm.
2. Clicked Add to dashboard.
3. Created a dashboard named CloudWatch-Workshop.
4. Added alarm widgets to the dashboard.

### Result

The dashboard provided a centralized view of monitoring metrics and alarms.

---

## Conclusion

I learned how to use Amazon CloudWatch to monitor AWS resources, analyze logs, create alarms, and build dashboards. The lab provided practical experience with metrics visualization, log analysis, and automated monitoring in AWS.
