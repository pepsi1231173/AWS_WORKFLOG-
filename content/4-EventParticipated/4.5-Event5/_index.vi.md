---
title: "Final Presentation - RoughLife Online Multiplayer Platform"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 4.5. </b> "
---

# Final Presentation - RoughLife Online Multiplayer Platform

## Thông tin sự kiện

**Tên sự kiện:** Final Presentation - RoughLife Online Multiplayer Platform  
**Thời gian:** 25/07/2026  
**Địa điểm:** Tầng 26, Bitexco Tower, 02 Hai Triều, Phường Sài Gòn, TP. Hồ Chí Minh  
**Vai trò:** Người thuyết trình  

## Tổng quan

Đây là buổi thuyết trình cuối kỳ cho dự án thực tập của em. Trong buổi này, em trình bày dự án RoughLife Online Multiplayer Platform, một game hành động phiêu lưu 2D góc nhìn từ trên xuống được phát triển bằng Unity và định hướng kết hợp các dịch vụ AWS để hỗ trợ online multiplayer, đăng nhập người chơi, quản lý phòng, game session, logging, monitoring và triển khai bản phát hành.

Nội dung thuyết trình tổng kết các phần em đã hoàn thành trong quá trình thực tập: các bài lab AWS, tài liệu workshop, thiết kế UI game, vẽ map, setup collider, luồng lobby, luồng online room và kiến trúc cloud dự kiến cho hệ thống multiplayer.

## Mục tiêu thuyết trình

- Giới thiệu ý tưởng game RoughLife và định hướng gameplay chính.
- Giải thích kiến trúc hệ thống và lý do lựa chọn các dịch vụ AWS.
- Trình bày luồng người chơi từ menu, lobby, tạo phòng, tham gia phòng đến gameplay.
- Tổng kết tiến độ triển khai đã hoàn thành trong quá trình thực tập.
- Chia sẻ demo, hình ảnh minh chứng và tài liệu thuyết trình hỗ trợ.

## Nội dung chính

### Bối cảnh dự án

RoughLife là một dự án game hành động phiêu lưu 2D góc nhìn từ trên xuống. Người chơi điều khiển nhân vật di chuyển trên map, sử dụng vũ khí, chiến đấu với quái và vào các phòng boss. Game được định hướng hỗ trợ cả chế độ offline và online co-op multiplayer.

### Tính năng game

- Menu chính gồm Online, Offline, Setting và Exit.
- Lobby scene với Join Room panel, nhập room code, Start Game và luồng vào phòng.
- Map 2D top-down có khu vực di chuyển, vật cản và collider boundaries.
- Player UI gồm thanh máu, avatar, weapon slot và weapon information panel.
- Luồng boss battle gồm chọn vũ khí, tấn công, giảm máu boss, nhận thưởng và chuyển cảnh.

### Kiến trúc AWS

Kiến trúc đề xuất sử dụng các dịch vụ AWS để hỗ trợ hệ thống multiplayer an toàn và có khả năng mở rộng. Amazon Cognito dùng cho định danh người chơi, DynamoDB lưu trạng thái phòng và người chơi, Lambda và API Gateway cung cấp room APIs, Amazon GameLift quản lý dedicated game hosting, CloudWatch hỗ trợ logs và monitoring, SNS gửi cảnh báo vận hành, còn S3/CloudFront hỗ trợ phân phối bản phát hành.

### Demo và minh chứng

Nội dung demo thể hiện luồng hoạt động chính của dự án, các hình ảnh giao diện RoughLife, sơ đồ kiến trúc và tiến độ đã hoàn thành trong quá trình thực tập. Các hình ảnh bên dưới ghi lại không khí buổi thuyết trình, slide, phần trao đổi và hoạt động chia sẻ dự án.

## Bài học rút ra

- Một dự án game multiplayer cần kết hợp cả thiết kế gameplay và kế hoạch backend architecture.
- Unity xử lý trải nghiệm phía người chơi, còn cloud services hỗ trợ authentication, matchmaking, room state, hosting, logging và monitoring.
- AWS có thể được kết hợp thành một kiến trúc thực tế cho dự án game sinh viên nếu chia phạm vi thành từng module nhỏ.
- Việc chuẩn bị final presentation giúp em kết nối phần kỹ thuật, tài liệu, hình ảnh minh chứng và demo flow thành một báo cáo hoàn chỉnh.

## Cảm nhận cá nhân

Buổi final presentation giúp em nhìn lại toàn bộ quá trình thực tập, từ những bài lab AWS đầu tiên đến phần tài liệu và kiến trúc dự án RoughLife cuối kỳ. Đây cũng là cơ hội để em trình bày dự án rõ ràng hơn, liên kết các tính năng game với dịch vụ AWS và nhận phản hồi về cả kiến trúc kỹ thuật lẫn cách trình bày.

Sau buổi này, em tự tin hơn trong việc thuyết trình sản phẩm kỹ thuật, tổ chức minh chứng dự án và giải thích lý do sử dụng từng dịch vụ. Đây cũng là checkpoint quan trọng để em xác định các phần cần cải thiện tiếp theo như hoàn thiện gameplay demo, làm rõ online flow và tiếp tục tinh chỉnh kế hoạch cloud deployment.

## Hình ảnh sự kiện

![Event 5 photo 1](/images/4-EventParticipated/event5/1785144603868_488790801746558625_6340294277924690580_89fb47985467637239c802489514c9e9.jpg)

![Event 5 photo 2](/images/4-EventParticipated/event5/1785144603992_488790801746558625_6340294277924690580_acefbb7219299dfab6c1d37a4dcbb3d9.jpg)

![Event 5 photo 3](/images/4-EventParticipated/event5/1785144604158_488790801746558625_6340294277924690580_29401398d9188a3e5c040f06d24cf8d8.jpg)

![Event 5 photo 4](/images/4-EventParticipated/event5/1785144604322_488790801746558625_6340294277924690580_2ecc0d5d24a86f8e7e8b96af1f4da0fc.jpg)

![Event 5 photo 5](/images/4-EventParticipated/event5/1785144604508_488790801746558625_6340294277924690580_d2ffee7e9f87169a8905e8ff72c3a73f.jpg)

![Event 5 photo 6](/images/4-EventParticipated/event5/1785144604684_488790801746558625_6340294277924690580_1fb84e1af5f8245f3b86acb0f5a0fed7.jpg)

![Event 5 photo 7](/images/4-EventParticipated/event5/1785144604829_488790801746558625_6340294277924690580_558d228c1f57820e501a0f06b1bd5ae3.jpg)

![Event 5 photo 8](/images/4-EventParticipated/event5/1785144605019_488790801746558625_6340294277924690580_30cce8f4fe2120bee49b9cc68b69692e.jpg)

![Event 5 photo 9](/images/4-EventParticipated/event5/1785144605119_488790801746558625_6340294277924690580_c2d45af333e65f9d64f2564ea01292f6.jpg)

![Event 5 photo 10](/images/4-EventParticipated/event5/1785144605212_488790801746558625_6340294277924690580_470fa844422b8460b53b6baca546a0d2.jpg)

![Event 5 photo 11](/images/4-EventParticipated/event5/1785144605291_488790801746558625_6340294277924690580_1159b68a853265bb9c75776f66243b73.jpg)

![Event 5 photo 12](/images/4-EventParticipated/event5/1785144605374_488790801746558625_6340294277924690580_9eeb1e18eb64289dad20fa89bcaa9567.jpg)

![Event 5 photo 13](/images/4-EventParticipated/event5/1785144605454_488790801746558625_6340294277924690580_2fc1abc1f2f0b8dc2fa5dd8d7e2e2e39.jpg)

![Event 5 photo 14](/images/4-EventParticipated/event5/1785144605554_488790801746558625_6340294277924690580_60aaa8f835c575e0db494562a4687ae1.jpg)

![Event 5 photo 15](/images/4-EventParticipated/event5/1785144605643_488790801746558625_6340294277924690580_41f78bf85aeed61d900ac0146a3f3faa.jpg)

![Event 5 photo 16](/images/4-EventParticipated/event5/1785144605747_488790801746558625_6340294277924690580_45817c52315dbc35ceea28de0a82deca.jpg)

![Event 5 photo 17](/images/4-EventParticipated/event5/1785144605835_488790801746558625_6340294277924690580_27b19c0d5c0fc6d3cab8235f81917c5f.jpg)

![Event 5 photo 18](/images/4-EventParticipated/event5/1785144605905_488790801746558625_6340294277924690580_ac8b3d92d386d2efd19a3d49f776ba84.jpg)

![Event 5 photo 19](/images/4-EventParticipated/event5/1785144606000_488790801746558625_6340294277924690580_a8792a78c67f02014976fe553fe58a15.jpg)

![Event 5 photo 20](/images/4-EventParticipated/event5/1785144645214_488790801746558625_6340294277924690580_75bbf5ee60acdef6db4e15520d7b60a6.jpg)
