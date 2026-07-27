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
**Địa điểm:** Tầng 36, Bitexco Tower, 02 Hai Triều, Phường Sài Gòn, TP. Hồ Chí Minh  
**Vai trò:** Người thuyết trình  

## Tổng quan

Đây là buổi thuyết trình cuối kỳ cho dự án thực tập RoughLife Online Multiplayer Platform. Buổi thuyết trình giúp em tổng kết ý tưởng dự án, giải thích các tính năng chính của game, trình bày tiến độ phát triển và liên kết phần triển khai Unity với các dịch vụ AWS trong kiến trúc đề xuất.

Nội dung buổi trình bày tập trung vào quá trình dự án được hình thành trong kỳ thực tập: từ việc học nền tảng AWS và hoàn thành các bài lab, đến thiết kế gameplay cho RoughLife, xây dựng các màn hình UI, chuẩn bị map 2D top-down, setup collider, thiết kế lobby và room flow, sau đó lập kế hoạch backend architecture cho chế độ online multiplayer.

## Mục tiêu thuyết trình

- Giới thiệu ý tưởng game RoughLife và định hướng gameplay chính.
- Trình bày gameplay flow, player UI, map setup, lobby UI và online room flow.
- Giải thích cách Unity NGO và UTP có thể hỗ trợ multiplayer gameplay.
- Giải thích lý do sử dụng AWS cho authentication, room APIs, hosting, monitoring và deployment.
- Tổng kết tiến độ thực tập, kết quả dự án và các phần cần cải thiện tiếp theo.

## Nội dung chính

### Giới thiệu dự án

Em giới thiệu RoughLife là một game hành động phiêu lưu 2D góc nhìn từ trên xuống. Dự án tập trung vào player movement, sử dụng vũ khí, chiến đấu với quái, vào boss room, chuyển scene và định hướng hỗ trợ online co-op multiplayer trong tương lai.

### Game UI và gameplay demo

Em trình bày các màn hình và luồng chính của game: main menu, lựa chọn Online/Offline, lobby screen, room entry panel, player health UI, avatar display, weapon slot, weapon information panel, map 2D, collider setup và tương tác trong boss battle.

### Multiplayer và kiến trúc AWS

Phần kiến trúc giải thích cách Unity Netcode for GameObjects và Unity Transport có thể kết hợp với các dịch vụ AWS. Amazon Cognito hỗ trợ xác thực người chơi, DynamoDB lưu room/player state, Lambda và API Gateway cung cấp room management APIs, Amazon GameLift hỗ trợ dedicated game hosting, S3 và CloudFront hỗ trợ phát hành bản build, còn CloudWatch/SNS hỗ trợ monitoring và alerting.

### Tiến độ thực tập và minh chứng

Buổi trình bày cũng tổng kết worklog thực tập, các bài lab AWS, tài liệu workshop, event participation, website báo cáo và minh chứng dự án. Phần này giúp thể hiện quá trình xây dựng dự án theo từng bước, không chỉ dừng lại ở kết quả cuối cùng.

## Bài học rút ra

- Một dự án game multiplayer cần kết hợp cả gameplay design và backend architecture planning.
- Unity đảm nhiệm trải nghiệm phía người chơi, còn AWS hỗ trợ identity, data, APIs, hosting, monitoring và deployment.
- Một kiến trúc cloud phức tạp sẽ dễ trình bày hơn khi được chia thành các module nhỏ như authentication, room management, hosting và operations.
- Final presentation không chỉ là phần demo mà còn là cách chứng minh tiến độ thông qua tài liệu, hình ảnh, sơ đồ kiến trúc và phần tự đánh giá.
- Phản hồi từ buổi thuyết trình giúp em nhìn rõ hơn các phần cần cải thiện tiếp theo của dự án.

## Cảm nhận cá nhân

Buổi final presentation có ý nghĩa vì nó tổng hợp lại toàn bộ những phần em đã thực hiện trong kỳ thực tập. Thay vì chỉ liệt kê các công việc đã hoàn thành, em cần giải thích lý do chọn đề tài, cách game vận hành, vì sao sử dụng từng dịch vụ AWS và cách các phần trong hệ thống kết nối với nhau.

Thông qua buổi này, em tự tin hơn trong việc trình bày sản phẩm kỹ thuật và tổ chức minh chứng dự án. Đây cũng là checkpoint quan trọng để em xác định các hướng cải thiện tiếp theo cho RoughLife, bao gồm hoàn thiện gameplay demo, cải thiện online room flow, củng cố multiplayer backend và tiếp tục tinh chỉnh kế hoạch cloud deployment.

## Ứng dụng thực tế

- Tiếp tục cải thiện gameplay demo và UI flow của RoughLife.
- Tinh chỉnh lobby và room management logic cho online multiplayer.
- Kết nối Unity client rõ ràng hơn với backend APIs.
- Cải thiện monitoring, logging và kế hoạch deployment cho kiến trúc AWS.
- Sử dụng phản hồi từ final presentation để hoàn thiện báo cáo thực tập và tài liệu dự án.

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
