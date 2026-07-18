---
title: 'Tuần 9 - Thiết kế map Lobby, setup collider 2D và hệ thống Multiplayer'
date: 2024-06-21
weight: 9
chapter: false
pre: ' <b> 1.9. </b> '
---

### Mục tiêu tuần 9:

- Thiết kế UI Lobby Scene, vẽ map game 2D góc nhìn từ trên xuống, setup collider cho map và tìm hiểu về cơ chế online.

### Các công việc cần triển khai trong tuần này:

| Thứ       | Công việc                                                                                                                                                                                                | Ngày bắt đầu | Ngày hoàn thành | Trạng thái      |
| --------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------ | --------------- | --------------- |
| 2 , 3 , 4 | - Tìm hiểu, học về cách làm Lobby cho Unity <br> - Tìm kiếm ảnh để thiết kế UI                                                                                                                           | 15/06/2026   | 17/06/2026      | Hoàn thành      |
| 5 , 6 , 7 | - Thiết kế UI và map game <br>&emsp; + Vị trí nhân vật khi vào Lobby <br>&emsp; + Ô join phòng <br>&emsp; + Ô nhập code <br>&emsp; + Nút start game <br>&emsp; + Nút out về menu <br>&emsp; + Bố cục map game 2D góc nhìn từ trên xuống <br>&emsp; + Setup collider cho biên map và các khu vực vật cản <br> - Thực hiện logic các chức năng đó | 18/06/2026   | 20/06/2026      | Đang hoàn thiện |
| 8         | - Tìm hiểu về cơ chế Onlline <br> - Tìm hiểu các dịch vụ của AWS cần dùng                                                                                                                                | 21/06/2026   | 21/06/2026      | Hoàn thành      |

### Kết quả đạt được tuần 9:

- Tìm hiểu và nắm được cách xây dựng hệ thống Lobby trong Unity gồm: quy trình tạo phòng, tham gia phòng và quản lý người chơi trước khi bắt đầu trận đấu.
- Tìm kiếm các tài nguyên hình ảnh phù hợp để thiết kế giao diện Lobby, đảm bảo tính trực quan và dễ sử dụng cho người chơi.
- Hoàn thành thiết kế giao diện Lobby với các thành phần chính như vị trí hiển thị nhân vật khi vào phòng, ô Join Room, ô nhập mã phòng, nút Start Game và nút quay về Menu.
- Vẽ và sắp xếp bố cục map game 2D góc nhìn từ trên xuống trong Unity, bao gồm khu vực người chơi có thể di chuyển, vị trí vật thể và đường đi chính.
- Setup collider cho biên map và các khu vực vật cản để nhân vật di chuyển đúng phạm vi, không đi xuyên qua các object bị chặn.
- Xây dựng và triển khai logic cho các chức năng của Lobby, cho phép người chơi nhập mã phòng, tham gia phòng và thực hiện các thao tác cơ bản trên giao diện.
- Tìm hiểu cơ chế hoạt động của game Online, đặc biệt là cách quản lý kết nối giữa nhiều người chơi trong cùng một phòng.
- Nghiên cứu các dịch vụ AWS có thể sử dụng cho dự án, từ đó xác định những dịch vụ phù hợp để hỗ trợ hệ thống Multiplayer và quản lý dữ liệu trong tương lai.
### Công việc vẽ sơ đồ kiến trúc

- Vẽ và chỉnh sửa sơ đồ kiến trúc dự án bằng app.diagrams.net.
- Sắp xếp các AWS services, luồng Unity client, backend components và luồng kết nối multiplayer trong sơ đồ.
