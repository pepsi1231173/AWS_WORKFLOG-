---
title: "Thiết lập AWS WAF Web ACL"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 5.5. </b> "
---

#### Mục tiêu

Trong bước này, nhóm thiết lập **AWS WAF Web ACL** để bảo vệ CloudFront Distribution. AWS WAF được dùng để kiểm soát các request HTTP/HTTPS đến tài nguyên được bảo vệ như CloudFront, API Gateway hoặc Cognito. Web ACL giúp lọc các request không hợp lệ trước khi chúng đi đến ứng dụng hoặc origin. :contentReference[oaicite:4]{index=4}

Trong phạm vi minh chứng của RoughLife, WAF được gắn với CloudFront Distribution đang phân phối client build, `version.json` và `patch_manifest.json`.

#### Các bước thực hiện

1. Truy cập **AWS WAF & Shield**.
2. Chọn **Protection packs (web ACLs)**.
3. Tạo Web ACL mới cho CloudFront.
4. Chọn resource cần bảo vệ là CloudFront Distribution đã tạo ở bước trước.
5. Bật các core protections hoặc AWS Managed Rules.
6. Kiểm tra lại trạng thái bảo vệ trong tab **Security** của CloudFront.
7. Mở lại URL CloudFront để đảm bảo các request hợp lệ vẫn hoạt động bình thường.

AWS WAF có thể được dùng trực tiếp với CloudFront Distribution để kiểm tra và xử lý request đi qua CloudFront. :contentReference[oaicite:5]{index=5}

#### Minh chứng AWS WAF

![WAF CloudFront security](/images/5-Workshop/5.5-Waf-Webacl/04_WAF_CloudFront_Security.png)

Hình trên thể hiện phần Security của CloudFront Distribution. Core protections đã được bật để bảo vệ CloudFront trước các web request bất thường.

![WAF Web ACL](/images/5-Workshop/5.5-Waf-Webacl/04_WAF_WebACL.png)

Hình trên thể hiện Web ACL đã được tạo trong AWS WAF. Web ACL này được liên kết với CloudFront Distribution và có các rule bảo vệ cơ bản.

#### Kết quả

Sau bước này, CloudFront Distribution đã được gắn lớp bảo vệ AWS WAF. Điều này giúp hệ thống có thêm tầng bảo mật cho luồng HTTP/HTTPS dùng để tải client build và các file update. Lưu ý rằng WAF chỉ bảo vệ HTTP/HTTPS traffic, không bảo vệ trực tiếp UDP gameplay của game server.