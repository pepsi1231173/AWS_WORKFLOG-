---
title: "Thiết lập GameLift Alias và Game Session Queue"
date: 2024-01-01
weight: 11
chapter: false
pre: " <b> 5.11. </b> "
---

#### Mục tiêu

Trong bước này, nhóm thiết kế bước tiếp theo của Amazon GameLift là tạo **Fleet Alias** và **Game Session Queue** cho hệ thống online multiplayer của RoughLife.

Trong kiến trúc hoàn chỉnh, Alias và Queue sẽ được dùng để tách client/backend khỏi Fleet ID trực tiếp. Thay vì Lambda hoặc backend gọi thẳng vào một fleet cụ thể, hệ thống sẽ gọi qua Queue hoặc Alias để dễ thay đổi fleet, hỗ trợ mở rộng và triển khai phiên bản server mới.

Luồng dự kiến:

1. Unity Client gửi request tạo phòng đến API Gateway.
2. API Gateway gọi Lambda `RoughLifeRoomApi`.
3. Lambda gọi GameLift Game Session Queue.
4. GameLift chọn fleet phù hợp để tạo Game Session.
5. GameLift trả về IP, Port và PlayerSessionId.
6. Unity Client dùng thông tin này để kết nối UDP đến dedicated server.

---

#### Thiết kế Fleet Alias

Fleet Alias dự kiến được tạo với tên:

- Alias name: `RoughLife-FleetAlias-Dev`
- Routing strategy: trỏ đến GameLift Managed EC2 Fleet hoặc Anywhere Fleet.
- Mục đích: giúp backend không phụ thuộc trực tiếp vào Fleet ID.

Khi có fleet thật, Alias sẽ được liên kết với fleet đang active. Nếu cần thay đổi fleet hoặc deploy bản server mới, nhóm có thể cập nhật Alias để trỏ sang fleet mới mà không cần sửa logic phía Unity Client hoặc Lambda.

---

#### Thiết kế Game Session Queue

Game Session Queue dự kiến được tạo với tên:

- Queue name: `RoughLife-GameSessionQueue-Dev`
- Destination: Fleet Alias hoặc Fleet ARN.
- Region: `ap-southeast-1`
- Timeout: dùng giá trị mặc định hoặc cấu hình theo nhu cầu test.
- Mục đích: chọn fleet phù hợp để tạo Game Session cho người chơi.

Queue giúp hệ thống có thể mở rộng tốt hơn trong tương lai. Khi có nhiều fleet hoặc nhiều location, GameLift Queue có thể hỗ trợ điều phối game session đến destination phù hợp.

---

#### Trạng thái hiện tại

Ở thời điểm thực hiện báo cáo, nhóm chưa thể tạo Fleet Alias và Game Session Queue hoàn chỉnh do AWS account hiện tại chưa được cấp quota để tạo GameLift Fleet.

Các minh chứng ở bước trước cho thấy:

![GameLift fleet quota error](/images/5-Workshop/5.11-gamelift-queue-alias/10_07_GameLift_FleetQuota_Error.png)

AWS báo lỗi khi tạo Managed EC2 Fleet vì giới hạn fleet hiện tại bằng 0.

![Service quota increase request](/images/5-Workshop/5.11-gamelift-queue-alias/10_09_ServiceQuota_Increase_Request.png)

Nhóm đã kiểm tra Service Quotas và gửi request tăng quota để có thể tạo fleet trong region `ap-southeast-1`.

![GameLift Anywhere quota error](/images/5-Workshop/5.11-gamelift-queue-alias/10A_02_GameLift_FleetQuota_Error.png)

Nhóm cũng thử phương án GameLift Anywhere, nhưng việc tạo Anywhere fleet cũng bị chặn bởi giới hạn fleet hiện tại.

Vì Alias và Queue cần fleet hoặc fleet alias destination để hoạt động, nên bước này chỉ có thể hoàn tất sau khi AWS duyệt quota và fleet được tạo thành công.

---

#### Kế hoạch hoàn tất sau khi được cấp quota

Sau khi AWS cấp quota tạo GameLift Fleet, nhóm sẽ thực hiện các bước sau:

1. Tạo Managed EC2 Fleet từ build `RoughLifeServer`.
2. Chờ fleet chuyển sang trạng thái Active.
3. Tạo Fleet Alias `RoughLife-FleetAlias-Dev`.
4. Liên kết Alias với fleet đang active.
5. Tạo Game Session Queue `RoughLife-GameSessionQueue-Dev`.
6. Thêm Alias hoặc Fleet ARN làm destination của Queue.
7. Cập nhật Lambda `RoughLifeRoomApi` để gọi GameLift Queue thay vì dùng mock server address.
8. Test luồng tạo Game Session và nhận IP, Port, PlayerSessionId.
9. Cho Unity Client kết nối UDP đến dedicated server.

---

#### Kết quả

Do giới hạn quota của AWS account, nhóm chưa thể tạo Fleet Alias và Game Session Queue ở thời điểm hiện tại. Tuy nhiên, nhóm đã hoàn thành phần chuẩn bị quan trọng gồm upload server build, cấu hình fleet, cấu hình runtime, cấu hình UDP port, kiểm tra Service Quotas và gửi request tăng quota.

Bước Alias và Queue sẽ được hoàn tất ngay sau khi AWS cấp quyền tạo GameLift Fleet. Trong kiến trúc cuối cùng, Alias và Game Session Queue là thành phần quan trọng giúp hệ thống RoughLife có thể mở rộng, thay đổi fleet linh hoạt và cấp game session cho người chơi theo mô hình dedicated server thực tế.