---
title: "Blog 1 - GameLift FlexMatch serverless matchmaking"
date: 2026-06-21
weight: 1
chapter: false
pre: " <b> 3.1. </b> "
---
# Xây dựng matchmaking bằng Amazon GameLift FlexMatch và serverless services

Link Facebook: [AWS Study Group Facebook permalink 2191111528320474](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2191111528320474)

Link blog gốc AWS: [Online Multiplayer with Amazon GameLift and AWS serverless](https://aws.amazon.com/blogs/gametech/online-multiplayer-amazon-gamelift-aws-serverless/)

![Kiến trúc serverless matchmaking](/images/3-blogstranslated/727466501_1798896974424644_7417817182196219607_n.jpg)

## Tổng quan

Bài viết trình bày một backend matchmaking dạng serverless cho game online multiplayer. Kiến trúc sử dụng Amazon Cognito để định danh người chơi, Amazon API Gateway làm public backend API, AWS Lambda xử lý backend logic, Amazon DynamoDB lưu dữ liệu player và matchmaking, Amazon SNS nhận event, và Amazon GameLift FlexMatch để ghép trận.

Mục tiêu chính là tách gameplay realtime khỏi phần điều phối backend. Player không kết nối trực tiếp vào hạ tầng matchmaking. Thay vào đó, client đăng nhập, gọi backend API và để các dịch vụ AWS điều phối match ticket và match result.

## Luồng xử lý chính

1. Player lấy identity và credentials thông qua Amazon Cognito.
2. Game client gọi Amazon API Gateway để truy cập backend API.
3. API Gateway invoke AWS Lambda backend functions.
4. Lambda đọc và cập nhật player data trong DynamoDB.
5. Lambda tạo hoặc xử lý matchmaking ticket trong DynamoDB.
6. Amazon GameLift FlexMatch gửi matchmaking event đến Amazon SNS.
7. Lambda xử lý event và cập nhật match result cho client.

## Dịch vụ AWS chính

- **Amazon Cognito** quản lý identity và authentication của player.
- **Amazon API Gateway** cung cấp endpoint bảo mật cho game client.
- **AWS Lambda** chạy backend logic mà không cần tự quản lý server.
- **Amazon DynamoDB** lưu player data và trạng thái matchmaking ticket.
- **Amazon SNS** nhận GameLift FlexMatch events và tách rời xử lý event.
- **Amazon GameLift FlexMatch** xử lý rule-based matchmaking cho multiplayer session.

## Ý nghĩa với RoughLife

Với RoughLife, pattern này hữu ích vì matchmaking không nằm trong vòng lặp UDP gameplay. Backend có thể tạo, theo dõi và cập nhật request matchmaking, trong khi game session thực tế được xử lý bởi GameLift servers. Cách này giúp gameplay server tập trung vào mô phỏng realtime, còn account, room và matchmaking logic nằm ở lớp serverless dễ mở rộng hơn.

## Tóm tắt bản dịch

Một multiplayer backend tốt cần xác thực player, theo dõi player state, tạo matchmaking ticket, xử lý match result và trả đủ thông tin để client tham gia đúng session. Việc dùng serverless services giúp giảm công vận hành và làm lớp matchmaking dễ phát triển hơn khi game mở rộng.

