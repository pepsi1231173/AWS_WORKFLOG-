---
title: "Thiết lập Amazon GameLift Build và Fleet"
date: 2024-01-01
weight: 10
chapter: false
pre: " <b> 5.10. </b> "
---

#### Mục tiêu

Trong bước này, nhóm thiết lập **Amazon GameLift Servers** để chuẩn bị môi trường chạy dedicated server cho game RoughLife. GameLift được sử dụng trong kiến trúc để quản lý game server, tạo game session và cấp thông tin kết nối cho người chơi.

Mục tiêu của bước này gồm:

- Tích hợp Amazon GameLift Server SDK vào Unity project.
- Build dedicated server cho Linux.
- Upload server build lên Amazon GameLift.
- Tạo Managed EC2 Fleet để chạy server build.
- Cấu hình runtime process, UDP port và instance type cho fleet.
- Kiểm tra giới hạn quota của tài khoản AWS khi tạo fleet.

Trong quá trình thực hiện, nhóm đã upload server build thành công và build chuyển sang trạng thái **Ready**. Tuy nhiên, khi tạo fleet, AWS Console báo lỗi tài khoản hiện tại đã đạt giới hạn fleet bằng 0, nên Managed EC2 Fleet chưa thể được tạo hoàn tất.

---

#### Tích hợp Amazon GameLift Server SDK trong Unity

![Amazon GameLift SDK Unity](/images/5-Workshop/5.10-gamelift-build-fleet/Setup_AWSSDK_Unity.PNG)

Hình trên thể hiện package **Amazon GameLift Server SDK** đã được import vào Unity project. Đây là bước cần thiết để dedicated server có thể giao tiếp với GameLift, báo trạng thái server process và nhận game session từ GameLift.

---

#### Upload server build lên GameLift

![GameLift upload build CLI](/images/5-Workshop/5.10-gamelift-build-fleet/10_01_GameLift_UploadBuild_CLI.png)

Hình trên thể hiện nhóm sử dụng AWS CLI để upload dedicated server build lên Amazon GameLift.

Server build được upload với các thông tin chính:

- Build name: `RoughLifeServer`
- Build version: `0.1.0`
- Operating system: `Amazon Linux 2023`
- Server SDK version: `5.5.0`
- Region: `ap-southeast-1`

Sau khi upload thành công, AWS trả về Build ID. Đây là minh chứng server build đã được đưa lên GameLift để chuẩn bị tạo fleet.

---

#### Kiểm tra trạng thái build

![GameLift build ready](/images/5-Workshop/5.10-gamelift-build-fleet/10_02_GameLift_Build_READY.png)

Hình trên thể hiện build `RoughLifeServer` đã ở trạng thái **Ready**. Điều này chứng minh Amazon GameLift đã nhận và xử lý server build thành công.

---

#### Cấu hình Managed EC2 Fleet

![GameLift create fleet build selected](/images/5-Workshop/5.10-gamelift-build-fleet/10_03_GameLift_CreateFleet_BuildSelected.png)

Hình trên thể hiện bước tạo Managed EC2 Fleet. Nhóm chọn binary type là **Build** và chọn server build `RoughLifeServer` đã upload ở bước trước.

Fleet được đặt tên là `RoughLife-Managed-Dev`, dùng để chạy Unity Dedicated Server trên GameLift Managed EC2.

---

#### Cấu hình instance cho fleet

![GameLift instance details](/images/5-Workshop/5.10-gamelift-build-fleet/10_04_GameLift_InstanceDetails.png)

Hình trên thể hiện phần cấu hình instance cho fleet.

Nhóm chọn:

- Location: `ap-southeast-1`
- Fleet type: `On-Demand`
- Instance type: `c6a.large`
- Architecture: `x86_64`

Việc chọn **On-Demand** thay vì Spot giúp tránh tình trạng server bị gián đoạn do Spot interruption. Đây là lựa chọn phù hợp hơn cho game online khi cần duy trì phiên chơi ổn định.

---

#### Cấu hình runtime process

![GameLift runtime configuration](/images/5-Workshop/5.10-gamelift-build-fleet/10_05_GameLift_RuntimeConfig_OneProcess.png)

Hình trên thể hiện phần cấu hình runtime cho server process.

Thông tin runtime chính:

- Launch path: `/local/game/RoughLifeServer.x86_64`
- Launch parameters: `-port 7777 -logFile /local/game/logs/server.log`
- Concurrent processes: `1`

Cấu hình này cho biết mỗi instance sẽ chạy một server process của RoughLife. Server process sẽ lắng nghe UDP port 7777 để phục vụ gameplay realtime.

---

#### Cấu hình UDP port cho gameplay

![GameLift UDP port settings](/images/5-Workshop/5.10-gamelift-build-fleet/10_06_GameLift_PortSettings_UDP.png)

Hình trên thể hiện cấu hình port cho GameLift fleet.

Thông tin port:

- Protocol: `UDP`
- Port range: `7777`
- IP address range: `0.0.0.0/0`

Port UDP 7777 được sử dụng cho gameplay realtime giữa Unity Client và dedicated server.

---

#### Lỗi quota khi tạo Managed EC2 Fleet

![GameLift fleet quota error](/images/5-Workshop/5.10-gamelift-build-fleet/10_07_GameLift_FleetQuota_Error.png)

Hình trên thể hiện lỗi khi submit tạo fleet. AWS báo rằng giới hạn hiện tại của fleet là 0, nên hệ thống không thể tạo Managed EC2 Fleet.

Điều này có nghĩa là phần cấu hình fleet đã được chuẩn bị, nhưng tài khoản AWS hiện tại chưa được cấp quota để tạo fleet trong region đang sử dụng.

---

#### Kiểm tra Service Quotas

![Service quotas GameLift fleet](/images/5-Workshop/5.10-gamelift-build-fleet/10_08_ServiceQuotas_GameLift_ManagedEC2Fleets_0.png)

Hình trên thể hiện trang **Service Quotas** cho Amazon GameLift Servers. Nhóm kiểm tra quota liên quan đến Managed EC2 fleets per region để xác nhận nguyên nhân lỗi.

---

#### Gửi request tăng quota

![Service quota increase request](/images/5-Workshop/5.10-gamelift-build-fleet/10_09_ServiceQuota_Increase_Request.png)

Hình trên thể hiện nhóm đã mở form request tăng quota cho Managed EC2 fleets. Đây là bước cần thiết để AWS xem xét và cấp quyền tạo fleet cho tài khoản.

---

#### Thử phương án GameLift Anywhere

![GameLift custom location](/images/5-Workshop/5.10-gamelift-build-fleet/10A_01_GameLift_CustomLocation.png)

Hình trên thể hiện nhóm đã tạo custom location `custom-roughlife-home-lab` trong GameLift Anywhere. GameLift Anywhere được dùng để đăng ký server chạy ngoài hạ tầng GameLift Managed EC2, ví dụ server local hoặc máy lab.

![GameLift Anywhere quota error](/images/5-Workshop/5.10-gamelift-build-fleet/10A_02_GameLift_FleetQuota_Error.png)

Tuy nhiên, khi tạo Anywhere fleet, AWS vẫn báo lỗi giới hạn fleet bằng 0. Vì vậy, phương án GameLift Anywhere cũng chưa thể hoàn tất trong tài khoản hiện tại.

---

#### Kết quả

Sau bước này, nhóm đã hoàn thành các phần quan trọng của quá trình chuẩn bị GameLift:

- Đã tích hợp Amazon GameLift Server SDK vào Unity.
- Đã build dedicated server cho Linux.
- Đã upload server build lên Amazon GameLift bằng AWS CLI.
- Build `RoughLifeServer` đã ở trạng thái **Ready**.
- Đã cấu hình Managed EC2 Fleet với build, instance type, runtime process và UDP port.
- Đã phát hiện giới hạn quota của tài khoản AWS khiến fleet chưa thể tạo.
- Đã kiểm tra Service Quotas và gửi request tăng quota.
- Đã thử GameLift Anywhere nhưng cũng bị chặn bởi giới hạn fleet.

Do giới hạn quota của AWS account, nhóm chưa thể tạo fleet thật ở thời điểm hiện tại. Tuy nhiên, các minh chứng trên cho thấy server build đã sẵn sàng để triển khai lên GameLift khi quota được AWS cấp.