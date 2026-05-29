title: "Worklog Tuần 2"
date: 2026-04-27
weight: 2
chapter: false
pre: "<b>1.2.</b>"

---

## 🎯 Mục tiêu tuần 2

- Làm quen với Unity Engine và workflow phát triển game
- Hiểu AWS IAM và quản lý phân quyền
- Chuẩn bị nền tảng để deploy hệ thống game lên AWS

---

## 📅 Kế hoạch & Tracking

| Thứ | Ngày       | Công việc                                                                                              | Trạng thái      | Ghi chú |
| --- | ---------- | ------------------------------------------------------------------------------------------------------ | --------------- | ------- |
| 2   | 27/04/2026 | - Cài Unity Hub & Unity Editor <br> - Làm quen giao diện Unity                                         | HOÀN THÀNH      |         |
| 3   | 28/04/2026 | - Tìm hiểu Unity cơ bản: <br> + GameObject <br> + Component <br> + Transform <br> - Tạo scene đơn giản | HOÀN THÀNH      |         |
| 4   | 29/04/2026 | - Lập trình C# trong Unity <br> - Tạo script di chuyển nhân vật <br> - Hiểu vòng đời MonoBehaviour     | HOÀN THÀNH      |         |
| 5   | 30/04/2026 | - Tìm hiểu AWS IAM <br> - Hiểu User, Group, Role, Policy                                               | HOÀN THÀNH      |         |
| 6   | 01/05/2026 | - Thực hành: Tạo IAM Group <br> - Gán quyền <br> - Thêm user vào group                                 | CHƯA HOÀN THÀNH |         |

---

## 🔐 Triển khai AWS IAM (Chi tiết)

### Bước 1: Tạo IAM Group

- Truy cập AWS Console → IAM → **User Groups**
- Chọn **Create group**
- Tên group: `AdminGroup`

---

### Bước 2: Gán quyền

- Gắn policy:
  - `AdministratorAccess` (dùng cho giai đoạn development)

👉 Lưu ý: Production nên áp dụng **Least Privilege**

---

### Bước 3: Tạo IAM User

- Vào IAM → Users → Create user
- Bật:
  - Console access
  - Programmatic access

---

### Bước 4: Gán User vào Group

- Add user vào `AdminGroup`
- Kiểm tra quyền kế thừa

---

### Bước 5: Cấu hình AWS CLI

```bash
aws configure
```
