---
title: "FCAJ x AABW Project Sharing Day"
date: 2024-01-01
weight: 5
chapter: false
pre: " <b> 4.5. </b> "
---

# FCAJ x AABW Project Sharing Day

## Thông tin sự kiện

**Tên sự kiện:** FCAJ x AABW Project Sharing Day  
**Thời gian:** 25/07/2026  
**Địa điểm:** Tầng 36, Bitexco Tower, 02 Hai Triệu, Phường Sài Gòn, TP. Hồ Chí Minh  
**Vai trò:** Người tham dự

## Tổng quan

Đây là buổi chia sẻ dự án FCAJ x AABW, nơi các nhóm trình bày những gì đã xây dựng, đã học và đã trải nghiệm trong quá trình tham gia Agentic AI Build Week. Nội dung không chỉ tập trung vào sản phẩm cuối cùng, mà còn thể hiện quá trình hình thành ý tưởng, xác định vấn đề, thiết kế kiến trúc, triển khai MVP, chuẩn bị demo và rút ra bài học sau khi xây dựng trong thời gian ngắn.

Sự kiện giúp em hiểu rõ hơn cách AI và các dịch vụ AWS có thể được dùng để biến một vấn đề thực tế thành prototype có thể trình bày được. Qua các phần chia sẻ, em thấy được cách các nhóm kết hợp computer vision, agentic AI, dashboard, cloud architecture, cost estimation và business analysis vào những dự án có định hướng phục vụ người dùng thật.

## Mục tiêu sự kiện

- Tìm hiểu cách các nhóm biến ý tưởng thành MVP trong thời gian build week ngắn.
- Hiểu cách agentic AI hỗ trợ monitoring, phân tích, tạo bản nháp kiến trúc và ra quyết định.
- Quan sát cách lựa chọn dịch vụ AWS cho các dự án thực tế, bao gồm AI, compute, storage, security, hosting và observability.
- Học cách trình bày dự án thông qua problem statement, architecture, demo flow, impact và hướng cải thiện.
- Rút kinh nghiệm để áp dụng vào dự án thực tập và báo cáo cuối kỳ của em.

## Nội dung chính

### Hackathon Journey - Team 3KA

Team 3KA chia sẻ hành trình tham gia hackathon từ lúc đăng ký, chọn track, xây dựng sản phẩm trong áp lực thời gian, chuẩn bị demo, đến phần nhìn lại bài học sau sự kiện. Dự án của nhóm là S.H.E.P.H.E.R.D., tập trung vào smart human-flow evaluation, prediction, hazard detection, response và dispatch.

Nhóm trình bày cách hệ thống phân tích video từ camera để phát hiện và theo dõi người, đo mật độ đám đông, ước lượng tình trạng hàng chờ, nhận diện dấu hiệu ùn tắc, tạo cảnh báo sớm và đề xuất hành động cho nhân sự vận hành. Giải pháp sử dụng các công nghệ như YOLO, ByteTrack, Amazon SageMaker, Amazon Bedrock AgentCore, Strands Agent và React monitoring dashboard.

### Solution Architect Professional Native App

Phần này giới thiệu một AI native application hỗ trợ Solution Architect xử lý yêu cầu khách hàng nhanh hơn. Ý tưởng chính là phân tích yêu cầu bằng ngôn ngữ tự nhiên hoặc tài liệu có cấu trúc, tạo bản nháp high-level architecture, sinh sơ đồ Draw.io và AWS architecture diagram, ước tính chi phí AWS cho khu vực ap-southeast-1, đồng thời chỉ ra assumptions và requirement gaps để tiếp tục trao đổi với khách hàng.

Điểm em thấy hữu ích là phần so sánh trước và sau khi có công cụ. Nếu làm thủ công, kiến trúc sư phải đọc tài liệu yêu cầu từng dòng, bắt đầu từ trang trắng, tự vẽ sơ đồ và ước lượng chi phí dựa nhiều vào kinh nghiệm. Với AI native app, nhóm có thể tạo bản nháp có cơ sở, requirements catalogue, sơ đồ kiến trúc, định hướng Infrastructure as Code và cost estimate để review và cải thiện tiếp.

### SignalScout

SignalScout được giới thiệu như một nền tảng hỗ trợ ra quyết định, dùng để phát hiện sớm các thay đổi chiến lược của doanh nghiệp. Dự án kết nối những tín hiệu rời rạc từ dữ liệu công khai và dữ liệu vận hành thành một câu chuyện phân tích rõ ràng hơn, giúp các nhóm business có cơ sở khi đưa ra quyết định Maintain, Adapt hoặc Accelerate.

Phần trình bày sử dụng value creation and delivery canvas để giải thích key partners, key activities, key resources, value propositions, channels, customer segments và analysis outputs. Nhóm cũng trình bày kiến trúc AWS và kế hoạch chi phí cho các dịch vụ như Amazon Bedrock, AgentCore, WAF, Amplify Hosting, CloudWatch, Secrets Manager, DynamoDB, Lambda, Route 53, CloudTrail, S3, API Gateway và Cognito.

### Community sharing và demo

Sự kiện còn có các phần demo và Q&A. Các nhóm không chỉ trình bày hệ thống làm được gì, mà còn chia sẻ những khó khăn trong quá trình làm: thời gian hạn chế, lần đầu tiếp cận một số dịch vụ AWS, độ trễ khi xử lý, độ ổn định của tracking, bài toán chi phí, yêu cầu chưa rõ, áp lực teamwork và cách giữ demo đủ đơn giản để hoàn thành.

## Bài học rút ra

### Xây dựng sản phẩm trong áp lực thời gian

Phần Hackathon Journey cho thấy một tính năng nhỏ nhưng hoàn thiện sẽ có giá trị hơn một ý tưởng lớn nhưng chưa chạy được. Nhóm cần xác định mục tiêu rõ ràng, chuẩn bị công cụ ban đầu, phân chia vai trò sớm và luyện trước câu chuyện demo.

### Agentic AI trong dự án thực tế

Các dự án cho thấy AI agents sẽ hữu ích hơn khi mỗi agent có trách nhiệm rõ ràng. Trong S.H.E.P.H.E.R.D., agentic layer hỗ trợ theo dõi live metrics và tạo cảnh báo chủ động. Trong Solution Architect app, AI hỗ trợ chuyển yêu cầu thành bản nháp kiến trúc, sơ đồ, assumptions và cost estimates.

### Kiến trúc và chi phí

Các phần trình bày nhắc em rằng xây dựng với AWS không chỉ là chọn dịch vụ. Nhóm còn cần quan tâm đến architecture diagram, security, monitoring, cost range, data flow và phần nào nên tự động hóa, phần nào cần con người review.

### Kỹ năng demo và giao tiếp

Một bài demo kỹ thuật cần có câu chuyện đơn giản. Các phần trình bày hiệu quả thường bắt đầu từ vấn đề thật, giải thích vì sao vấn đề quan trọng, trình bày kiến trúc giải pháp, sau đó demo phần prototype đã làm được.

## Cảm nhận cá nhân

Sự kiện này hữu ích cho kỳ thực tập của em vì em được quan sát cách các nhóm khác trình bày sản phẩm kỹ thuật một cách rõ ràng. Em học được rằng một bài thuyết trình dự án không chỉ cần ảnh chụp màn hình hoặc sơ đồ kiến trúc, mà còn cần giải thích vấn đề, người dùng, giả định, giới hạn và hướng phát triển tiếp theo.

Phần Hackathon Journey cũng giúp em tự tin hơn khi xây dựng prototype. Dù gặp vấn đề kỹ thuật, vai trò trong nhóm chưa rõ hoặc thời gian gấp, nhóm vẫn có thể tạo ra kết quả có ý nghĩa nếu biết kiểm soát phạm vi và tập trung demo vào giá trị quan trọng nhất.

## Ứng dụng thực tế

- Áp dụng cấu trúc problem-solution-impact rõ ràng hơn khi trình bày dự án RoughLife.
- Giữ phạm vi dự án thực tế và tập trung vào demo có thể chạy được.
- Cải thiện tài liệu kiến trúc bằng cách ghi rõ assumptions, trách nhiệm của từng dịch vụ và yếu tố chi phí.
- Tìm hiểu thêm về Amazon Bedrock, AgentCore, SageMaker, Lambda, DynamoDB, CloudWatch và API Gateway.
- Sử dụng các bài học từ sự kiện để chuẩn bị slide, demo và phần giải thích kỹ thuật tốt hơn.

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
