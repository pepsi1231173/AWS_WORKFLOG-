````markdown
---
title: 'Worklog Tuần 2'
date: 2026-04-27
weight: 2
chapter: false
pre: '<b>1.2.</b>'
---

## 🎯 Mục tiêu Tuần 2

- Làm quen với môi trường Unity Engine và quy trình phát triển game cơ bản.
- Tìm hiểu các kiến thức nền tảng về AWS Identity and Access Management (IAM).
- Xây dựng nền tảng để triển khai các dịch vụ liên quan đến Unity trên AWS trong các tuần tiếp theo.

---

## 📅 Kế hoạch & Tiến độ Hằng tuần

| Thứ     | Ngày       | Công việc                                                                                                                                                           | Trạng thái | Ghi chú |
| ------- | ---------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------- | ------- |
| Thứ Hai | 27/04/2026 | - Cài đặt Unity Hub và Unity Editor.<br>- Khám phá giao diện Unity, bao gồm các cửa sổ Scene, Game, Hierarchy và Inspector.                                         | Hoàn thành |         |
| Thứ Ba  | 28/04/2026 | - Tìm hiểu các khái niệm cơ bản của Unity:<br>&nbsp;&nbsp;+ GameObject<br>&nbsp;&nbsp;+ Component<br>&nbsp;&nbsp;+ Transform<br>- Tạo một scene thực hành đơn giản. | Hoàn thành |         |
| Thứ Tư  | 29/04/2026 | - Học lập trình C# trong Unity.<br>- Viết script điều khiển chuyển động của Player.<br>- Tìm hiểu vòng đời thực thi của MonoBehaviour.                              | Hoàn thành |         |
| Thứ Năm | 30/04/2026 | - Tìm hiểu kiến thức cơ bản về AWS IAM.<br>- Nắm được khái niệm Users, User Groups, Roles và Policies.                                                              | Hoàn thành |         |
| Thứ Sáu | 01/05/2026 | - Tạo nhóm quản trị viên IAM.<br>- Cấu hình quyền truy cập.<br>- Thêm người dùng vào nhóm để kiểm tra.                                                              | Hoàn thành |         |

---

## 🔐 Triển khai AWS IAM (Chi tiết)

### Bước 1: Tạo User Group - Mở AWS Management Console

- Điều hướng đến **IAM → User Groups**.
- Chọn **Create group**.
- Tạo một nhóm có tên `AdminGroup`.

### Bước 2: Gắn quyền truy cập

- Gắn chính sách được quản lý sau:
- `AdministratorAccess`

> **Lưu ý:** Quyền này phù hợp cho mục đích học tập và phát triển. Trong môi trường thực tế, nên luôn tuân theo **Nguyên tắc Đặc quyền Tối thiểu (Principle of Least Privilege)**.

👉 **Lưu ý:** Trong môi trường production, nên áp dụng **Principle of Least Privilege**.

---

### Bước 3: Tạo người dùng IAM

- Truy cập **IAM → Users**.
- Chọn **Create user**.
- Bật các phương thức truy cập sau:

* Truy cập AWS Management Console.
* Truy cập lập trình (Programmatic access) cho AWS CLI.

---

### Bước 4: Thêm người dùng vào nhóm

- Thêm người dùng vừa tạo vào `AdminGroup`.
- Xác nhận rằng người dùng được kế thừa quyền từ nhóm.

---

### Bước 5: Cấu hình AWS CLI

Chạy lệnh sau và nhập các thông tin xác thực AWS được yêu cầu:

```bash
aws configure
```
````

```

```
