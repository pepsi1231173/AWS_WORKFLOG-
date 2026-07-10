---
title: "Tạo S3 Release Bucket"
date: 2024-01-01
weight: 3
chapter: false
pre: " <b> 5.3. </b> "
---

#### Mục tiêu

Trong bước này, nhóm sử dụng **Amazon S3** để lưu trữ các file phát hành của game RoughLife, bao gồm client build, file phiên bản và file manifest. Đây là nền tảng để người chơi có thể tải bản game hoặc để client kiểm tra phiên bản mới trong tương lai.

Các file được upload gồm:

- `RoughLife_Client_Window.zip`: bản build client Windows của game.
- `version.json`: file mô tả phiên bản mới nhất của game.
- `patch_manifest.json`: file mô tả danh sách file cần tải hoặc cập nhật.

Amazon S3 được dùng làm nơi lưu trữ object. Ở bước tiếp theo, Amazon CloudFront sẽ sử dụng bucket này làm origin để phân phối các file release thông qua HTTPS.

---

#### Các bước thực hiện

1. Truy cập dịch vụ **Amazon S3**.
2. Tạo bucket mới với tên `roughlife-release-bucket-letran-20260709`.
3. Giữ bucket ở chế độ private, không public trực tiếp.
4. Chuẩn bị thư mục release trên máy local.
5. Upload các file `version.json`, `patch_manifest.json` và `RoughLife_Client_Window.zip` lên S3.
6. Kiểm tra lại danh sách object trong bucket sau khi upload.

---

#### Cấu trúc thư mục release

Cấu trúc thư mục release được chuẩn bị như sau:

- `RoughLifeRelease/`
  - `version.json`
  - `patch_manifest.json`
  - `builds/`
    - `windows/`
      - `RoughLife_Client_Window.zip`

Trong đó:

- `version.json` dùng để mô tả version mới nhất của game.
- `patch_manifest.json` dùng để mô tả danh sách file cần tải hoặc cập nhật.
- `RoughLife_Client_Window.zip` là bản build client Windows để người chơi tải về.

---

#### Minh chứng S3 Release Bucket

![S3 release bucket](/images/5-Workshop/5.3-S3-release-bucket/02_S3_Release_Bucket.png)

Hình trên thể hiện S3 bucket được tạo để lưu trữ các file phát hành của game RoughLife.

---

#### Minh chứng upload các file release

![S3 upload objects](/images/5-Workshop/5.3-S3-release-bucket/02_Upload.png)

Hình trên thể hiện quá trình upload các file `version.json`, `patch_manifest.json` và client build `.zip` lên S3 bucket.

---

#### Minh chứng client build trên máy local

![S3 client zip](/images/5-Workshop/5.3-S3-release-bucket/02_S3_Client_Zip.png)

Hình trên thể hiện file `RoughLife_Client_Window.zip` đã được chuẩn bị trong thư mục `builds/windows`. Đây là bản client build được sử dụng để phân phối cho người chơi.

---

#### Vai trò của S3 trong hệ thống RoughLife

Trong kiến trúc online của RoughLife, Amazon S3 đảm nhận vai trò lưu trữ các file static phục vụ cho quá trình phát hành game.

S3 được sử dụng để lưu:

- File game client build.
- File kiểm tra version.
- File manifest phục vụ update hoặc patch.
- Các file release khác trong tương lai.

Việc tách phần client build ra khỏi game server giúp hệ thống dễ quản lý hơn. Game server chỉ tập trung xử lý gameplay realtime, còn S3 và CloudFront đảm nhận nhiệm vụ phân phối file cho người chơi.

---

#### Kết quả

Sau bước này, S3 bucket đã chứa đầy đủ các file cần thiết cho quá trình phát hành client build của RoughLife.

Các file release đã được chuẩn bị thành công gồm:

- `version.json`
- `patch_manifest.json`
- `builds/windows/RoughLife_Client_Window.zip`

Bucket này sẽ được sử dụng làm origin cho CloudFront Distribution ở bước tiếp theo để người chơi có thể tải game thông qua HTTPS.