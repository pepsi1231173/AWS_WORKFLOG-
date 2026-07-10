---
title: "Thiết lập AWS Budget"
date: 2024-01-01
weight: 2
chapter: false
pre: " <b> 5.2. </b> "
---

#### Mục tiêu

Trong bước này, nhóm thiết lập **AWS Budget** để theo dõi chi phí khi triển khai các tài nguyên AWS cho hệ thống game online RoughLife. Đây là bước quan trọng nhằm hạn chế rủi ro phát sinh chi phí ngoài dự kiến trong quá trình thử nghiệm các dịch vụ như S3, CloudFront, WAF, Cognito, DynamoDB và GameLift.

Budget được cấu hình với ngưỡng chi phí hàng tháng và email cảnh báo. Khi chi phí thực tế hoặc chi phí dự báo vượt ngưỡng, AWS sẽ gửi thông báo đến email đã đăng ký.

#### Các bước thực hiện

1. Truy cập **Billing and Cost Management** trên AWS Console.
2. Chọn **Budgets** trong nhóm **Budgets and Planning**.
3. Tạo budget mới với tên `RoughLife-Monthly-Budget`.
4. Thiết lập ngân sách hàng tháng là **10 USD**.
5. Cấu hình cảnh báo khi chi phí đạt các ngưỡng như 85% và 100%.
6. Nhập email nhận cảnh báo để AWS gửi thông báo khi vượt ngưỡng.
7. Tạo budget và kiểm tra trạng thái hoạt động.

#### Minh chứng cấu hình Budget

![Budget setting](/images/5-Workshop/5.2-Budget/01_BudgetSetting.png)

Hình trên thể hiện phần cấu hình ngân sách hàng tháng cho dự án RoughLife. Budget được đặt ở mức 10 USD nhằm kiểm soát chi phí trong quá trình triển khai thử nghiệm.

![Budget alert setup](/images/5-Workshop/5.2-Budget/01_AlertSetup.png)

Hình trên thể hiện cấu hình cảnh báo chi phí. AWS sẽ gửi email khi chi phí thực tế vượt ngưỡng đã cấu hình.

#### Kết quả

Sau khi hoàn tất, AWS Budget đã được tạo thành công và hiển thị trạng thái **Healthy**. Việc thiết lập budget giúp nhóm có thể kiểm soát chi phí trong quá trình thử nghiệm hệ thống cloud cho game RoughLife.