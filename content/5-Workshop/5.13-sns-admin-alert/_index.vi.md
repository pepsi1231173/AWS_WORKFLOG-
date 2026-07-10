---
title: "Thiết lập SNS Admin Alert"
date: 2024-01-01
weight: 13
chapter: false
pre: " <b> 5.13. </b> "
---

#### Mục tiêu

Trong bước này, nhóm thiết lập **Amazon SNS** để tạo hệ thống cảnh báo cho admin khi backend của game RoughLife gặp sự cố. SNS được sử dụng để nhận thông báo từ CloudWatch Alarm và gửi email đến người quản trị.

Trong kiến trúc RoughLife, SNS Admin Alert đóng vai trò là lớp cảnh báo vận hành. Khi Lambda Room API phát sinh lỗi, CloudWatch Alarm có thể kích hoạt SNS Topic để gửi email thông báo cho admin. Điều này giúp nhóm phát hiện lỗi backend sớm hơn thay vì chỉ kiểm tra thủ công trong AWS Console.

Các thành phần chính trong bước này gồm:

- **Amazon SNS Topic**: nơi nhận cảnh báo từ CloudWatch.
- **Email Subscription**: email của admin dùng để nhận cảnh báo.
- **CloudWatch Alarm Action**: hành động gửi cảnh báo đến SNS Topic.
- **Test Email**: minh chứng email cảnh báo đã được gửi thành công.

---

#### Các bước thực hiện

1. Truy cập dịch vụ **Amazon SNS**.
2. Tạo topic mới với tên dùng cho cảnh báo admin, ví dụ `RoughLifeAdminAlert`.
3. Tạo email subscription cho topic.
4. Xác nhận subscription thông qua email AWS gửi về.
5. Truy cập **Amazon CloudWatch** và tạo hoặc chỉnh sửa Alarm.
6. Cấu hình Alarm action để gửi thông báo đến SNS Topic.
7. Test gửi email để xác nhận admin có thể nhận cảnh báo.

---

#### Minh chứng tạo SNS Topic

![SNS Topic Created](/images/5-Workshop/5.13-sns-admin-alert/12_01_SNS_Topic_Created.png)

Hình trên thể hiện SNS Topic đã được tạo thành công. Topic này đóng vai trò là kênh nhận cảnh báo từ CloudWatch và phân phối thông báo đến email admin.

---

#### Minh chứng xác nhận Email Subscription

![SNS Email Subscription Confirmed](/images/5-Workshop/5.13-sns-admin-alert/12_02_SNS_Email_Subscription_Confirmed.png)

Hình trên thể hiện email subscription đã được xác nhận. Sau khi trạng thái subscription được xác nhận, SNS có thể gửi email cảnh báo đến người quản trị.

---

#### Minh chứng CloudWatch Alarm gửi cảnh báo đến SNS

![CloudWatch Alarm SNS Action](/images/5-Workshop/5.13-sns-admin-alert/12_03_CloudWatch_Alarm_SNS_Action.png)

Hình trên thể hiện CloudWatch Alarm đã được cấu hình action để gửi thông báo đến SNS Topic. Khi điều kiện alarm xảy ra, CloudWatch sẽ kích hoạt SNS để gửi email cảnh báo.

Trong hệ thống RoughLife, Alarm có thể được dùng để theo dõi các lỗi quan trọng như:

- Lambda Room API phát sinh lỗi.
- Số lượng lỗi vượt ngưỡng cho phép.
- Backend phản hồi bất thường.
- Hệ thống API gặp vấn đề trong quá trình tạo phòng hoặc lấy danh sách phòng.

---

#### Minh chứng email cảnh báo

![SNS Test Email](/images/5-Workshop/5.13-sns-admin-alert/12_04_SNS_Test_Email.png)

Hình trên thể hiện email cảnh báo đã được gửi thành công đến admin. Đây là minh chứng cho thấy hệ thống cảnh báo vận hành đã hoạt động.

---

#### Vai trò của SNS trong hệ thống RoughLife

SNS giúp hệ thống RoughLife có khả năng cảnh báo sự cố thay vì chỉ dựa vào việc kiểm tra log thủ công.

Trong kiến trúc online multiplayer, SNS có thể được dùng để cảnh báo các vấn đề như:

- API tạo phòng bị lỗi.
- Lambda không ghi được dữ liệu vào DynamoDB.
- Backend có số lượng lỗi tăng bất thường.
- Chi phí hoặc số lượng request tăng đột biến.
- Game server hoặc matchmaking layer có dấu hiệu bất thường.

Việc có hệ thống cảnh báo giúp nhóm phản ứng nhanh hơn khi vận hành game online cho nhiều người chơi.

---

#### Kết quả

Sau bước này, nhóm đã thiết lập thành công SNS Admin Alert cho hệ thống RoughLife. SNS Topic đã được tạo, email subscription đã được xác nhận và CloudWatch Alarm có thể gửi cảnh báo đến email admin.

Đây là bước quan trọng trong lớp vận hành và giám sát hệ thống, giúp nhóm phát hiện lỗi backend sớm hơn trong quá trình triển khai game online trên AWS.