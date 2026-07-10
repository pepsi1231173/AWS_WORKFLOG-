---
title: "Bản đề xuất"
date: 2026-07-07
weight: 2
chapter: false
pre: " <b> 2. </b> "
---
{{% notice warning %}}
⚠️ **Lưu ý:** Các thông tin dưới đây chỉ nhằm mục đích tham khảo, vui lòng **không sao chép nguyên văn** cho bài báo cáo của bạn kể cả warning này.
{{% /notice %}}

Tại phần này, bạn cần tóm tắt các nội dung trong workshop mà bạn **dự tính** sẽ làm.

# RoughLife Online Multiplayer Platform
## Kiến trúc AWS GameLift cho Unity NGO + UTP Multiplayer Gameplay

### 1. Tóm tắt điều hành
RoughLife là game sinh tồn online multiplayer được xây dựng bằng Unity Netcode for GameObjects (NGO) và Unity Transport Protocol (UTP). Nền tảng đề xuất sử dụng AWS để xử lý đăng nhập người chơi, tạo phòng, ghép trận, chạy dedicated game server, đặt game session, lưu dữ liệu người chơi, lưu kết quả trận đấu, phân phối bản build/patch và theo dõi vận hành.

Kiến trúc được thiết kế cho phạm vi prototype thực tập nhưng vẫn bám theo hướng triển khai thực tế. Người chơi tải game build và patch thông qua Amazon CloudFront và Amazon S3, đăng nhập bằng Amazon Cognito, tạo hoặc tham gia phòng thông qua HTTP API, sau đó nhận thông tin kết nối GameLift gồm IP, port và player session ID. Luồng gameplay thời gian thực sẽ đi trực tiếp từ Unity client đến game server trên GameLift bằng UDP.

### 2. Tuyên bố vấn đề
### Vấn đề hiện tại
Một game multiplayer không thể chỉ dựa vào local hosting hoặc quản lý server thủ công. Dự án cần có cách đáng tin cậy để xác thực người chơi, tạo phòng, ghép người chơi vào session, khởi động dedicated server process, mở rộng capacity, lưu trạng thái game và theo dõi sức khỏe server. Nếu không có kiến trúc quản lý rõ ràng, hệ thống sẽ khó vận hành khi nhiều phòng hoạt động cùng lúc.

### Giải pháp
Giải pháp đề xuất sử dụng Amazon GameLift làm lớp dedicated game server và kết hợp các dịch vụ serverless của AWS cho lớp ứng dụng. Amazon API Gateway cung cấp Room API, AWS Lambda xử lý logic tạo phòng và matchmaking, Amazon Cognito bảo mật đăng nhập bằng JWT, còn Amazon DynamoDB lưu room, session, player save và match result.

Amazon GameLift quản lý việc đặt game session thông qua Game Session Queue và Fleet Alias. Khi người chơi tạo hoặc tham gia phòng, Lambda gọi GameLift để tạo hoặc tìm game session. GameLift khởi động server process trên managed fleet và trả thông tin kết nối về client. Unity client sau đó kết nối đến game server bằng UDP để chơi realtime.

### Lợi ích và hoàn vốn đầu tư
Kiến trúc này giảm lượng backend tự vận hành cần thiết cho multiplayer hosting. GameLift xử lý vòng đời server, placement và fleet capacity, trong khi lớp ứng dụng serverless giúp luồng tạo phòng và matchmaking đơn giản, phù hợp chi phí cho prototype.

Giá trị chính của dự án là tạo nền tảng multiplayer AWS có thể tái sử dụng cho RoughLife. Nền tảng này giúp kiểm thử gameplay online cốt lõi, xác thực quy trình deploy dedicated server, học vận hành AWS GameLift và chuẩn bị hướng mở rộng sau này. Kiến trúc cũng tách rõ trách nhiệm: CloudFront/S3 cho phân phối build, Cognito cho định danh, API Gateway/Lambda cho điều phối, DynamoDB cho state, GameLift cho gameplay server, CloudWatch/X-Ray/SNS cho quan sát hệ thống.

### 3. Kiến trúc giải pháp
Nền tảng được chia thành bốn lớp chính: lớp bảo mật và phân phối global, lớp dịch vụ ứng dụng, lớp cơ sở dữ liệu và lớp GameLift game server.

Ở lớp edge, Unity client gửi HTTPS request qua AWS WAF và Amazon CloudFront. CloudFront phân phối game build và patch từ S3 release bucket. Ở lớp ứng dụng, Amazon Cognito cung cấp đăng nhập và JWT authentication. API Gateway mở Room API, còn Lambda xử lý tạo phòng, tham gia phòng, matchmaking và thao tác với GameLift session.

Ở lớp cơ sở dữ liệu, DynamoDB lưu dữ liệu room/session, player save và match result. Ở lớp game server, GameLift sử dụng Game Session Queue và Managed Fleet Alias để đặt session lên fleet còn capacity. Mỗi server process có thể chạy một game room, gửi metrics, lưu trạng thái cuối và ghi kết quả trận về DynamoDB.

![Kiến trúc AWS GameLift Online Multiplayer của RoughLife](/images/2-Proposal/image.png)

### Luồng xử lý chính
1. Unity client gửi HTTPS request qua AWS WAF và CloudFront.
2. CloudFront tải game build và patch từ S3 release bucket.
3. Người chơi đăng nhập qua Amazon Cognito và nhận JWT token.
4. Client gọi Room API để tạo hoặc tham gia phòng.
5. API Gateway invoke Lambda để xử lý room và matchmaking.
6. Lambda đọc/ghi dữ liệu room/session, player save và match result trong DynamoDB.
7. Lambda gọi GameLift để tạo hoặc tìm game session.
8. GameLift trả IP address, port và player session ID về client.
9. Unity client kết nối đến GameLift server bằng UDP để gameplay realtime.
10. Server lưu game state và match result về DynamoDB.
11. Logs, metrics, traces và alarms được gửi đến CloudWatch, X-Ray và SNS.
12. CI/CD pipeline build Unity client/server, upload client assets lên S3 và deploy dedicated server build lên GameLift.

### Dịch vụ AWS sử dụng
- **AWS WAF**: Bảo vệ HTTPS endpoint khỏi các kiểu tấn công web phổ biến và traffic không mong muốn.
- **Amazon CloudFront**: Phân phối game build, patch và static assets với độ trễ thấp.
- **Amazon S3**: Lưu release artifact như client build, patch và assets.
- **Amazon Cognito**: Cung cấp xác thực người chơi và kiểm soát truy cập bằng JWT.
- **Amazon API Gateway**: Mở HTTP Room API cho Unity client.
- **AWS Lambda**: Chạy logic tạo phòng, join room, matchmaking và điều phối GameLift.
- **Amazon DynamoDB**: Lưu room/session state, player save và match result.
- **Amazon GameLift Servers**: Host dedicated multiplayer server process và quản lý game session placement.
- **Amazon CloudWatch**: Thu thập logs, metrics, alarms và thông tin sức khỏe server.
- **AWS X-Ray**: Trace request qua API Gateway và Lambda để debug.
- **Amazon SNS**: Gửi cảnh báo cho admin khi alarm được kích hoạt.

### Thiết kế thành phần
- **Unity Client**: Sử dụng NGO và UTP cho gameplay multiplayer. Client đăng nhập, yêu cầu matchmaking, nhận thông tin kết nối và kết nối đến server qua UDP.
- **Authentication Layer**: Cognito xác thực người dùng và phát JWT token cho Room API.
- **Room API Layer**: API Gateway và Lambda cung cấp endpoint tạo phòng, tham gia phòng và matchmaking.
- **Data Layer**: DynamoDB lưu state cần thiết cho luồng ứng dụng và gameplay.
- **Game Server Layer**: GameLift khởi động Linux dedicated server process và đặt game session lên fleet còn capacity.
- **Observability Layer**: CloudWatch, X-Ray và SNS hỗ trợ theo dõi lỗi, latency, server metrics và cảnh báo vận hành.
- **CI/CD Layer**: Unity version control và build automation tạo client build, patch assets và dedicated server artifact để release.

### 4. Triển khai kỹ thuật
**Các giai đoạn triển khai**
- Nghiên cứu và thiết kế kiến trúc: Tìm hiểu Unity NGO/UTP, yêu cầu dedicated server, luồng GameLift session và ranh giới từng dịch vụ AWS.
- Tính chi phí và kiểm tra tính khả thi: Ước tính GameLift fleet usage, data transfer, storage, API calls và monitoring cho prototype nhỏ.
- Điều chỉnh kiến trúc: Tinh chỉnh luồng tạo phòng, matchmaking, save data, deployment và scaling rule để phù hợp phạm vi dự án.
- Phát triển, kiểm thử và triển khai: Xây dựng luồng Unity client/server, deploy AWS resources, test tích hợp GameLift và kiểm tra vòng đời create/join/play/save.

**Yêu cầu kỹ thuật**
- Unity client sử dụng NGO và UTP cho gameplay networking.
- Linux dedicated server build tương thích với GameLift.
- Cognito user pool cho đăng nhập người chơi và JWT authentication.
- API Gateway HTTP API và Lambda functions cho room/matchmaking.
- DynamoDB tables cho room/session state, player save và match result.
- GameLift queue, fleet alias, managed fleet, runtime configuration và auto scaling policy.
- CloudWatch logs/metrics/alarms, X-Ray tracing và SNS alerting cho vận hành.
- CI/CD workflow để build Unity client/server, upload client release lên S3 và deploy server build lên GameLift.

### 5. Lộ trình & Mốc triển khai
**Timeline dự án**
- Tháng 1: Học AWS GameLift, Unity NGO/UTP, Cognito, API Gateway, Lambda và DynamoDB. Hoàn thiện kiến trúc và request flow.
- Tháng 2: Xây dựng Room API, authentication flow, DynamoDB tables và tích hợp cơ bản GameLift fleet/session.
- Tháng 3: Tích hợp Unity client với matchmaking, UDP gameplay connection, server save flow, monitoring và CI/CD deployment.
- Sau triển khai: Kiểm thử tải, tinh chỉnh scaling rule, cải thiện match placement và chuẩn bị các tính năng gameplay tiếp theo.

### 6. Ước tính ngân sách
Chi phí phụ thuộc chủ yếu vào số giờ chạy GameLift fleet instance, data transfer và số lượng phòng đang hoạt động. Với prototype thực tập, hướng khuyến nghị là giữ fleet nhỏ, dùng capacity test tối thiểu, tắt tài nguyên không dùng và đặt AWS Budgets alerts.

### Nhóm chi phí hạ tầng
- **GameLift Managed Fleet**: Chi phí chính vì dedicated server capacity chạy trên fleet instances.
- **CloudFront và S3**: Dùng để phân phối client build và patch.
- **API Gateway và Lambda**: Chi phí thấp ở quy mô prototype cho request tạo phòng và matchmaking.
- **DynamoDB**: Chi phí thấp cho room/session, player save và match result khi traffic nhỏ.
- **Cognito**: Chi phí thấp với số lượng test user nhỏ.
- **CloudWatch, X-Ray và SNS**: Dùng cho logs, traces, metrics, alarms và cảnh báo admin.

### 7. Đánh giá rủi ro
#### Ma trận rủi ro
- Tích hợp GameLift phức tạp: Ảnh hưởng cao, xác suất trung bình.
- Lỗi dedicated server build: Ảnh hưởng cao, xác suất trung bình.
- Sự cố UDP networking hoặc firewall: Ảnh hưởng cao, xác suất trung bình.
- Vượt chi phí do fleet capacity chạy liên tục: Ảnh hưởng trung bình, xác suất trung bình.
- Sai lệch state trong matchmaking hoặc room: Ảnh hưởng trung bình, xác suất trung bình.

#### Chiến lược giảm thiểu
- Bắt đầu với GameLift fleet một region và một luồng room đơn giản trước khi thêm matchmaking nâng cao.
- Tự động hóa đóng gói và deploy server build để giảm lỗi thủ công.
- Test UDP connectivity sớm bằng server process đơn giản trước khi tích hợp gameplay đầy đủ.
- Dùng AWS Budgets, CloudWatch alarms và lịch cleanup cho tài nguyên không sử dụng.
- Thiết kế DynamoDB room/session record rõ ràng và dùng TTL cho session cũ khi phù hợp.

#### Kế hoạch dự phòng
- Dùng local dedicated server testing nếu deploy GameLift bị chặn.
- Tạm rút gọn kiến trúc còn Cognito, API Gateway, Lambda, DynamoDB và một test server quản lý thủ công.
- Rollback về server build alias trước đó nếu GameLift build mới lỗi.

### 8. Kết quả kỳ vọng
#### Cải tiến kỹ thuật
Dự án tạo ra nền tảng online multiplayer hoạt động được cho RoughLife. Người chơi có thể đăng nhập, tạo hoặc tham gia phòng, nhận thông tin kết nối GameLift, kết nối đến dedicated server, chơi bằng UDP và lưu kết quả trận đấu.

#### Giá trị dài hạn
Kiến trúc này có thể trở thành baseline cho các tính năng multiplayer tiếp theo của RoughLife, gồm matchmaking tốt hơn, multi-region placement, party system, player progression, replay analysis và monitoring ở mức production.

<!--
Nội dung proposal cũ được giữ lại bên dưới để tham chiếu và ẩn khỏi trang render.

Tại phần này, bạn cần tóm tắt các nội dung trong workshop mà bạn **dự tính** sẽ làm.

# IoT Weather Platform for Lab Research  
## Giải pháp AWS Serverless hợp nhất cho giám sát thời tiết thời gian thực  

### 1. Tóm tắt điều hành  
IoT Weather Platform được thiết kế dành cho nhóm *ITea Lab* tại TP. Hồ Chí Minh nhằm nâng cao khả năng thu thập và phân tích dữ liệu thời tiết. Nền tảng hỗ trợ tối đa 5 trạm thời tiết, có khả năng mở rộng lên 10–15 trạm, sử dụng thiết bị biên Raspberry Pi kết hợp cảm biến ESP32 để truyền dữ liệu qua MQTT. Nền tảng tận dụng các dịch vụ AWS Serverless để cung cấp giám sát thời gian thực, phân tích dự đoán và tiết kiệm chi phí, với quyền truy cập giới hạn cho 5 thành viên phòng lab thông qua Amazon Cognito.  

### 2. Tuyên bố vấn đề  
*Vấn đề hiện tại*  
Các trạm thời tiết hiện tại yêu cầu thu thập dữ liệu thủ công, khó quản lý khi có nhiều trạm. Không có hệ thống tập trung cho dữ liệu hoặc phân tích thời gian thực, và các nền tảng bên thứ ba thường tốn kém và quá phức tạp.  

*Giải pháp*  
Nền tảng sử dụng AWS IoT Core để tiếp nhận dữ liệu MQTT, AWS Lambda và API Gateway để xử lý, Amazon S3 để lưu trữ (bao gồm data lake), và AWS Glue Crawlers cùng các tác vụ ETL để trích xuất, chuyển đổi, tải dữ liệu từ S3 data lake sang một S3 bucket khác để phân tích. AWS Amplify với Next.js cung cấp giao diện web, và Amazon Cognito đảm bảo quyền truy cập an toàn. Tương tự như Thingsboard và CoreIoT, người dùng có thể đăng ký thiết bị mới và quản lý kết nối, nhưng nền tảng này hoạt động ở quy mô nhỏ hơn và phục vụ mục đích sử dụng nội bộ. Các tính năng chính bao gồm bảng điều khiển thời gian thực, phân tích xu hướng và chi phí vận hành thấp.  

*Lợi ích và hoàn vốn đầu tư (ROI)*  
Giải pháp tạo nền tảng cơ bản để các thành viên phòng lab phát triển một nền tảng IoT lớn hơn, đồng thời cung cấp nguồn dữ liệu cho những người nghiên cứu AI phục vụ huấn luyện mô hình hoặc phân tích. Nền tảng giảm bớt báo cáo thủ công cho từng trạm thông qua hệ thống tập trung, đơn giản hóa quản lý và bảo trì, đồng thời cải thiện độ tin cậy dữ liệu. Chi phí hàng tháng ước tính 0,66 USD (theo AWS Pricing Calculator), tổng cộng 7,92 USD cho 12 tháng. Tất cả thiết bị IoT đã được trang bị từ hệ thống trạm thời tiết hiện tại, không phát sinh chi phí phát triển thêm. Thời gian hoàn vốn 6–12 tháng nhờ tiết kiệm đáng kể thời gian thao tác thủ công.  

### 3. Kiến trúc giải pháp  
Nền tảng áp dụng kiến trúc AWS Serverless để quản lý dữ liệu từ 5 trạm dựa trên Raspberry Pi, có thể mở rộng lên 15 trạm. Dữ liệu được tiếp nhận qua AWS IoT Core, lưu trữ trong S3 data lake và xử lý bởi AWS Glue Crawlers và ETL jobs để chuyển đổi và tải vào một S3 bucket khác cho mục đích phân tích. Lambda và API Gateway xử lý bổ sung, trong khi Amplify với Next.js cung cấp bảng điều khiển được bảo mật bởi Cognito.  

![IoT Weather Station Architecture](/images/2-Proposal/edge_architecture.jpeg)

![IoT Weather Platform Architecture](/images/2-Proposal/platform_architecture.jpeg)

*Dịch vụ AWS sử dụng*  
- *AWS IoT Core*: Tiếp nhận dữ liệu MQTT từ 5 trạm, mở rộng lên 15.  
- *AWS Lambda*: Xử lý dữ liệu và kích hoạt Glue jobs (2 hàm).  
- *Amazon API Gateway*: Giao tiếp với ứng dụng web.  
- *Amazon S3*: Lưu trữ dữ liệu thô (data lake) và dữ liệu đã xử lý (2 bucket).  
- *AWS Glue*: Crawlers lập chỉ mục dữ liệu, ETL jobs chuyển đổi và tải dữ liệu.  
- *AWS Amplify*: Lưu trữ giao diện web Next.js.  
- *Amazon Cognito*: Quản lý quyền truy cập cho người dùng phòng lab.  

*Thiết kế thành phần*  
- *Thiết bị biên*: Raspberry Pi thu thập và lọc dữ liệu cảm biến, gửi tới IoT Core.  
- *Tiếp nhận dữ liệu*: AWS IoT Core nhận tin nhắn MQTT từ thiết bị biên.  
- *Lưu trữ dữ liệu*: Dữ liệu thô lưu trong S3 data lake; dữ liệu đã xử lý lưu ở một S3 bucket khác.  
- *Xử lý dữ liệu*: AWS Glue Crawlers lập chỉ mục dữ liệu; ETL jobs chuyển đổi để phân tích.  
- *Giao diện web*: AWS Amplify lưu trữ ứng dụng Next.js cho bảng điều khiển và phân tích thời gian thực.  
- *Quản lý người dùng*: Amazon Cognito giới hạn 5 tài khoản hoạt động.  

### 4. Triển khai kỹ thuật  
*Các giai đoạn triển khai*  
Dự án gồm 2 phần — thiết lập trạm thời tiết biên và xây dựng nền tảng thời tiết — mỗi phần trải qua 4 giai đoạn:  
1. *Nghiên cứu và vẽ kiến trúc*: Nghiên cứu Raspberry Pi với cảm biến ESP32 và thiết kế kiến trúc AWS Serverless (1 tháng trước kỳ thực tập).  
2. *Tính toán chi phí và kiểm tra tính khả thi*: Sử dụng AWS Pricing Calculator để ước tính và điều chỉnh (Tháng 1).  
3. *Điều chỉnh kiến trúc để tối ưu chi phí/giải pháp*: Tinh chỉnh (ví dụ tối ưu Lambda với Next.js) để đảm bảo hiệu quả (Tháng 2).  
4. *Phát triển, kiểm thử, triển khai*: Lập trình Raspberry Pi, AWS services với CDK/SDK và ứng dụng Next.js, sau đó kiểm thử và đưa vào vận hành (Tháng 2–3).  

*Yêu cầu kỹ thuật*  
- *Trạm thời tiết biên*: Cảm biến (nhiệt độ, độ ẩm, lượng mưa, tốc độ gió), vi điều khiển ESP32, Raspberry Pi làm thiết bị biên. Raspberry Pi chạy Raspbian, sử dụng Docker để lọc dữ liệu và gửi 1 MB/ngày/trạm qua MQTT qua Wi-Fi.  
- *Nền tảng thời tiết*: Kiến thức thực tế về AWS Amplify (lưu trữ Next.js), Lambda (giảm thiểu do Next.js xử lý), AWS Glue (ETL), S3 (2 bucket), IoT Core (gateway và rules), và Cognito (5 người dùng). Sử dụng AWS CDK/SDK để lập trình (ví dụ IoT Core rules tới S3). Next.js giúp giảm tải Lambda cho ứng dụng web fullstack.  

### 5. Lộ trình & Mốc triển khai  
- *Trước thực tập (Tháng 0)*: 1 tháng lên kế hoạch và đánh giá trạm cũ.  
- *Thực tập (Tháng 1–3)*:  
    - Tháng 1: Học AWS và nâng cấp phần cứng.  
    - Tháng 2: Thiết kế và điều chỉnh kiến trúc.  
    - Tháng 3: Triển khai, kiểm thử, đưa vào sử dụng.  
- *Sau triển khai*: Nghiên cứu thêm trong vòng 1 năm.  

### 6. Ước tính ngân sách  
Có thể xem chi phí trên [AWS Pricing Calculator](https://calculator.aws/#/estimate?id=621f38b12a1ef026842ba2ddfe46ff936ed4ab01)  
Hoặc tải [tệp ước tính ngân sách](../attachments/budget_estimation.pdf).  

*Chi phí hạ tầng*  
- AWS Lambda: 0,00 USD/tháng (1.000 request, 512 MB lưu trữ).  
- S3 Standard: 0,15 USD/tháng (6 GB, 2.100 request, 1 GB quét).  
- Truyền dữ liệu: 0,02 USD/tháng (1 GB vào, 1 GB ra).  
- AWS Amplify: 0,35 USD/tháng (256 MB, request 500 ms).  
- Amazon API Gateway: 0,01 USD/tháng (2.000 request).  
- AWS Glue ETL Jobs: 0,02 USD/tháng (2 DPU).  
- AWS Glue Crawlers: 0,07 USD/tháng (1 crawler).  
- MQTT (IoT Core): 0,08 USD/tháng (5 thiết bị, 45.000 tin nhắn).  

*Tổng*: 0,7 USD/tháng, 8,40 USD/12 tháng  
- *Phần cứng*: 265 USD một lần (Raspberry Pi 5 và cảm biến).  

### 7. Đánh giá rủi ro  
*Ma trận rủi ro*  
- Mất mạng: Ảnh hưởng trung bình, xác suất trung bình.  
- Hỏng cảm biến: Ảnh hưởng cao, xác suất thấp.  
- Vượt ngân sách: Ảnh hưởng trung bình, xác suất thấp.  

*Chiến lược giảm thiểu*  
- Mạng: Lưu trữ cục bộ trên Raspberry Pi với Docker.  
- Cảm biến: Kiểm tra định kỳ, dự phòng linh kiện.  
- Chi phí: Cảnh báo ngân sách AWS, tối ưu dịch vụ.  

*Kế hoạch dự phòng*  
- Quay lại thu thập thủ công nếu AWS gặp sự cố.  
- Sử dụng CloudFormation để khôi phục cấu hình liên quan đến chi phí.  

### 8. Kết quả kỳ vọng  
*Cải tiến kỹ thuật*: Dữ liệu và phân tích thời gian thực thay thế quy trình thủ công. Có thể mở rộng tới 10–15 trạm.  
*Giá trị dài hạn*: Nền tảng dữ liệu 1 năm cho nghiên cứu AI, có thể tái sử dụng cho các dự án tương lai.
-->
