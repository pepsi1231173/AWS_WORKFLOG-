---
title: "Blog 2 - GameLift game sessions và CloudWatch logs"
date: 2026-06-30
weight: 2
chapter: false
pre: " <b> 3.2. </b> "
---
# Vận hành Amazon GameLift game session và CloudWatch logs

Link Facebook: [AWS Study Group Facebook permalink 2198027240962236](https://www.facebook.com/groups/awsstudygroupfcj/permalink/2198027240962236)

Link blog gốc AWS: [Host persistent world games on Amazon GameLift Servers](https://aws.amazon.com/blogs/gametech/host-persistent-world-games-on-amazon-gamelift-servers/)

![Active GameLift game session](/images/3-blogstranslated/731787736_1803852380595770_7260352658525805355_n.jpg)

![Hộp thoại terminate game session](/images/3-blogstranslated/733756954_1803852333929108_7167563714267557677_n.jpg)

![CloudWatch GameLift log group](/images/3-blogstranslated/731787739_1803852490595759_4367995617558889048_n.jpg)

![CloudWatch log streams](/images/3-blogstranslated/731761336_1803852443929097_2885424837124105651_n.jpg)

## Tổng quan

Bài viết tập trung vào phần vận hành Amazon GameLift. Sau khi fleet chạy, developer cần kiểm tra game session, xác nhận session có đang active hay không, terminate session an toàn trong quá trình test và dùng CloudWatch logs để debug hành vi của server.

Workflow này quan trọng trong phát triển multiplayer vì server có thể start thành công nhưng vẫn lỗi khi player connect, khi session shutdown hoặc trong lúc runtime. Dữ liệu từ GameLift console và CloudWatch logs giúp xác định nguyên nhân các lỗi đó.

## Quản lý game session

Một GameLift fleet có thể hiển thị active game sessions trong tab **Game sessions**. Tại đây developer có thể kiểm tra game session ID, status, creation time và location. Trong quá trình test, session có thể được terminate từ console.

Cách shutdown nên dùng là **Normal game session shutdown** vì nó cho game server chạy shutdown sequence và gọi GameLift server SDK action để đánh dấu process đang kết thúc. Immediate shutdown chỉ nên dùng khi server không phản hồi.

## Kiểm tra CloudWatch logs

GameLift có thể publish server logs lên Amazon CloudWatch. Developer có thể tìm log group liên quan, mở log streams và kiểm tra output từ từng server process. Việc này hữu ích khi cần xem startup logs, player join events, errors, exceptions và shutdown behavior.

## Bài học rút ra

- Luôn kiểm tra game session status trước khi debug client.
- Ưu tiên normal shutdown để server process cleanup đúng cách.
- CloudWatch log groups và log streams rất quan trọng để hiểu chuyện gì xảy ra bên trong GameLift server.
- Runtime logs nên có startup, player connection, game session activation, player disconnect và process shutdown events.

## Áp dụng cho RoughLife

Với RoughLife, các bước này nên nằm trong checklist test. Mỗi server build cần được kiểm tra bằng cách tạo game session, kết nối Unity client, xem logs và shutdown session bình thường. Cách này giảm rủi ro trước khi thêm gameplay logic phức tạp hơn.

