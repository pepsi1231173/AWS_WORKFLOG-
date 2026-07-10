---
title: "Tạo DynamoDB Tables"
date: 2024-01-01
weight: 7
chapter: false
pre: " <b> 5.7. </b> "
---

#### Mục tiêu

Trong bước này, nhóm tạo các bảng **Amazon DynamoDB** để lưu trữ dữ liệu phục vụ hệ thống online multiplayer của RoughLife. DynamoDB được sử dụng cho các loại dữ liệu có cấu trúc đơn giản, cần truy cập nhanh và phù hợp với hệ thống room/session.

Các bảng được tạo gồm:

- `RoughLifeRooms`: lưu thông tin phòng chơi, trạng thái phòng, số lượng người chơi và thời gian hết hạn.
- `RoughLifePlayerSave`: lưu dữ liệu người chơi như tên hiển thị, avatar, vũ khí và boss đã mở khóa.
- `RoughLifeMatchResult`: lưu kết quả trận đấu, boss đã đánh, thời lượng trận và phần thưởng.

Đối với bảng room/session, nhóm bật **Time to Live (TTL)** để tự động xóa các room hết hạn. DynamoDB TTL cho phép xóa item không còn cần thiết dựa trên timestamp hết hạn, giúp hạn chế dữ liệu rác trong bảng. :contentReference[oaicite:7]{index=7}

#### Các bước thực hiện

1. Truy cập dịch vụ **Amazon DynamoDB**.
2. Tạo bảng `RoughLifeRooms` với partition key là `roomCode`.
3. Tạo bảng `RoughLifePlayerSave` với partition key là `playerId`.
4. Tạo bảng `RoughLifeMatchResult` với partition key là `matchId`.
5. Chọn capacity mode là **On-demand** cho các bảng.
6. Bật TTL cho bảng `RoughLifeRooms` với attribute `expiresAt`.
7. Tạo item mẫu để minh chứng cấu trúc dữ liệu.

#### Minh chứng danh sách DynamoDB Tables

![DynamoDB tables](/images/5-Workshop/5.7-Dynamodb-tables/06_01.png)

Hình trên thể hiện ba bảng DynamoDB đã được tạo thành công gồm `RoughLifeRooms`, `RoughLifePlayerSave` và `RoughLifeMatchResult`. Các bảng đang ở trạng thái Active và sử dụng capacity mode On-demand.

#### Minh chứng TTL cho bảng RoughLifeRooms

![DynamoDB TTL](/images/5-Workshop/5.7-Dynamodb-tables/06_02.png)

Hình trên thể hiện bảng `RoughLifeRooms` đã bật Time to Live với TTL attribute là `expiresAt`. Cơ chế này giúp hệ thống tự động dọn các room/session hết hạn.

#### Minh chứng item trong bảng RoughLifeRooms

![DynamoDB Rooms item](/images/5-Workshop/5.7-Dynamodb-tables/06_03.png)

Hình trên thể hiện item mẫu trong bảng `RoughLifeRooms`. Item bao gồm các thông tin như `roomCode`, `createdAt`, `expiresAt`, `gameSessionId`, `hostPlayerId`, `maxPlayers`, `playerCount` và `roomName`.

#### Minh chứng item trong bảng RoughLifePlayerSave

![DynamoDB PlayerSave item](/images/5-Workshop/5.7-Dynamodb-tables/06_04.png)

Hình trên thể hiện item mẫu trong bảng `RoughLifePlayerSave`. Bảng này dùng để lưu dữ liệu người chơi như `playerId`, `displayName`, vũ khí đang trang bị, avatar đã chọn, boss đã mở khóa và danh sách vũ khí.

#### Minh chứng item trong bảng RoughLifeMatchResult

![DynamoDB MatchResult item](/images/5-Workshop/5.7-Dynamodb-tables/06_05.png)

Hình trên thể hiện item mẫu trong bảng `RoughLifeMatchResult`. Bảng này dùng để lưu kết quả trận đấu như `matchId`, `bossId`, `durationSeconds`, danh sách người chơi, kết quả thắng/thua, phần thưởng và `roomCode`.

#### Kết quả

Sau bước này, hệ thống đã có lớp database serverless để lưu trữ dữ liệu phòng chơi, dữ liệu người chơi và kết quả trận đấu. Đây là nền tảng để Room API, Matchmaking API hoặc GameLift session logic có thể đọc/ghi dữ liệu trong quá trình vận hành game online.