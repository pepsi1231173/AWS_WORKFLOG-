---
title: 'Giới thiệu'
date: 2024-08-07
weight: 1
chapter: false
pre: ' <b> 5.1. </b> '
---

#### Giới thiệu về dự án game Rough Life

- Rough Life là một dự án game 2D top-down thuộc thể loại hành động phiêu lưu, tập trung vào cơ chế chiến đấu với quái và boss trong nhiều khu vực khác nhau. Game được xây dựng bằng Unity, sử dụng ngôn ngữ C# và phát triển theo hướng hỗ trợ cả chế độ chơi offline lẫn online co-op nhiều người chơi.

- Trong game, người chơi sẽ điều khiển nhân vật di chuyển trong bản đồ, nhặt vũ khí, sử dụng các kỹ năng chiến đấu và tiến vào các phòng boss để vượt qua thử thách. Mỗi loại vũ khí trong Rough Life có cơ chế sử dụng riêng, trong đó chuột trái thường dùng cho đòn đánh chính, còn chuột phải dùng cho kỹ năng phụ. Một số vũ khí tiêu biểu có thể kể đến như Sword, Bow, Staff và Spear, mỗi loại đều được thiết kế với phong cách tấn công và kỹ năng khác nhau.

- Điểm nổi bật của Rough Life là hệ thống boss fight. Người chơi có thể tiến vào các phòng boss như Phoenix, Slime, Centaur và các boss khác để chiến đấu. Mỗi boss có cơ chế riêng, thanh máu riêng, hiệu ứng âm thanh, nhạc nền và phần thưởng sau khi bị đánh bại. Khi boss chết, game có thể sinh ra phần thưởng như vũ khí nâng cấp để người chơi tiếp tục phát triển sức mạnh.

- Về phần online, Rough Life được phát triển theo mô hình co-op tối đa 4 người chơi. Người chơi có thể tạo phòng, tham gia phòng và cùng nhau chiến đấu trong thời gian thực. Hệ thống online sử dụng Unity Netcode để đồng bộ nhân vật, vũ khí, nhặt item, trạng thái chiến đấu và các tương tác trong game. Ngoài ra, game còn có các hệ thống hỗ trợ như UI hiển thị vũ khí đang dùng, bảng mô tả vũ khí khi đi gần item, cơ chế chết/hồi sinh và chuyển cảnh giữa Lobby với phòng boss.

#### Video demo

[Mở video demo Rough Life](https://drive.google.com/file/d/1JuW5662_Hs_NfhDf037MAqUaIq6pE8v7/view?usp=sharing)

#### Tổng quan về dự án game Rough Life

**1 Menu**
Menu có các nút chức năng cơ bản gồm: Online, Offline, Setting và Exit. Người chơi có thể chọn Offline để bắt đầu chơi một mình, chọn Online để tham gia chế độ nhiều người chơi, vào Setting để điều chỉnh âm thanh hoặc chọn Exit để thoát game.

![overview](/images/5-Workshop/5.1-Workshop-overview/Menu.jpg)

**2 Cơ chế Offline**
**2.1 Map Lobby Offline**

- Sau khi người chơi chọn chế độ Offline từ menu chính, game sẽ chuyển sang khu vực Map Lobby. Đây là khu vực chờ chính của chế độ chơi đơn, nơi người chơi có thể di chuyển tự do, làm quen với giao diện và chuẩn bị trước khi bước vào các màn đánh boss.

- Trong Map Lobby, người chơi có thể nhặt các loại vũ khí được đặt trên bản đồ. Khi nhân vật đi gần vũ khí, hệ thống sẽ hiển thị bảng mô tả gồm tên vũ khí, biểu tượng và thông tin cơ bản của vũ khí đó. Sau khi nhặt vũ khí, giao diện kỹ năng ở góc màn hình sẽ được cập nhật để hiển thị kỹ năng chuột trái và chuột phải tương ứng với vũ khí đang sử dụng.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Maplobby.jpg)
  Ngoài ra, Map Lobby còn là nơi người chơi lựa chọn các màn boss. Người chơi có thể tiếp cận khu vực chọn boss để xem thông tin màn chơi, sau đó nhấn phím tương tác để vào phòng boss tương ứng.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Maplobby1.jpg)
  **2.2. Map Boss Minotaur**
- Map Boss Minotaur là màn boss được thiết kế theo hướng chiến đấu với một sinh vật giống con trâu cầm cây rìu và khả năng tấn công với lượng dame vừa.

- Khi vào phòng boss, người chơi sẽ chiến đấu trực tiếp với Minotaur. Boss có kích thước lớn, tạo cảm giác áp lực cho người chơi trong quá trình chiến đấu. Trong màn này, người chơi sử dụng vũ khí đã chọn từ Lobby để tấn công boss, né tránh đòn đánh và cố gắng hạ máu boss về 0. Nếu người chơi bị boss đánh bại, hệ thống sẽ đưa người chơi quay trở lại Map Lobby. Khi tiêu diệt xong boss thì sẽ xuất hiện các vũ khí nâng cấp.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/MapBoss1.jpg)
  **2.3. Map Boss Phoenix**

- Map Boss Phoenix là màn boss được thiết kế theo hướng chiến đấu với một sinh vật có phong cách lửa và khả năng tấn công linh hoạt với lượng sát thương cao.

- Trong trận chiến, người chơi cần sử dụng kỹ năng di chuyển và vũ khí để né tránh các đòn đánh của Phoenix. Boss Phoenix có thể được thiết kế với các kỹ năng diện rộng, hiệu ứng lửa hoặc các pha tấn công nhanh, tạo nên sự khác biệt và khó khăn hơn so với boss Minotaur.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Mapphonix.jpg)

**3 Cơ chế online**
**3.1. Lobby Scene Online**

- Khi người chơi chọn chế độ Online từ menu chính, game sẽ chuyển sang giao diện Lobby Scene Online. Tại đây, người chơi cần nhập tên nhân vật trước khi tham gia phòng chơi. Sau khi tạo phòng và ấn nút online, hệ thống sẽ sinh ra một mã phòng riêng để người chơi khác có thể dùng mã này tham gia.

- Lobby Online hỗ trợ hai chế độ phòng là Public và Private. Với phòng Public, những người chơi khác có thể nhìn thấy phòng trong danh sách và tham gia trực tiếp. Với phòng Private, người chơi cần nhập đúng mã phòng để có thể vào. Cơ chế này giúp người chơi linh hoạt hơn trong việc tạo phòng chơi công khai hoặc chơi riêng với bạn bè.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Lobbyscene.jpg)

**3.2. Danh sách phòng Public**

- Khi một người chơi tạo phòng và đặt phòng ở chế độ Public, phòng đó sẽ được hiển thị trong danh sách phòng. Người chơi khác có thể nhấn nút Enter Room để xem các phòng đang mở và chọn phòng muốn tham gia.

- Trong danh sách phòng, hệ thống hiển thị các thông tin cơ bản như tên phòng, trạng thái phòng và số lượng người chơi hiện tại. Mỗi phòng hỗ trợ tối đa 4 người chơi, phù hợp với cơ chế online co-op của game Rough Life.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Public.jpg)

**3.3. Tham gia phòng bằng mã Code**

- Ngoài việc tham gia phòng Public, người chơi cũng có thể nhập mã phòng để vào trực tiếp một phòng cụ thể. Cơ chế này phù hợp với các phòng Private hoặc khi người chơi muốn mời bạn bè vào đúng phòng đã tạo.

- Sau khi nhập đúng mã phòng và nhấn Join, người chơi sẽ được đưa vào phòng chờ online. Trong phòng này, hệ thống sẽ hiển thị danh sách các người chơi đã tham gia, bao gồm Host và các Client khác. Khi đủ người hoặc Host muốn bắt đầu, Host có thể nhấn Start Game để chuyển tất cả người chơi vào Map Lobby Online.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Online.jpg)
  **3.4. Map Lobby Online**

- Sau khi Host bắt đầu game, tất cả người chơi trong phòng sẽ được chuyển vào Map Lobby Online. Đây là khu vực chờ chung của chế độ online, nơi tối đa 4 người chơi có thể xuất hiện cùng lúc và chuẩn bị trước khi vào phòng boss.

- Trong Map Lobby Online, người chơi có thể di chuyển, quan sát các người chơi khác, nhặt vũ khí và chuẩn bị kỹ năng chiến đấu. Các vũ khí trên bản đồ được đồng bộ giữa các người chơi, giúp mọi người cùng nhìn thấy trạng thái vũ khí sau khi có người nhặt hoặc thay đổi vũ khí.

- Map Lobby Online cũng là nơi nhóm người chơi tập hợp trước khi tiến vào các màn boss. Việc có nhiều người chơi cùng xuất hiện trong một khu vực giúp tạo cảm giác co-op rõ ràng hơn so với chế độ Offline.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Maplobbyonline.jpg)
  **3.5. Chiến đấu Boss trong chế độ Online**

- Khi người chơi tiến vào màn boss, cả nhóm sẽ cùng tham gia chiến đấu với boss trong cùng một bản đồ. Trong chế độ Online, game đồng bộ vị trí nhân vật, trạng thái chiến đấu, vũ khí và các tương tác quan trọng để nhiều người chơi có thể phối hợp với nhau.

- Mỗi người chơi có thể sử dụng vũ khí đã chọn để tấn công boss. Cơ chế chiến đấu vẫn giữ nguyên như chế độ Offline, trong đó chuột trái dùng cho đòn đánh chính và chuột phải dùng cho kỹ năng phụ. Tuy nhiên, trong chế độ Online, các hành động như di chuyển, nhặt vũ khí và chiến đấu cần được đồng bộ để các người chơi đều nhìn thấy cùng một trạng thái trong trận đấu.

- Khi người chơi bị hạ gục, hệ thống sẽ xử lý trạng thái chết hoặc chờ hồi sinh tùy theo cơ chế của màn chơi. Nếu toàn bộ người chơi đều thất bại, nhóm sẽ được đưa trở lại Lobby. Nếu chiến thắng sẽ rớt vũ khí nâng cấp và có thể qua màn boss tiếp theo.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Mapbossonline.jpg)
  **4 Hệ thống Setting**

- Hệ thống Setting được thiết kế để người chơi có thể điều chỉnh âm thanh trong quá trình chơi. Người chơi có thể mở bảng Setting bằng nút ở góc phải màn hình ở mỗi màn, sau đó thay đổi âm lượng của Music và SFX thông qua các thanh trượt.

- Phần Music dùng để điều chỉnh âm lượng nhạc nền của game, bao gồm nhạc ở menu, lobby và các màn boss. - Phần SFX dùng để điều chỉnh âm lượng hiệu ứng âm thanh như tiếng đánh, tiếng kỹ năng, tiếng khi click.

- Giao diện Setting được thiết kế đơn giản, dễ nhìn và có nút đóng để người chơi quay lại màn chơi hiện tại. Nhờ hệ thống này, người chơi có thể tùy chỉnh trải nghiệm âm thanh theo ý muốn mà không cần phải thoát game.
  ![overview](/images/5-Workshop/5.1-Workshop-overview/Setting.jpg)
