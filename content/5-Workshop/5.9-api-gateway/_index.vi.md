---
title: "Tạo API Gateway HTTP API"
date: 2024-01-01
weight: 9
chapter: false
pre: " <b> 5.9. </b> "
---

#### Mục tiêu

Trong bước này, nhóm triển khai **Amazon API Gateway** để public Lambda `RoughLifeRoomApi` ra bên ngoài thông qua HTTP endpoint. API Gateway đóng vai trò là cổng giao tiếp giữa Unity Client và Lambda backend.

Thay vì Unity Client gọi trực tiếp Lambda, client sẽ gửi request HTTP đến API Gateway. API Gateway sau đó chuyển request đến Lambda để xử lý các chức năng như tạo phòng, lấy danh sách phòng, lưu dữ liệu người chơi và lưu kết quả trận đấu.

#### Luồng xử lý tổng quan

Luồng xử lý của Room API được thiết kế như sau:

1. **Unity Client** gửi HTTP request đến API Gateway.
2. **API Gateway HTTP API** nhận request tại route `/room`.
3. **Lambda RoughLifeRoomApi** xử lý action trong request.
4. **DynamoDB** lưu hoặc trả về dữ liệu tương ứng.

Luồng này giúp tách Unity Client khỏi Lambda trực tiếp, đồng thời tạo ra một endpoint HTTP rõ ràng để game client có thể gọi trong quá trình tạo phòng, lấy danh sách phòng hoặc lưu dữ liệu.

---

#### Các bước thực hiện

1. Truy cập dịch vụ **Amazon API Gateway**.
2. Tạo HTTP API mới với tên `RoughLifeRoomHttpApi`.
3. Tạo route `/room` với method `POST`.
4. Tích hợp route `/room` với Lambda function `RoughLifeRoomApi`.
5. Cấu hình CORS để Unity Client hoặc công cụ test có thể gọi API.
6. Deploy API ra stage `$default`.
7. Lấy Invoke URL của API Gateway.
8. Test API bằng lệnh `curl` từ CMD.

---

#### Minh chứng API Gateway Overview

![API Gateway overview](/images/5-Workshop/5.9-api-gateway/08_01_API_Gateway_Overview.png)

Hình trên thể hiện HTTP API `RoughLifeRoomHttpApi` đã được tạo thành công. API có endpoint mặc định và được triển khai trong region **Asia Pacific Singapore**.

API này là cổng HTTP chính để Unity Client giao tiếp với backend serverless của RoughLife.

---

#### Minh chứng route POST /room

![API Gateway route POST room](/images/5-Workshop/5.9-api-gateway/08_02_API_Gateway_Route_POST_room.png)

Hình trên thể hiện route `/room` với method `POST`. Đây là endpoint chính mà Unity Client sẽ gọi để gửi các request liên quan đến hệ thống phòng chơi.

Các action chính được gửi đến route `/room` gồm:

- `create`: tạo phòng chơi mới.
- `list`: lấy danh sách phòng đang mở.
- `savePlayer`: lưu dữ liệu người chơi.
- `saveMatchResult`: lưu kết quả trận đấu.

Ví dụ request tạo phòng:

- `action`: `create`
- `playerName`: `Le`
- `playerId`: `player-demo-001`

Ví dụ request lấy danh sách phòng:

- `action`: `list`

Ví dụ request lưu player save:

- `action`: `savePlayer`
- `playerId`: `player-demo-001`
- `displayName`: `Le`

Ví dụ request lưu match result:

- `action`: `saveMatchResult`
- `matchId`: `match-demo-001`
- `roomCode`: `AB12CD`
- `bossId`: `Minotaur`
- `result`: `WIN`

---

#### Minh chứng CORS

![API Gateway CORS](/images/5-Workshop/5.9-api-gateway/08_03_API_Gateway_CORS.png)

Hình trên thể hiện cấu hình CORS cho API Gateway.

CORS được cấu hình với các thông tin chính:

- **Access-Control-Allow-Origin**: cho phép origin gọi API.
- **Access-Control-Allow-Headers**: cho phép `content-type` và `authorization`.
- **Access-Control-Allow-Methods**: cho phép `POST`, `OPTIONS` và `GET`.

Cấu hình này giúp client hoặc công cụ HTTP test có thể gọi API mà không bị chặn bởi cơ chế Cross-Origin Resource Sharing.

---

#### Minh chứng Stage và Invoke URL

![API Gateway stage invoke URL](/images/5-Workshop/5.9-api-gateway/08_04_API_Gateway_Stage_Invoke_URL.png)

Hình trên thể hiện stage `$default` đã được deploy thành công. API Gateway cung cấp Invoke URL để client có thể gọi API.

Invoke URL có dạng:

`https://<api-id>.execute-api.ap-southeast-1.amazonaws.com`

Khi gọi route `/room`, endpoint hoàn chỉnh sẽ có dạng:

`https://<api-id>.execute-api.ap-southeast-1.amazonaws.com/room`

Endpoint này sẽ được Unity Client sử dụng để gửi request tạo phòng, lấy danh sách phòng và lưu dữ liệu online.

---

#### Test API bằng CMD

![CMD test list room](/images/5-Workshop/5.9-api-gateway/08_05_CMD_Test_ListRoom.png)

Hình trên thể hiện việc test API Gateway bằng lệnh `curl` trên CMD. Request gửi action `list` đến endpoint `/room`, sau đó API trả về danh sách room hiện có.

Lệnh test được sử dụng có dạng:

`curl -X POST "https://<api-id>.execute-api.ap-southeast-1.amazonaws.com/room" -H "Content-Type: application/json" -d "{\"action\":\"list\"}"`

Response trả về có `ok: true` và danh sách room. Điều này chứng minh API Gateway đã kết nối thành công đến Lambda, đồng thời Lambda có thể đọc dữ liệu từ DynamoDB.

---

#### Vai trò của API Gateway trong hệ thống RoughLife

API Gateway giúp hệ thống online của RoughLife có một lớp backend rõ ràng hơn thay vì để client gọi trực tiếp vào Lambda hoặc database.

Trong kiến trúc hiện tại, API Gateway đảm nhận các vai trò:

- Cung cấp HTTP endpoint public cho Unity Client.
- Chuyển request từ client đến Lambda backend.
- Hỗ trợ cấu hình CORS cho client.
- Chuẩn bị nền tảng để tích hợp authentication bằng Cognito JWT.
- Giúp hệ thống dễ mở rộng sang các API khác như matchmaking, player profile hoặc match history.

---

#### Kết quả

Sau bước này, nhóm đã public thành công Room API thông qua Amazon API Gateway. Unity Client có thể gọi endpoint `/room` để thực hiện các chức năng online lobby như tạo phòng, lấy danh sách phòng, lưu dữ liệu người chơi và lưu kết quả trận đấu.

Việc sử dụng API Gateway giúp hệ thống RoughLife tiến gần hơn với mô hình backend thực tế cho game online multiplayer. Đây là lớp trung gian quan trọng giữa Unity Client, Lambda backend và DynamoDB.