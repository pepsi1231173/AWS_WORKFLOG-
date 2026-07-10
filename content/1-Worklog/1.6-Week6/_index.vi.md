---
title: 'Worklog Tuần 6'
date: 2026-05-31
weight: 6
chapter: false
pre: ' <b> 1.6. </b> '
---

{{% notice warning %}}
**Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn, kể cả warning này.
{{% /notice %}}

### Mục tiêu tuần 6:

- Hoàn thành Lab 8: triển khai tài nguyên bằng CloudFormation và cấu hình giám sát EC2 với CloudWatch metrics, logs, metric filters, alarms và dashboards.
- Hoàn thành Lab 9: tìm hiểu AWS Support Center, support plans, tạo support case và quy trình tương tác support.
- Ghi lại minh chứng cho monitoring, alerting, dashboard và support case.

### Các công việc cần triển khai trong tuần này:

| Thứ | Công việc | Ngày bắt đầu | Ngày hoàn thành | Trạng thái |
| --- | --------- | ------------ | --------------- | ---------- |
| 2 | - Lab 8: triển khai CloudFormation stack và kiểm tra EC2 instances. | 25/05/2026 | 25/05/2026 | Hoàn thành |
| 3 | - Lab 8: xem EC2 metrics, CloudWatch Agent metrics, log groups và log streams. | 26/05/2026 | 26/05/2026 | Hoàn thành |
| 4 | - Lab 8: tạo metric filter, cấu hình alarm và xây dựng CloudWatch dashboard. | 27/05/2026 | 27/05/2026 | Hoàn thành |
| 5 | - Lab 9: mở AWS Support Center, xem danh sách cases và so sánh support plans. | 28/05/2026 | 28/05/2026 | Hoàn thành |
| 6 | - Lab 9: tạo bản nháp support case, điền subject/description, chọn service, category và severity. | 29/05/2026 | 29/05/2026 | Hoàn thành |
| 7 | - Lab 9: xem support interaction response, communication preference và minh chứng case cuối cùng. | 30/05/2026 | 30/05/2026 | Hoàn thành |

### Kết quả đạt được tuần 6:

### Lab 8:

- Triển khai CloudFormation stack và xác nhận EC2 resources được tạo.
- Kiểm tra EC2 metrics và CloudWatch Agent metrics.
- Xem log groups, log streams và lọc log trong CloudWatch Logs.
- Tạo metric filters, alarms và dashboard để phục vụ giám sát.

### Lab 9:

- Xem AWS Support Center home và danh sách support cases.
- So sánh các AWS support plans và thông tin trên support plan page.
- Thực hành điền support case với subject, description, service, category và severity.
- Xem support interaction response và minh chứng form cuối cùng.

### Hình ảnh minh chứng lab:

#### aws-lab-000008 - CloudFormation, giám sát EC2, CloudWatch logs, alarms và dashboard (12 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000008/01-cloudformation-stack.png" alt="aws-lab-000008 - 01-cloudformation-stack" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/02-ec2-instances.png" alt="aws-lab-000008 - 02-ec2-instances" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/03-cloudwatch-metrics-ec2.png" alt="aws-lab-000008 - 03-cloudwatch-metrics-ec2" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/04-cloudwatch-metrics-cwagent.png" alt="aws-lab-000008 - 04-cloudwatch-metrics-cwagent" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/05b-log-groups-filtered.png" alt="aws-lab-000008 - 05b-log-groups-filtered" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/05-log-group-messages.png" alt="aws-lab-000008 - 05-log-group-messages" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/06b-metric-filter-tab.png" alt="aws-lab-000008 - 06b-metric-filter-tab" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/06-metric-filter.png" alt="aws-lab-000008 - 06-metric-filter" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/06-metric-filter-result.png" alt="aws-lab-000008 - 06-metric-filter-result" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/07-alarm-python-error.png" alt="aws-lab-000008 - 07-alarm-python-error" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/08-dashboard-cloudwatch-workshop.png" alt="aws-lab-000008 - 08-dashboard-cloudwatch-workshop" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000008/12-cleanup-cloudformation-empty.png" alt="aws-lab-000008 - 12-cleanup-cloudformation-empty" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

#### aws-lab-000009 - AWS Support Center, support plans và quy trình tạo support case (12 ảnh)

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/01-support-center-home.png" alt="aws-lab-000009 - 01-support-center-home" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/02-support-cases-list-before.png" alt="aws-lab-000009 - 02-support-cases-list-before" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/03-create-case-start.png" alt="aws-lab-000009 - 03-create-case-start" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/04-support-plans-page.png" alt="aws-lab-000009 - 04-support-plans-page" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/05-support-interaction-filled-prompt.png" alt="aws-lab-000009 - 05-support-interaction-filled-prompt" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/06-support-interaction-response.png" alt="aws-lab-000009 - 06-support-interaction-response" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/07-create-case-form.png" alt="aws-lab-000009 - 07-create-case-form" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/08-case-form-subject-description.png" alt="aws-lab-000009 - 08-case-form-subject-description" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/09-case-form-dropdowns-before-select.png" alt="aws-lab-000009 - 09-case-form-dropdowns-before-select" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/10-case-form-filled-no-submit.png" alt="aws-lab-000009 - 10-case-form-filled-no-submit" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/11-case-type-dropdown-open.png" alt="aws-lab-000009 - 11-case-type-dropdown-open" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

<img src="/images/1-Worklog/labs/aws-lab-000009/screenshots-ui/12-cleanup-no-open-cases.png" alt="aws-lab-000009 - 12-cleanup-no-open-cases" loading="lazy" style="max-width: 100%; height: auto; margin: 12px 0; display: block;" />

