---
title: "Tạo Cognito User Pool"
date: 2024-01-01
weight: 6
chapter: false
pre: " <b> 5.6. </b> "
---

#### Mục tiêu

Trong bước này, nhóm tạo **Amazon Cognito User Pool** để chuẩn bị hệ thống xác thực người chơi cho RoughLife. Cognito User Pool đóng vai trò như một user directory dùng cho authentication và authorization trong ứng dụng web hoặc mobile. Nó cũng có thể hoạt động như một OpenID Connect identity provider cho ứng dụng. :contentReference[oaicite:6]{index=6}

Đối với hệ thống game RoughLife, Cognito có thể được sử dụng để:

- Đăng ký và đăng nhập người chơi.
- Cấp JWT token cho client.
- Cho phép API Gateway kiểm tra danh tính người chơi trước khi gọi Room API.
- Liên kết player identity với dữ liệu lưu trong DynamoDB.

#### Các bước thực hiện

1. Truy cập dịch vụ **Amazon Cognito**.
2. Chọn **User pools**.
3. Tạo user pool mới.
4. Cấu hình phương thức đăng nhập bằng email hoặc username.
5. Tạo app client cho Unity Client.
6. Tắt client secret nếu client chạy trực tiếp trên thiết bị người chơi.
7. Kiểm tra thông tin User Pool ID và App Client ID.

#### Minh chứng Cognito User Pool

![Cognito user pool](/images/5-Workshop/5.6-Cognito-userpool/05_Cognito_UserPool.png)

Hình trên thể hiện Cognito User Pool đã được tạo thành công ở region Asia Pacific Singapore. User Pool này là nền tảng để triển khai login/JWT cho người chơi trong các bước phát triển tiếp theo.

#### Kết quả

Sau bước này, hệ thống đã có Cognito User Pool để chuẩn bị cho chức năng xác thực người chơi. Khi tích hợp vào game, Unity Client sẽ đăng nhập qua Cognito, nhận JWT và dùng token này để gọi các API như tạo phòng, tham gia phòng hoặc lưu dữ liệu người chơi.