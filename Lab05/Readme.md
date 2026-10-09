# Báo cáo Bài Lab 05 - OOSD

## 1. Thông tin sinh viên
* **Họ và tên:** Nguyễn Trâm Hương
* **Mã số sinh viên (MSSV):** 1250080066
* **Tên bài Lab:** Lab 5 - Xây dựng ứng dụng Quản lý Công ty Du lịch (Windows Forms & SQL Server)

## 2. Môi trường phát triển & Phiên bản (Environment & Versions)
* **Thành phần phát triển:** Windows Forms (.NET Framework / .NET Core)
* **Hệ quản trị cơ sở dữ liệu:** Microsoft SQL Server (2016 trở lên)
* **Công cụ phát triển (IDE):** Visual Studio 2022

## 3. Danh sách các tệp tin nộp bài (Files Included)
* `NguyenTramHuong_1250080066_Lab05.docx`: Tài liệu báo cáo chi tiết quá trình thực hiện bài Lab 05.
* `QuanLyCongTyDuLich.zip`: Mã nguồn (Source Code) của dự án ứng dụng Quản lý Công ty Du lịch.
* `SodoLab05.drawio`: Sơ đồ thiết kế hệ thống / UML / ERD của bài Lab.
* `SQLQuanLyCongTyDuLich.sql`: Tệp lệnh script khởi tạo và tạo dữ liệu mẫu cho cơ sở dữ liệu trên SQL Server.

## 4. Hướng dẫn kiểm tra & Chạy lại dự án (Execution Guide)

### Bước 1: Tạo cơ sở dữ liệu
1. Mở phần mềm SQL Server Management Studio (SSMS).
2. Mở file script `SQLQuanLyCongTyDuLich.sql` có trong thư mục.
3. Nhấn `Execute` (F5) để chạy script tạo cơ sở dữ liệu và dữ liệu mẫu.

### Bước 2: Mở và cấu hình dự án
1. Giải nén file `QuanLyCongTyDuLich.zip`.
2. Mở dự án bằng phần mềm Visual Studio.
3. Kiểm tra file cấu hình (như `App.config`) và cập nhật lại chuỗi kết nối (`Data Source`) cho phù hợp với thông tin kết nối SQL Server trên máy của bạn.

### Bước 3: Biên dịch và Chạy (Run Project)
1. Nhấn `Ctrl + Shift + B` để Rebuild Solution.
2. Nhấn `F5` (hoặc nút Start trên thanh công cụ) để chạy ứng dụng.
