---
title: "Tạo Lambda Room API"
date: 2024-01-01
weight: 8
chapter: false
pre: " <b> 5.8. </b> "
---

#### Mục tiêu

Trong bước này, nhóm triển khai **AWS Lambda** để xử lý logic backend cho hệ thống online room của game RoughLife. Lambda đóng vai trò là lớp xử lý serverless cho các chức năng như tạo phòng, lấy danh sách phòng, lưu dữ liệu người chơi và lưu kết quả trận đấu.

Lambda function được đặt tên là `RoughLifeRoomApi`. Function này giao tiếp với các bảng DynamoDB đã tạo ở bước trước gồm:

- `RoughLifeRooms`: lưu thông tin phòng chơi.
- `RoughLifePlayerSave`: lưu dữ liệu người chơi.
- `RoughLifeMatchResult`: lưu kết quả trận đấu.

Trong phiên bản minh chứng này, Lambda sử dụng mock server address và mock server port để mô phỏng kết quả cấp server cho room. Ở phiên bản production, phần này có thể được thay bằng Amazon GameLift để cấp Game Session, Player Session, IP và Port thật cho người chơi.

---

#### Các bước thực hiện

1. Truy cập dịch vụ **AWS Lambda**.
2. Tạo function mới với tên `RoughLifeRoomApi`.
3. Viết code xử lý các action như:
   - `create`: tạo phòng mới.
   - `list`: lấy danh sách phòng.
   - `savePlayer`: lưu dữ liệu người chơi.
   - `saveMatchResult`: lưu kết quả trận đấu.
4. Cấu hình Environment Variables cho Lambda.
5. Gán quyền IAM để Lambda có thể đọc/ghi dữ liệu vào DynamoDB.
6. Test Lambda bằng các test event trên AWS Console.
7. Kiểm tra dữ liệu đã được ghi thành công vào DynamoDB.

---

#### Minh chứng Lambda Function

![Lambda overview](/images/5-Workshop/5.8-Lambda-room-api/07_01_Lambda_Overview.png)

Hình trên thể hiện Lambda function `RoughLifeRoomApi` đã được tạo thành công. Đây là backend serverless chính dùng để xử lý các request liên quan đến room, player save và match result.

---

#### Minh chứng code và test event

![Lambda code test](/images/5-Workshop/5.8-Lambda-room-api/07_02_Lambda_Code_Test.png)

Hình trên thể hiện phần code source của Lambda function và khu vực tạo test event. Lambda được viết để nhận request dạng JSON, xử lý action tương ứng và trả về response cho client hoặc API Gateway.

---

#### Minh chứng Environment Variables

![Lambda environment variables](/images/5-Workshop/5.8-Lambda-room-api/07_03_Lambda_Environment.png)

Hình trên thể hiện các Environment Variables được cấu hình cho Lambda, bao gồm:

- `ROOM_TABLE`: tên bảng lưu room/session.
- `PLAYER_SAVE_TABLE`: tên bảng lưu dữ liệu người chơi.
- `MATCH_RESULT_TABLE`: tên bảng lưu kết quả trận đấu.
- `MAX_PLAYERS`: số người chơi tối đa trong một phòng.
- `ROOM_TTL_SECONDS`: thời gian tồn tại của phòng.
- `MOCK_SERVER_ADDRESS`: địa chỉ server dùng cho minh chứng.
- `MOCK_SERVER_PORT`: port server dùng cho minh chứng.

Việc dùng Environment Variables giúp Lambda linh hoạt hơn, có thể thay đổi tên bảng hoặc thông tin server mà không cần sửa trực tiếp trong code.

---

#### Minh chứng IAM Permission cho DynamoDB

![Lambda DynamoDB permission](/images/5-Workshop/5.8-Lambda-room-api/07_04_Lambda_IAM_DynamoDB_Permission.png)

Hình trên thể hiện IAM Role của Lambda đã được gán policy để truy cập DynamoDB. Quyền này cho phép Lambda ghi dữ liệu vào các bảng `RoughLifeRooms`, `RoughLifePlayerSave` và `RoughLifeMatchResult`.

---

#### Test chức năng tạo phòng

![Lambda create room test](/images/5-Workshop/5.8-Lambda-room-api/07_05_Lambda_Test_CreateRoom.png)

Hình trên thể hiện kết quả test action tạo phòng trên Lambda. Response trả về có `ok: true`, thông tin `roomCode`, `roomName`, `hostName`, `serverAddress`, `serverPort`, `playerCount`, `maxPlayers` và danh sách member trong phòng.

![DynamoDB room created](/images/5-Workshop/5.8-Lambda-room-api/07_06_DynamoDB_Room_Created.png)

Hình trên thể hiện dữ liệu phòng đã được ghi thành công vào bảng `RoughLifeRooms`. Điều này chứng minh Lambda có thể tạo room và lưu trạng thái phòng vào DynamoDB.

---

#### Test chức năng lưu Player Save

![Lambda player save API](/images/5-Workshop/5.8-Lambda-room-api/07_07_01_Lambda_PlayerSave_API.png)

Hình trên thể hiện Lambda test cho chức năng lưu dữ liệu người chơi. Response trả về cho biết player save đã được cập nhật thành công.

![DynamoDB player save result](/images/5-Workshop/5.8-Lambda-room-api/07_07_02_DynamoDB_PlayerSave_Result.png)

Hình trên thể hiện dữ liệu người chơi đã được lưu vào bảng `RoughLifePlayerSave`. Item bao gồm các thông tin như `playerId`, `displayName`, `lastEquippedWeapon`, `selectedAvatar`, `unlockedBosses`, `playerStats` và thời gian cập nhật.

---

#### Test chức năng lưu Match Result

![Lambda match result API](/images/5-Workshop/5.8-Lambda-room-api/07_08_01_Lambda_MatchResult_API.png)

Hình trên thể hiện Lambda test cho chức năng lưu kết quả trận đấu. Response trả về cho biết match result đã được lưu thành công.

![DynamoDB match result](/images/5-Workshop/5.8-Lambda-room-api/07_08_02_DynamoDB_MatchResult_Result.png)

Hình trên thể hiện dữ liệu kết quả trận đấu đã được ghi vào bảng `RoughLifeMatchResult`. Dữ liệu bao gồm `matchId`, `roomCode`, `bossId`, `result`, `durationSeconds`, danh sách player và phần thưởng.

---

#### Kết quả

Sau bước này, nhóm đã triển khai thành công Lambda backend cho hệ thống online room của RoughLife. Lambda có thể xử lý các request tạo phòng, lấy danh sách phòng, lưu dữ liệu người chơi và lưu kết quả trận đấu. Đồng thời, Lambda đã kết nối thành công với DynamoDB thông qua IAM Role và có thể ghi dữ liệu vào các bảng tương ứng.

Đây là bước quan trọng để chuyển hệ thống lobby/room từ mô hình local test sang kiến trúc backend serverless trên AWS.