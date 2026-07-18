---
title: "Các bài blogs đã dịch"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 3. </b> "
---

Phần này liệt kê 3 bài viết AWS Study Group được chọn để dịch trong báo cáo thực tập. Ba bài tập trung vào Amazon GameLift, FlexMatch, vận hành game session và kiến trúc server-side cho game online multiplayer.

### [Blog 1 - Xây dựng matchmaking bằng Amazon GameLift FlexMatch và serverless services](3.1-Blog1/)
Bài này giải thích cách một game multiplayer có thể kết hợp Amazon Cognito, Amazon API Gateway, AWS Lambda, Amazon DynamoDB, Amazon SNS và Amazon GameLift FlexMatch để tạo backend matchmaking dạng serverless. Link Facebook: [Facebook permalink 2191111528320474](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2191111528320474). Link blog gốc AWS: [Online Multiplayer with Amazon GameLift and AWS serverless](https://aws.amazon.com/blogs/gametech/online-multiplayer-amazon-gamelift-aws-serverless/).

### [Blog 2 - Vận hành Amazon GameLift game session và CloudWatch logs](3.2-Blog2/)
Bài này tóm tắt quy trình vận hành khi kiểm tra active GameLift game session, terminate session đúng cách và xem CloudWatch log groups/log streams. Link Facebook: [Facebook permalink 2198027240962236](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2198027240962236). Link blog gốc AWS: [Host persistent world games on Amazon GameLift Servers](https://aws.amazon.com/blogs/gametech/host-persistent-world-games-on-amazon-gamelift-servers/).

### [Blog 3 - Thiết kế GameLift server fleet với sidecar và lưu trữ game state](3.3-Blog3/)
Bài này giới thiệu kiến trúc GameLift Servers fleet, trong đó game server process chạy cùng sidecar component và kết nối Amazon S3, DynamoDB để xử lý game world data. Link Facebook: [Facebook permalink 2196945564403737](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2196945564403737). Link blog gốc AWS: [Faster multiplayer hosting with containers on Amazon GameLift Servers](https://aws.amazon.com/blogs/gametech/faster-multiplayer-hosting-with-containers-on-amazon-gamelift-servers/).

