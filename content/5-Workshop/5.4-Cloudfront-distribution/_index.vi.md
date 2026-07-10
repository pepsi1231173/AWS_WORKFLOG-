---
title: "Tạo CloudFront Distribution"
date: 2024-01-01
weight: 4
chapter: false
pre: " <b> 5.4. </b> "
---

#### Mục tiêu

Trong bước này, nhóm tạo **Amazon CloudFront Distribution** để phân phối các file release của game RoughLife từ S3 bucket thông qua HTTPS. CloudFront giúp người chơi tải các file như `version.json`, `patch_manifest.json` và `RoughLife_Client_Window.zip` thông qua domain CloudFront thay vì truy cập trực tiếp S3.

CloudFront Distribution được cấu hình với S3 bucket làm origin. Phần origin sử dụng cơ chế **Origin Access Control** để CloudFront có quyền đọc object từ S3 bucket private. Đây là cách phù hợp hơn so với việc mở public bucket trực tiếp. :contentReference[oaicite:3]{index=3}

#### Các bước thực hiện

1. Truy cập dịch vụ **Amazon CloudFront**.
2. Chọn **Create distribution**.
3. Ở phần **Origin domain**, chọn S3 release bucket đã tạo ở bước trước.
4. Cấu hình origin access bằng **Origin Access Control**.
5. Ở phần default behavior:
   - Chọn `GET, HEAD`.
   - Bật redirect HTTP sang HTTPS.
   - Sử dụng cache policy mặc định phù hợp cho static content.
6. Thiết lập **Default root object** là `version.json`.
7. Tạo distribution và chờ trạng thái chuyển sang **Deployed**.
8. Kiểm tra các URL CloudFront:
   - `/version.json`
   - `/patch_manifest.json`
   - `/builds/windows/RoughLife_Client_Window.zip`

#### Minh chứng CloudFront Distribution

![CloudFront distribution](/images/5-Workshop/5.4-Cloudfront-distribution/03_CloudFront_Distribution.png)

Hình trên thể hiện CloudFront Distribution đã được tạo thành công với gói Free plan. Distribution cung cấp domain để client hoặc người chơi truy cập file release qua HTTPS.

![CloudFront origin](/images/5-Workshop/5.4-Cloudfront-distribution/03_CloudFront_Origin.png)

Hình trên thể hiện CloudFront origin đang trỏ đến S3 release bucket của RoughLife. Origin type là S3 và được cấu hình origin access.

![CloudFront check URL](/images/5-Workshop/5.4-Cloudfront-distribution/03_CheckURL.png)

Hình trên thể hiện việc kiểm tra các file qua CloudFront domain. `version.json` và `patch_manifest.json` có thể mở trực tiếp trên trình duyệt, đồng thời file `RoughLife_Client_Window.zip` có thể tải xuống thành công.

#### Kết quả

Sau bước này, hệ thống đã có một endpoint HTTPS thông qua CloudFront để phân phối client build và các file metadata. Đây là phần minh chứng cho khả năng phát hành bản game client/patch thông qua AWS.

