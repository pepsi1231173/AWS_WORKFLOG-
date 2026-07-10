---
title: "Thiết lập AWS X-Ray Trace"
date: 2024-01-01
weight: 14
chapter: false
pre: " <b> 5.14. </b> "
---

#### Mục tiêu

Trong bước này, nhóm bật **AWS X-Ray** cho Lambda `RoughLifeRoomApi` để chuẩn bị khả năng tracing cho backend serverless của game RoughLife.

AWS X-Ray giúp theo dõi luồng xử lý request trong hệ thống backend. Khi Unity Client gọi API Gateway và API Gateway gọi Lambda, X-Ray có thể hỗ trợ ghi nhận trace để nhóm phân tích thời gian xử lý, lỗi và các điểm nghẽn trong quá trình request đi qua backend.

Trong kiến trúc RoughLife, X-Ray được đặt trong lớp quan sát hệ thống cùng với CloudWatch Logs, CloudWatch Metrics và SNS Alert.

---

#### Các bước thực hiện

1. Truy cập dịch vụ **AWS Lambda**.
2. Chọn function `RoughLifeRoomApi`.
3. Vào tab **Configuration**.
4. Chọn **Monitoring and operations tools**.
5. Bật **Active tracing** cho AWS X-Ray.
6. Lưu cấu hình.
7. Gọi test Lambda hoặc gọi API Gateway để tạo request mới.
8. Kiểm tra trace trong phần monitoring nếu có request được ghi nhận.

---

#### Minh chứng bật X-Ray cho Lambda

![Lambda X-Ray Enabled](/images/5-Workshop/5.14-xray-trace/13_01_Lambda_XRay_Enabled.png)

Hình trên thể hiện AWS X-Ray đã được bật cho Lambda function `RoughLifeRoomApi`. Khi active tracing được bật, Lambda có thể gửi dữ liệu trace đến X-Ray trong quá trình xử lý request.

---

#### Vai trò của X-Ray trong hệ thống RoughLife

Trong hệ thống online multiplayer của RoughLife, X-Ray hỗ trợ nhóm quan sát backend serverless rõ ràng hơn.

X-Ray có thể giúp phân tích:

- Request từ API Gateway đi vào Lambda.
- Thời gian Lambda xử lý request.
- Lỗi phát sinh trong quá trình xử lý room API.
- Các bước đọc/ghi DynamoDB nếu được tích hợp trace phù hợp.
- Độ trễ của backend khi người chơi tạo phòng hoặc lấy danh sách phòng.

Nhờ X-Ray, nhóm có thể xác định request bị chậm ở API Gateway, Lambda hay database layer. Điều này giúp quá trình debug và tối ưu backend dễ hơn khi hệ thống được mở rộng.

---

#### Luồng tracing dự kiến

Luồng tracing của backend RoughLife được thiết kế như sau:

1. Unity Client gửi request đến API Gateway.
2. API Gateway chuyển request đến Lambda `RoughLifeRoomApi`.
3. Lambda xử lý action như tạo phòng, lấy danh sách phòng hoặc lưu dữ liệu.
4. Lambda đọc hoặc ghi dữ liệu vào DynamoDB.
5. X-Ray ghi nhận trace để nhóm quan sát quá trình xử lý request.

Ở giai đoạn minh chứng hiện tại, nhóm đã bật Active tracing cho Lambda. Khi hệ thống tiếp tục được mở rộng, X-Ray có thể được dùng kết hợp với API Gateway, Lambda và DynamoDB để quan sát luồng request đầy đủ hơn.

---

#### Kết quả

Sau bước này, Lambda `RoughLifeRoomApi` đã được bật AWS X-Ray Active tracing. Đây là bước chuẩn bị quan trọng cho lớp observability của hệ thống backend.

Khi có nhiều request từ Unity Client hoặc API Gateway, X-Ray sẽ hỗ trợ nhóm theo dõi, phân tích và tối ưu luồng xử lý của Room API. Điều này giúp hệ thống RoughLife có khả năng giám sát tốt hơn khi triển khai online multiplayer trên AWS.