---
title: "Cấu hình CloudWatch Logs và Alarm"
date: 2024-01-01
weight: 12
chapter: false
pre: " <b> 5.12. </b> "
---

#### Mục tiêu

Trong bước này, nhóm cấu hình **Amazon CloudWatch** để giám sát hoạt động của hệ thống backend serverless cho game RoughLife. CloudWatch được sử dụng để theo dõi log của Lambda `RoughLifeRoomApi`, kiểm tra các lần gọi API, quan sát thời gian xử lý request, mức sử dụng bộ nhớ và tạo cảnh báo khi Lambda phát sinh lỗi.

Đây là bước quan trọng trong hệ thống online multiplayer vì backend cần có khả năng theo dõi, kiểm tra lỗi và phát hiện sự cố trong quá trình người chơi tạo phòng, lấy danh sách phòng, lưu dữ liệu người chơi hoặc lưu kết quả trận đấu.

---

#### Vai trò của CloudWatch trong hệ thống RoughLife

Trong kiến trúc online của RoughLife, CloudWatch đóng vai trò là lớp quan sát hệ thống.

CloudWatch giúp nhóm theo dõi:

- Log được sinh ra từ Lambda `RoughLifeRoomApi`.
- Các lần gọi API gần nhất.
- Thời gian xử lý request của Lambda.
- Billed duration và memory usage.
- Các lỗi runtime hoặc lỗi xử lý request.
- Alarm khi Lambda có lỗi phát sinh.

Luồng giám sát tổng quát:

1. Unity Client gọi API Gateway.
2. API Gateway chuyển request đến Lambda `RoughLifeRoomApi`.
3. Lambda xử lý request và ghi log tự động lên CloudWatch Logs.
4. CloudWatch hiển thị log event, invocation metrics và alarm.
5. Khi Lambda có lỗi, CloudWatch Alarm có thể chuyển sang trạng thái cảnh báo.

---

#### Các bước thực hiện

1. Truy cập **AWS Lambda** và mở function `RoughLifeRoomApi`.
2. Vào tab **Monitor** để kiểm tra CloudWatch Logs.
3. Mở log group `/aws/lambda/RoughLifeRoomApi`.
4. Kiểm tra các log stream và log events được tạo sau mỗi lần Lambda được gọi.
5. Xem bảng **Recent invocations** để kiểm tra duration, billed duration và memory used.
6. Tạo CloudWatch Alarm cho metric `Errors` của Lambda.
7. Cấu hình điều kiện alarm: nếu số lỗi Lambda lớn hơn hoặc bằng 1 trong 5 phút thì kích hoạt alarm.
8. Kiểm tra alarm đã được tạo trong danh sách CloudWatch Alarms.

---

#### Minh chứng CloudWatch Log Group

![CloudWatch Log Group](/images/5-Workshop/5.12-CloudWatch Logs, Monitor, Alarm/11_01_CloudWatch_LogGroup.png)

Hình trên thể hiện log group của Lambda `RoughLifeRoomApi` trong Amazon CloudWatch. Log group có dạng:

`/aws/lambda/RoughLifeRoomApi`

Bên trong log group có các log events được tạo ra sau khi Lambda được thực thi. Các dòng log như `END RequestId` và `REPORT RequestId` cho thấy Lambda đã chạy xong request và CloudWatch đã ghi nhận thông tin thực thi.

Thông tin trong log bao gồm:

- Request ID của mỗi lần gọi Lambda.
- Duration của request.
- Billed duration.
- Memory size được cấp phát.
- Max memory used trong lần thực thi.

Điều này chứng minh Lambda đã kết nối thành công với CloudWatch Logs.

---

#### Minh chứng Recent Invocations của Lambda

![CloudWatch Lambda Recent Invocations](/images/5-Workshop/5.12-CloudWatch Logs, Monitor, Alarm/11_02_CloudWatch_Lambda_Recent_Invocations.png)

Hình trên thể hiện phần **CloudWatch Logs** trong tab Monitor của Lambda `RoughLifeRoomApi`. Bảng **Recent invocations** hiển thị các lần Lambda được gọi gần nhất.

Mỗi invocation có các thông tin quan trọng như:

- Timestamp.
- RequestId.
- LogStream.
- DurationInMS.
- BilledDurationInMS.
- MemorySetInMB.
- MemoryUsedInMB.

Ngoài ra, CloudWatch cũng hiển thị bảng **Most expensive invocations in GB-seconds**, giúp nhóm nhận biết những lần gọi Lambda có chi phí xử lý cao hơn. Đây là thông tin hữu ích để tối ưu hiệu năng và chi phí khi hệ thống online được mở rộng.

---

#### Minh chứng Log Events chi tiết

![CloudWatch Log Events](/images/5-Workshop/5.12-CloudWatch Logs, Monitor, Alarm/11_03_CloudWatch_LogEvents.png)

Hình trên thể hiện log events chi tiết trong một log stream của Lambda. Các dòng log gồm:

- `START RequestId`: Lambda bắt đầu xử lý request.
- `END RequestId`: Lambda kết thúc xử lý request.
- `REPORT RequestId`: CloudWatch ghi nhận thời gian xử lý, thời gian tính phí và bộ nhớ sử dụng.

Trong minh chứng, Lambda có duration khoảng vài trăm milliseconds và sử dụng bộ nhớ dưới mức 128 MB được cấp phát. Điều này cho thấy Room API hiện tại hoạt động nhẹ, phù hợp với backend serverless cho các chức năng lobby cơ bản như tạo phòng, lấy danh sách phòng và lưu dữ liệu.

---

#### Tạo CloudWatch Alarm cho Lambda Error

![Create Lambda Error Alarm](/images/5-Workshop/5.12-CloudWatch Logs, Monitor, Alarm/11_04_CloudWatch_Create_Lambda_Error_Alarm.png)

Hình trên thể hiện quá trình tạo alarm cho metric `Errors` của Lambda `RoughLifeRoomApi`.

Cấu hình alarm chính:

- Namespace: `AWS/Lambda`
- Metric name: `Errors`
- FunctionName: `RoughLifeRoomApi`
- Statistic: `Sum`
- Period: `5 minutes`
- Threshold type: `Static`
- Condition: `Greater/Equal`
- Threshold value: `1`
- Datapoints to alarm: `1 out of 1`

Với cấu hình này, nếu Lambda phát sinh từ 1 lỗi trở lên trong vòng 5 phút, CloudWatch Alarm sẽ chuyển sang trạng thái cảnh báo. Cấu hình này giúp nhóm phát hiện nhanh các lỗi trong backend Room API.

---

#### Minh chứng Alarm đã được tạo

![CloudWatch Alarm Created](/images/5-Workshop/5.12-CloudWatch Logs, Monitor, Alarm/11_05_CloudWatch_Alarm_Created.png)

Hình trên thể hiện alarm `RoughLifeRoomApi-Lambda-Error-Alarm` đã được tạo thành công trong CloudWatch Alarms.

Alarm đang ở trạng thái **Insufficient data** vì tại thời điểm tạo chưa có lỗi mới nào được ghi nhận đủ để đánh giá trạng thái. Đây là trạng thái bình thường sau khi alarm vừa được tạo hoặc khi hệ thống chưa phát sinh dữ liệu lỗi.

Khi Lambda có lỗi thực tế, alarm sẽ chuyển sang trạng thái **In alarm** nếu điều kiện `Errors >= 1` trong 5 phút được thỏa mãn.

---

#### Kết quả

Sau bước này, hệ thống RoughLife đã có lớp monitoring cơ bản cho backend serverless. Lambda `RoughLifeRoomApi` đã ghi log thành công lên Amazon CloudWatch Logs. Nhóm có thể kiểm tra từng request, thời gian xử lý, bộ nhớ sử dụng và các lỗi phát sinh trong quá trình vận hành.

Ngoài ra, CloudWatch Alarm đã được cấu hình để theo dõi metric `Errors` của Lambda. Điều này giúp hệ thống có khả năng phát hiện sự cố sớm khi backend Room API gặp lỗi.

Việc bổ sung CloudWatch giúp kiến trúc online của RoughLife trở nên thực tế hơn, vì một hệ thống game online cần có khả năng quan sát, kiểm tra lỗi và cảnh báo trong quá trình vận hành.