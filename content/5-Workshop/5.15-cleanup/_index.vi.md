---
title: "Cleanup AWS Resources"
date: 2024-01-01
weight: 15
chapter: false
pre: " <b> 5.15. </b> "
---

#### Mục tiêu

Sau khi hoàn tất quá trình setup minh chứng AWS cho hệ thống game online RoughLife, nhóm thực hiện bước **Cleanup** để xóa hoặc tắt các tài nguyên không còn sử dụng. Mục tiêu của bước này là tránh phát sinh chi phí duy trì sau khi hoàn thành báo cáo.

Các tài nguyên đã tạo trong workshop gồm S3, CloudFront, WAF, Cognito, DynamoDB, Lambda, API Gateway, SNS, CloudWatch Alarm, X-Ray và GameLift. Một số dịch vụ có thể phát sinh chi phí nếu tiếp tục để hoạt động hoặc có request phát sinh, vì vậy cần cleanup cẩn thận.

---

#### Nguyên tắc cleanup

Khi cleanup AWS resources, nhóm thực hiện theo nguyên tắc:

- Xóa tài nguyên theo đúng thứ tự phụ thuộc.
- Xóa hoặc disable các dịch vụ có thể phát sinh phí.
- Empty bucket trước khi xóa S3 bucket.
- Disable CloudFront trước khi xóa Distribution.
- Xóa API Gateway trước khi xóa Lambda nếu API không còn dùng.
- Xóa CloudWatch Alarm và SNS Topic nếu không còn cần cảnh báo.
- Xóa DynamoDB tables nếu không cần giữ dữ liệu test.
- Kiểm tra lại Billing Dashboard sau khi cleanup.

---

#### Thứ tự cleanup đề xuất

#### 1. Cleanup GameLift

Đầu tiên, kiểm tra Amazon GameLift Servers.

Các tài nguyên cần xử lý:

- Managed EC2 Fleet nếu đã tạo thành công.
- Anywhere Fleet nếu đã tạo thành công.
- GameLift Build.
- Fleet Alias.
- Game Session Queue.
- Custom Location nếu không còn dùng.

Trong trường hợp của nhóm, fleet chưa được tạo thành công do quota limit. Tuy nhiên, server build `RoughLifeServer` đã được upload lên GameLift, vì vậy cần xóa build nếu không còn dùng để tránh giữ tài nguyên không cần thiết.

---

#### 2. Cleanup CloudWatch Alarm và SNS

Truy cập **CloudWatch** và xóa các Alarm đã tạo cho backend.

Sau đó truy cập **Amazon SNS** và xóa:

- Email subscription.
- SNS Topic dùng cho admin alert.

Việc này giúp hệ thống ngừng gửi cảnh báo và tránh duy trì các thành phần alert không còn sử dụng.

---

#### 3. Disable X-Ray Active Tracing

Truy cập Lambda `RoughLifeRoomApi`, vào phần **Monitoring and operations tools** và tắt **Active tracing** nếu không còn cần theo dõi trace.

Nếu Lambda bị xóa ở bước sau thì việc tắt X-Ray không bắt buộc, nhưng vẫn nên thực hiện nếu muốn giữ Lambda mà không dùng tracing.

---

#### 4. Cleanup API Gateway

Truy cập **Amazon API Gateway** và xóa HTTP API `RoughLifeRoomHttpApi`.

Tài nguyên cần xóa:

- Route `/room`.
- Stage `$default`.
- API `RoughLifeRoomHttpApi`.

Nếu API Gateway còn tồn tại, client vẫn có endpoint để gọi vào backend. Vì vậy, khi không còn cần demo, nên xóa API để ngừng public backend endpoint.

---

#### 5. Cleanup Lambda

Truy cập **AWS Lambda** và xóa function `RoughLifeRoomApi`.

Trước khi xóa, kiểm tra:

- Function URL nếu có.
- Trigger từ API Gateway.
- Environment variables.
- IAM role liên quan.

Sau khi xóa Lambda, có thể xóa thêm IAM Role và policy riêng đã tạo cho Lambda nếu không còn dùng.

Các tài nguyên IAM cần kiểm tra:

- Role của `RoughLifeRoomApi`.
- Inline policy hoặc customer managed policy cho DynamoDB.
- AWSLambdaBasicExecutionRole nếu chỉ dùng riêng cho Lambda này.

---

#### 6. Cleanup DynamoDB

Truy cập **Amazon DynamoDB** và xóa các bảng test nếu không còn cần dữ liệu.

Các bảng cần xóa:

- `RoughLifeRooms`
- `RoughLifePlayerSave`
- `RoughLifeMatchResult`

Trước khi xóa, nhóm có thể export dữ liệu test nếu cần giữ minh chứng. Nếu không cần, có thể xóa trực tiếp để tránh phát sinh chi phí lưu trữ hoặc request.

---

#### 7. Cleanup Cognito

Truy cập **Amazon Cognito** và xóa User Pool đã tạo cho RoughLife.

Cần kiểm tra:

- User Pool.
- App Client.
- Hosted UI domain nếu có.
- User test nếu đã tạo.

Sau khi xóa User Pool, các App Client và cấu hình authentication liên quan cũng không còn được sử dụng.

---

#### 8. Cleanup AWS WAF

Truy cập **AWS WAF & Shield** và xóa Web ACL hoặc Protection Pack đã gắn với CloudFront.

Trước khi xóa Web ACL, cần gỡ association khỏi CloudFront Distribution nếu AWS yêu cầu. Sau đó xóa Web ACL để tránh duy trì rule bảo vệ không còn cần thiết.

---

#### 9. Cleanup CloudFront

Truy cập **Amazon CloudFront**.

Thực hiện:

1. Chọn Distribution đã tạo cho RoughLife.
2. Disable Distribution.
3. Đợi trạng thái disable hoàn tất.
4. Xóa Distribution.
5. Xóa Origin Access Control nếu không còn dùng.

CloudFront thường cần disable trước rồi mới có thể delete. Sau khi xóa CloudFront, domain phân phối file release sẽ không còn truy cập được.

---

#### 10. Cleanup S3 Release Bucket

Truy cập **Amazon S3** và xử lý bucket `roughlife-release-bucket-letran-20260709`.

Thực hiện:

1. Mở bucket.
2. Xóa toàn bộ object trong bucket.
3. Xóa các version của object nếu bucket bật versioning.
4. Xóa bucket sau khi bucket đã empty.

Các file cần xóa gồm:

- `version.json`
- `patch_manifest.json`
- `builds/windows/RoughLife_Client_Window.zip`

---

#### 11. Kiểm tra Billing và Budget

Sau khi cleanup, truy cập **Billing and Cost Management** để kiểm tra chi phí.

Cần kiểm tra:

- Current month cost.
- Free Tier usage nếu có.
- Cost Explorer.
- Budget alert.

Budget có thể giữ lại để tiếp tục cảnh báo chi phí cho tài khoản AWS. Nếu không còn cần theo dõi, nhóm có thể xóa Budget sau cùng.

---

#### Checklist cleanup

Nhóm sử dụng checklist sau để đảm bảo không còn tài nguyên không cần thiết:

- Đã xóa hoặc kiểm tra GameLift Build/Fleet/Queue/Alias.
- Đã xóa CloudWatch Alarm.
- Đã xóa SNS Topic và Email Subscription.
- Đã tắt X-Ray Active tracing hoặc xóa Lambda.
- Đã xóa API Gateway HTTP API.
- Đã xóa Lambda `RoughLifeRoomApi`.
- Đã xóa IAM Role/Policy không còn sử dụng.
- Đã xóa DynamoDB tables.
- Đã xóa Cognito User Pool.
- Đã xóa AWS WAF Web ACL.
- Đã disable và xóa CloudFront Distribution.
- Đã empty và xóa S3 Release Bucket.
- Đã kiểm tra Billing Dashboard sau cleanup.

---

#### Kết quả

Sau bước Cleanup, các tài nguyên AWS dùng cho minh chứng đã được xóa hoặc tắt để tránh phát sinh chi phí duy trì. Bước này giúp nhóm quản lý tài khoản AWS an toàn hơn sau khi hoàn thành báo cáo setup server game online.

Việc cleanup cũng thể hiện quy trình vận hành có trách nhiệm khi sử dụng cloud: tạo tài nguyên để demo, thu thập minh chứng, sau đó xóa tài nguyên không còn dùng để tối ưu chi phí.