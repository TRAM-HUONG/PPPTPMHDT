-- ==========================================================
-- ĐỀ TÀI: QUẢN LÝ HỒ SƠ BỆNH ÁN CỦA BỆNH NHÂN
-- SCRIPT TẠO DATABASE VÀ CHÈN DỮ LIỆU MẪU
-- ==========================================================

-- Xóa cơ sở dữ liệu cũ nếu đã tồn tại (nếu dùng MySQL/SQL Server)
-- DROP DATABASE IF EXISTS QuanLyHoSoBenhAn;
-- CREATE DATABASE QuanLyHoSoBenhAn;
-- USE QuanLyHoSoBenhAn;

-- ==========================================================
-- ĐỀ TÀI: QUẢN LÝ HỒ SƠ BỆNH ÁN CỦA BỆNH NHÂN
-- SCRIPT HOÀN CHỈNH: XÓA, TẠO CSDL VÀ CHÈN DỮ LIỆU MẪU (SQL SERVER)
-- ==========================================================

-- 1. XÓA AN TOÀN CÁC BẢNG CŨ (Từ bảng con đến bảng cha)
IF OBJECT_ID('HoaDon', 'U') IS NOT NULL DROP TABLE HoaDon;
IF OBJECT_ID('ChiTietToaThuoc', 'U') IS NOT NULL DROP TABLE ChiTietToaThuoc;
IF OBJECT_ID('ToaThuoc', 'U') IS NOT NULL DROP TABLE ToaThuoc;
IF OBJECT_ID('XetNghiem', 'U') IS NOT NULL DROP TABLE XetNghiem;
IF OBJECT_ID('Thuoc', 'U') IS NOT NULL DROP TABLE Thuoc;
IF OBJECT_ID('PhieuKhamBenh', 'U') IS NOT NULL DROP TABLE PhieuKhamBenh;
IF OBJECT_ID('BacSi', 'U') IS NOT NULL DROP TABLE BacSi;
IF OBJECT_ID('KhoaDieuTri', 'U') IS NOT NULL DROP TABLE KhoaDieuTri;
IF OBJECT_ID('HoSoBenhAn', 'U') IS NOT NULL DROP TABLE HoSoBenhAn;
IF OBJECT_ID('BenhNhan', 'U') IS NOT NULL DROP TABLE BenhNhan;


-- ==========================================
-- 2. TẠO CÁC BẢNG MỚI (CHUẨN 3NF)
-- ==========================================

-- Bảng Bệnh Nhân
CREATE TABLE BenhNhan (
    MaBenhNhan VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    NgaySinh DATE,
    DienThoai VARCHAR(15),
    Anh3x4 VARCHAR(255)
);

-- Bảng Hồ Sơ Bệnh Án
CREATE TABLE HoSoBenhAn (
    MaHoSo VARCHAR(20) PRIMARY KEY,
    MaBenhNhan VARCHAR(20) NOT NULL,
    NgayLap DATETIME NOT NULL,
    TrangThaiLePhi NVARCHAR(50) DEFAULT N'Đã đóng',
    CONSTRAINT FK_HoSo_BenhNhan FOREIGN KEY (MaBenhNhan) REFERENCES BenhNhan(MaBenhNhan)
);

-- Bảng Khoa Điều Trị
CREATE TABLE KhoaDieuTri (
    MaKhoa VARCHAR(20) PRIMARY KEY,
    TenKhoa NVARCHAR(100) NOT NULL
);

-- Bảng Bác Sĩ
CREATE TABLE BacSi (
    MaBacSi VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    ChuyenKhoa NVARCHAR(100),
    MaKhoa VARCHAR(20) NOT NULL,
    CONSTRAINT FK_BacSi_Khoa FOREIGN KEY (MaKhoa) REFERENCES KhoaDieuTri(MaKhoa)
);

-- Bảng Phiếu Khám Bệnh
CREATE TABLE PhieuKhamBenh (
    MaPhieuKham VARCHAR(20) PRIMARY KEY,
    MaHoSo VARCHAR(20) NOT NULL,
    MaBacSi VARCHAR(20) NOT NULL,
    NgayGioKham DATETIME NOT NULL,
    TrieuChung NVARCHAR(500),
    LoaiKham NVARCHAR(50),
    CONSTRAINT FK_PhieuKham_HoSo FOREIGN KEY (MaHoSo) REFERENCES HoSoBenhAn(MaHoSo),
    CONSTRAINT FK_PhieuKham_BacSi FOREIGN KEY (MaBacSi) REFERENCES BacSi(MaBacSi)
);

-- Bảng Xét Nghiệm
CREATE TABLE XetNghiem (
    MaXetNghiem VARCHAR(20) PRIMARY KEY,
    MaPhieuKham VARCHAR(20) NOT NULL,
    TenXetNghiem NVARCHAR(150) NOT NULL,
    KetQua NVARCHAR(MAX),
    NgayXetNghiem DATETIME,
    CONSTRAINT FK_XetNghiem_PhieuKham FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKhamBenh(MaPhieuKham)
);

-- Bảng Danh Mục Thuốc (Kho thuốc bệnh viện)
CREATE TABLE Thuoc (
    MaThuoc VARCHAR(20) PRIMARY KEY,
    TenThuoc NVARCHAR(150) NOT NULL,
    DonViTinh NVARCHAR(50),
    DonGia DECIMAL(18,2) NOT NULL,
    SoLuongTon INT NOT NULL
);

-- Bảng Toa Thuốc
CREATE TABLE ToaThuoc (
    MaToaThuoc VARCHAR(20) PRIMARY KEY,
    MaPhieuKham VARCHAR(20) NOT NULL UNIQUE, 
    NgayLap DATETIME NOT NULL,
    LoiDan NVARCHAR(500),
    CONSTRAINT FK_ToaThuoc_PhieuKham FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKhamBenh(MaPhieuKham)
);

-- Bảng Chi Tiết Toa Thuốc (Liên kết trực tiếp với bảng Thuoc)
CREATE TABLE ChiTietToaThuoc (
    MaChiTiet VARCHAR(20) PRIMARY KEY,
    MaToaThuoc VARCHAR(20) NOT NULL,
    MaThuoc VARCHAR(20) NOT NULL,
    SoLuong INT NOT NULL,
    LieuDung NVARCHAR(200) NOT NULL,
    CONSTRAINT FK_ChiTiet_ToaThuoc FOREIGN KEY (MaToaThuoc) REFERENCES ToaThuoc(MaToaThuoc),
    CONSTRAINT FK_ChiTiet_Thuoc FOREIGN KEY (MaThuoc) REFERENCES Thuoc(MaThuoc)
);

-- Bảng Hóa Đơn Viện Phí
CREATE TABLE HoaDon (
    MaHoaDon VARCHAR(20) PRIMARY KEY,
    MaPhieuKham VARCHAR(20) NOT NULL UNIQUE,
    NgayThanhToan DATETIME,
    TongTien DECIMAL(18,2) NOT NULL,
    TrangThai NVARCHAR(50) DEFAULT N'Đã thanh toán',
    CONSTRAINT FK_HoaDon_PhieuKham FOREIGN KEY (MaPhieuKham) REFERENCES PhieuKhamBenh(MaPhieuKham)
);


-- ==========================================
-- 3. CHÈN DỮ LIỆU MẪU (INSERT)
-- ==========================================

-- Khoa Điều Trị
INSERT INTO KhoaDieuTri (MaKhoa, TenKhoa) VALUES 
('K_NOI', N'Khoa Nội Tổng Quát'),
('K_NGOI', N'Khoa Ngoại Tổng Quát'),
('K_KHAM', N'Khoa Khám Bệnh & Cấp Cứu');

-- Bác Sĩ
INSERT INTO BacSi (MaBacSi, HoTen, ChuyenKhoa, MaKhoa) VALUES 
('BS01', N'Dr. Nguyễn Văn An', N'Nội tổng quát', 'K_NOI'),
('BS02', N'Dr. Trần Thị Bình', N'Tim mạch', 'K_NOI'),
('BS03', N'Dr. Lê Hoàng Long', N'Ngoại thần kinh', 'K_NGOI');

-- Bệnh Nhân
INSERT INTO BenhNhan (MaBenhNhan, HoTen, DiaChi, NgaySinh, DienThoai, Anh3x4) VALUES 
('BN001', N'Nguyễn Văn Hùng', N'123 Nguyễn Trãi, Quận 5, TP.HCM', '1990-05-15', '0901234567', 'bn001.jpg'),
('BN002', N'Lê Thị Mai', N'45 Lê Lợi, Quận 1, TP.HCM', '1985-10-20', '0918765432', 'bn002.jpg');

-- Hồ Sơ Bệnh Án
INSERT INTO HoSoBenhAn (MaHoSo, MaBenhNhan, NgayLap, TrangThaiLePhi) VALUES 
('HS001', 'BN001', '2026-01-10 08:00:00', N'Đã đóng'),
('HS002', 'BN002', '2026-02-12 09:30:00', N'Chưa thanh toán ');

-- Phiếu Khám Bệnh
INSERT INTO PhieuKhamBenh (MaPhieuKham, MaHoSo, MaBacSi, NgayGioKham, TrieuChung, LoaiKham) VALUES 
('PK001', 'HS001', 'BS01', '2026-10-20 08:30:00', N'Sốt cao, đau họng, nhức đầu', N'Khám thường'),
('PK002', 'HS002', 'BS02', '2026-10-21 10:00:00', N'Đau tức ngực nhẹ, khó thở khi vận động', N'Khám định kỳ');

-- Xét Nghiệm
INSERT INTO XetNghiem (MaXetNghiem, MaPhieuKham, TenXetNghiem, KetQua, NgayXetNghiem) VALUES 
('XN001', 'PK001', N'Xét nghiệm máu tổng quát', N'Bạch cầu tăng nhẹ', '2026-10-20 09:00:00'),
('XN002', 'PK002', N'Điện tâm đồ (ECG)', N'Nhịp tim ổn định, không có bất thường', '2026-10-21 10:30:00');

-- Danh Mục Thuốc
INSERT INTO Thuoc (MaThuoc, TenThuoc, DonViTinh, DonGia, SoLuongTon) VALUES 
('T01', N'Paracetamol 500mg', N'Viên', 2500.00, 1000),
('T02', N'Amoxicillin 500mg', N'Viên', 5000.00, 500),
('T03', N'Aspirin 81mg', N'Viên', 3000.00, 800);

-- Toa Thuốc
INSERT INTO ToaThuoc (MaToaThuoc, MaPhieuKham, NgayLap, LoiDan) VALUES 
('TT001', 'PK001', '2026-10-20 09:30:00', N'Uống nhiều nước, tái khám sau 5 ngày nếu không giảm sốt.'),
('TT002', 'PK002', '2026-10-21 11:00:00', N'Nghỉ ngơi điều độ, hạn chế sử dụng chất kích thích.');

-- Chi Tiết Toa Thuốc
INSERT INTO ChiTietToaThuoc (MaChiTiet, MaToaThuoc, MaThuoc, SoLuong, LieuDung) VALUES 
('CT01', 'TT001', 'T01', 20, N'Sáng 1 viên, Chiều 1 viên (sau ăn)'),
('CT02', 'TT001', 'T02', 14, N'Sáng 1 viên, Chiều 1 viên'),
('CT03', 'TT002', 'T03', 30, N'Uống 1 viên mỗi ngày sau bữa sáng');

-- Hóa Đơn Viện Phí
INSERT INTO HoaDon (MaHoaDon, MaPhieuKham, NgayThanhToan, TongTien, TrangThai) VALUES 
('HD001', 'PK001', '2026-10-20 10:00:00', 350000.00, N'Đã thanh toán'),
('HD002', 'PK002', '2026-10-21 11:30:00', 500000.00, N'Đã thanh toán');
