-- 1. Tạo cơ sở dữ liệu nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'QuanLyChoThueVanPhong')
BEGIN
    CREATE DATABASE QuanLyChoThueVanPhong;
END;
GO

-- 2. Chuyển ngữ cảnh sang database vừa tạo
USE QuanLyChoThueVanPhong;
GO

-- 3. Tạo các bảng (Tables)
CREATE TABLE HopDong (
    SoHopDong VARCHAR(50) PRIMARY KEY,
    NgayLapHopDong DATE,
    NoiDungHopDong TEXT
);

CREATE TABLE CongTy (
    MaCongTy VARCHAR(50) PRIMARY KEY,
    TenCongTy NVARCHAR(100),
    DiaChiCongTy NVARCHAR(255),
    SdtCongTy VARCHAR(20),
    SoHopDong VARCHAR(50),
    FOREIGN KEY (SoHopDong) REFERENCES HopDong(SoHopDong)
);

CREATE TABLE MucGia (
    Tang INT,
    DienTich FLOAT,
    GiaCa DECIMAL(18, 2),
    PRIMARY KEY (Tang, DienTich)
);

CREATE TABLE Phong (
    MaPhong VARCHAR(50) PRIMARY KEY,
    Tang INT,
    DienTich FLOAT,
    FOREIGN KEY (Tang, DienTich) REFERENCES MucGia(Tang, DienTich)
);

CREATE TABLE NhanVien (
    MSNV VARCHAR(50) PRIMARY KEY,
    TenNV NVARCHAR(100),
    Phai NVARCHAR(10),
    DiaChiNV NVARCHAR(255),
    SdtNV VARCHAR(20),
    ChucVu NVARCHAR(50),
    MaPhong VARCHAR(50),
    MaCongTy VARCHAR(50),
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong),
    FOREIGN KEY (MaCongTy) REFERENCES CongTy(MaCongTy)
);

CREATE TABLE ChiTietHopDong (
    SoHopDong VARCHAR(50),
    MaPhong VARCHAR(50),
    ThoiHan INT,
    PRIMARY KEY (SoHopDong, MaPhong),
    FOREIGN KEY (SoHopDong) REFERENCES HopDong(SoHopDong),
    FOREIGN KEY (MaPhong) REFERENCES Phong(MaPhong)
);

CREATE TABLE PhieuGiaHan (
    SoPhieuGiaHan VARCHAR(50) PRIMARY KEY,
    NgayLapPhieuGiaHan DATE,
    NgayHetHan DATE,
    SoHopDong VARCHAR(50),
    MaPhong VARCHAR(50),
    FOREIGN KEY (SoHopDong, MaPhong) REFERENCES ChiTietHopDong(SoHopDong, MaPhong)
);

CREATE TABLE DichVu (
    MaDichVu VARCHAR(50) PRIMARY KEY,
    TenDichVu NVARCHAR(100),
    QuyCach NVARCHAR(100)
);

CREATE TABLE HoaDon (
    SoHoaDon VARCHAR(50) PRIMARY KEY,
    NgayLapHoaDon DATE,
    SoLuongDichVu INT,
    SoHopDong VARCHAR(50),
    MaPhong VARCHAR(50),
    MaDichVu VARCHAR(50),
    FOREIGN KEY (SoHopDong, MaPhong) REFERENCES ChiTietHopDong(SoHopDong, MaPhong),
    FOREIGN KEY (MaDichVu) REFERENCES DichVu(MaDichVu)
);
GO

-- 4. Insert dữ liệu mẫu
INSERT INTO HopDong (SoHopDong, NgayLapHopDong, NoiDungHopDong) VALUES
('HD001', '2026-01-15', 'Hợp đồng thuê văn phòng tầng 2 và tầng 3 thời hạn 12 tháng'),
('HD002', '2026-02-01', 'Hợp đồng thuê văn phòng tầng 5 thời hạn 6 tháng');

INSERT INTO CongTy (MaCongTy, TenCongTy, DiaChiCongTy, SdtCongTy, SoHopDong) VALUES
('CTY01', N'Công ty Cổ phần Công nghệ ABC', N'Tòa nhà Cao ốc, Quận 1, TP.HCM', '0901234567', 'HD001'),
('CTY02', N'Công ty TNHH Giải pháp Phần mềm XYZ', N'Tòa nhà Cao ốc, Quận 1, TP.HCM', '0908765432', 'HD002');

INSERT INTO MucGia (Tang, DienTich, GiaCa) VALUES
(2, 50.0, 15000000.00),
(3, 80.0, 24000000.00),
(5, 100.0, 35000000.00);

INSERT INTO Phong (MaPhong, Tang, DienTich) VALUES
('P201', 2, 50.0),
('P301', 3, 80.0),
('P501', 5, 100.0);

INSERT INTO NhanVien (MSNV, TenNV, Phai, DiaChiNV, SdtNV, ChucVu, MaPhong, MaCongTy) VALUES
('NV001', N'Nguyễn Văn A', N'Nam', N'TP.HCM', '0911111111', N'Giám đốc', 'P201', 'CTY01'),
('NV002', N'Trần Thị B', N'Nữ', N'TP.HCM', '0922222222', N'Lập trình viên', 'P201', 'CTY01'),
('NV003', N'Lê Văn C', N'Nam', N'Đồng Nai', '0933333333', N'Trưởng phòng', 'P501', 'CTY02');

INSERT INTO ChiTietHopDong (SoHopDong, MaPhong, ThoiHan) VALUES
('HD001', 'P201', 12),
('HD001', 'P301', 12),
('HD002', 'P501', 6);

INSERT INTO PhieuGiaHan (SoPhieuGiaHan, NgayLapPhieuGiaHan, NgayHetHan, SoHopDong, MaPhong) VALUES
('PGH01', '2027-01-10', '2027-07-15', 'HD001', 'P201');

INSERT INTO DichVu (MaDichVu, TenDichVu, QuyCach) VALUES
('DV01', N'Điện', N'kWh'),
('DV02', N'Nước', N'm3'),
('DV03', N'Internet', N'Mbps');

INSERT INTO HoaDon (SoHoaDon, NgayLapHoaDon, SoLuongDichVu, SoHopDong, MaPhong, MaDichVu) VALUES
('HDV01', '2026-02-28', 150, 'HD001', 'P201', 'DV01'),
('HDV02', '2026-02-28', 20, 'HD001', 'P201', 'DV02'),
('HDV03', '2026-02-28', 1, 'HD001', 'P201', 'DV03');