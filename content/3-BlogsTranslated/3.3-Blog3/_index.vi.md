---
title: "Blog 3 - GameLift server fleet với sidecar và state storage"
date: 2026-06-30
weight: 3
chapter: false
pre: " <b> 3.3. </b> "
---
# Thiết kế GameLift server fleet với sidecar và lưu trữ game state

Link Facebook: [AWS Study Group Facebook permalink 2196945564403737](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2196945564403737)

Link blog gốc AWS: [Faster multiplayer hosting with containers on Amazon GameLift Servers](https://aws.amazon.com/blogs/gametech/faster-multiplayer-hosting-with-containers-on-amazon-gamelift-servers/)

![Kiến trúc GameLift fleet với sidecar](/images/3-blogstranslated/731883848_1804734080507600_5742217141909987603_n.jpg)

## Tổng quan

Bài viết giới thiệu kiến trúc Amazon GameLift Servers fleet, trong đó player kết nối đến game sessions chạy trên EC2 instances do GameLift quản lý. Mỗi game session có game server process và sidecar process. Sidecar có thể xử lý các tác vụ hỗ trợ như lưu world save, ghi game world data hoặc giao tiếp với các dịch vụ AWS bên ngoài.

## Giải thích kiến trúc

Fleet chứa các EC2 instances được quản lý bởi Amazon GameLift Servers. Mỗi instance có thể chạy một hoặc nhiều game sessions. Bên trong mỗi game session, game server xử lý player connection và realtime gameplay, còn sidecar process xử lý workload hỗ trợ nằm ngoài gameplay loop chính.

Kiến trúc cũng kết nối đến Amazon S3 và Amazon DynamoDB. S3 phù hợp để lưu các object lớn như game world save, replay file hoặc artifact do server tạo ra. DynamoDB phù hợp để lưu game world data có cấu trúc, player progress, session metadata hoặc state nhẹ cần truy vấn nhanh.

## Vì sao dùng sidecar

Sidecar process giúp game server tập trung vào simulation và networking. Thay vì đặt mọi trách nhiệm vào main server binary, logic hỗ trợ có thể được tách sang process đi kèm. Cách này giúp hệ thống dễ test, deploy và cập nhật hơn.

## Ý chính

- GameLift quản lý fleet và lifecycle của game session.
- EC2 capacity được ẩn phía sau GameLift fleet.
- Một game session có thể gồm game server và sidecar process.
- S3 phù hợp cho file lớn như world save hoặc artifact.
- DynamoDB phù hợp cho structured state và metadata cần truy cập nhanh.

## Áp dụng cho RoughLife

Với RoughLife, pattern này hữu ích vì game sinh tồn thường cần persistent world state, match result records và player progression. Game server có thể tập trung vào authoritative gameplay, trong khi sidecar hoặc backend integration xử lý save và storage. Cách này tạo ranh giới rõ giữa realtime gameplay và long-term persistence.

