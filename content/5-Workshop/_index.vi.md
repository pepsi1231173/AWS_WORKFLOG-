---
title: "Workshop"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5. </b> "
---

# Thiết lập minh chứng AWS cho hệ thống game online RoughLife

#### Tổng quan

Trong workshop này, nhóm RoughLife tiến hành thiết lập một số dịch vụ AWS để minh chứng cho kiến trúc hệ thống game online multiplayer. Mục tiêu của phần này là chứng minh cách hệ thống có thể phân phối bản build client, bảo vệ traffic HTTP/HTTPS, quản lý tài khoản người chơi và lưu trữ dữ liệu phòng chơi, dữ liệu người chơi cũng như kết quả trận đấu.

Các dịch vụ AWS được sử dụng trong phần minh chứng gồm:

- **AWS Budgets** để theo dõi chi phí và cảnh báo khi vượt ngưỡng.
- **Amazon S3** để lưu trữ client build, file version và patch manifest.
- **Amazon CloudFront** để phân phối client build và patch thông qua HTTPS.
- **AWS WAF** để bảo vệ CloudFront trước các request web không hợp lệ.
- **Amazon Cognito** để chuẩn bị hệ thống xác thực người chơi.
- **Amazon DynamoDB** để lưu dữ liệu room/session, player save và match result.

#### Nội dung

1. [Tổng quan Workshop](5.1-workshop-overview/)
2. [AWS Budget](5.2-budget/)
3. [S3 Release Bucket](5.3-s3-release-bucket/)
4. [Cloudfront Distribution](5.4-cloudfront-distribution/)
5. [Waf-Webacl](5.5-waf-webacl/)
6. [Cognito userpool](5.6-cognito-userpool/)
7. [Tạo DynamoDB Tables](5.7-dynamodb-tables/)
8. [Tạo Lambda Room API](5.8-lambda-room-api/)
9. [Tạo API Gateway HTTP API](5.9-api-gateway/)
10. [Thiết lập Amazon GameLift Build và Fleet](5.10-gamelift-build-fleet/)
11. [Thiết lập GameLift Alias và Game Session Queue](5.11-gamelift-queue-alias/)
12. [Cấu hình CloudWatch Logs và Alarm](5.12-cloudWatch-logs,monitor,alarm/)
13. [Thiết lập SNS Admin Alert](5.13-sns-admin-alert/)
14. [Thiết lập AWS X-Ray Trace](5.14-xray-trace/)
15. [Cleanup AWS Resources](5.15-cleanup/)