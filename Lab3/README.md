# BÁO CÁO KẾT QUẢ THỰC HÀNH - LAB 3

## 1. Thông tin sinh viên
* **Họ và tên:** Nguyễn Trầm Hương
* **Mã số sinh viên (MSSV):** 125008066
* **Tên bài Lab:** Lab 3 - Xây dựng ứng dụng Quản lý Khách sạn (Windows Forms & SQL Server)

---

## 2. Môi trường phát triển & Phiên bản (Environment & Versions)
* **Thành phần phát triển:** Windows Forms (.NET Framework / .NET Core)
* **Hệ quản trị cơ sở dữ liệu:** Microsoft SQL Server (2016 trở lên)
* **Công cụ phát triển (IDE):** Visual Studio 2022

---

## 3. Nội dung đã thực hiện (Implemented Features)
* **Khởi tạo và thiết kế CSDL:**
* **Thiết kế giao diện ứng dụng (GUI):**
* **Thiết kế Các biểu mẫu**

## 4. Kết quả đạt được (Results)
* Ứng dụng chạy ổn định, các Form hiển thị đúng bố cục thiết kế.
* Các thiết kế biểu mẫu được thiết kế trong word
* CSDL được khởi tạo chạy đc và kết nối được từ Sql Service

---

## 5. Lỗi gặp phải & Cách khắc phục (Troubleshooting)
 * Tạo thông tin mới không thấy nó hiện thì chờ chút ạ nó hơi chậm
 * nếu cơ sở dữ liệu không kết nối được kiểm tra file App.Config có khi do tên trong cơ sở dữ liệu đã sai
 * Đừng đổi tên thư mục, đổi tên là bên trong biến thành Class hết( này thì em không biết cách khắc phục)

## 6. Hướng dẫn kiểm tra & Chạy lại dự án (Execution Guide)

### Bước 1: Tạo cơ sở dữ liệu 
1. Mở phần mềm **SQL Server Management Studio (SSMS)**.
2. Mở file script `QuanLyKhachSan.sql` trong thư mục dự án.
3. Chọn `Execute` (F5) để khởi tạo CSDL và chèn dữ liệu mẫu.

### Bước 2: Mở và cấu hình dự án
1. Giải nén file `QuanLyKhachSan.zip` (hoặc mở trực tiếp file `.sln`).
2. Mở file giải nén bằng **Visual Studio**.
3. Mở file `App.config` (hoặc lớp xử lý kết nối CSDL) và điều chỉnh lại chuỗi kết nối `Data Source` phù hợp với tên Server SQL trên máy của Thầy/Cô.

### Bước 3: Biên dịch và Chạy (Run Project)
1. Nhấn `Ctrl + Shift + B` để Rebuild Solution.
2. Nhấn `F5` (hoặc nút **Start**) để khởi chạy chương trình.
