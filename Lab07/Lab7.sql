-- Kiểm tra và xóa Database cũ nếu đã tồn tại để làm mới an toàn
USE master;
GO

IF EXISTS (SELECT * FROM sys.databases WHERE name = 'QL_NhanSu_SonDongA')
BEGIN
    ALTER DATABASE QL_NhanSu_SonDongA SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE QL_NhanSu_SonDongA;
END
GO

-- Tạo mới Cơ sở dữ liệu
CREATE DATABASE QL_NhanSu_SonDongA;
GO

USE QL_NhanSu_SonDongA;
GO

--------------------------------------------------------------------------------
-- 1. TẠO CÁC BẢNG (TABLES)
--------------------------------------------------------------------------------

-- Bảng Phòng Ban
CREATE TABLE PhongBan (
    MaPhongBan VARCHAR(20) PRIMARY KEY,
    TenPhongBan NVARCHAR(100) NOT NULL,
    DienThoaiPhongBan VARCHAR(20)
);

-- Bảng Nhân Viên
CREATE TABLE NhanVien (
    MaNV VARCHAR(20) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    Phai NVARCHAR(10),
    NgaySinh DATE,
    DiaChiNV NVARCHAR(255),
    DienThoaiNV VARCHAR(20)
);

-- Bảng Quyết Định Tuyển Dụng
CREATE TABLE QuyetDinhTuyenDung (
    SoQuyetDinhTuyenDung VARCHAR(20) PRIMARY KEY,
    NgayQuyetDinhTuyenDung DATE,
    ThoiGianThuViec INT, -- Số tháng/ngày thử việc
    MucLuongThuViec DECIMAL(18, 2),
    NoiDungQuyetDinh NVARCHAR(MAX),
    MaNV VARCHAR(20),
    MaPhongBan VARCHAR(20),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaPhongBan) REFERENCES PhongBan(MaPhongBan)
);

-- Bảng Danh Mục Loại Hợp Đồng
CREATE TABLE LoaiHopDong (
    MaLoaiHopDong VARCHAR(20) PRIMARY KEY,
    TenLoaiHopDong NVARCHAR(50) NOT NULL, -- Dài hạn, Ngắn hạn
    ThoiHanHopDong NVARCHAR(50)
);

-- Bảng Hợp Đồng Lao Động
CREATE TABLE HopDong (
    SoHopDong VARCHAR(20) PRIMARY KEY,
    NgayLapHopDong DATE,
    NoiDungHopDong NVARCHAR(MAX),
    MaLoaiHopDong VARCHAR(20),
    MaNV VARCHAR(20),
    FOREIGN KEY (MaLoaiHopDong) REFERENCES LoaiHopDong(MaLoaiHopDong),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Danh Mục Bảo Hiểm
CREATE TABLE BaoHiem (
    MaBaoHiem VARCHAR(20) PRIMARY KEY,
    TenBaoHiem NVARCHAR(100) NOT NULL, -- BHXH, BHYT...
    PhanTramBaoHiem FLOAT
);

-- Bảng Sổ Bảo Hiểm Nhân Viên
CREATE TABLE SoBaoHiem (
    MaSoBaoHiem VARCHAR(20) PRIMARY KEY,
    NgayLapSoBaoHiem DATE,
    ThoiHanSoBaoHiem NVARCHAR(50),
    MaNV VARCHAR(20),
    MaBaoHiem VARCHAR(20),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaBaoHiem) REFERENCES BaoHiem(MaBaoHiem)
);

-- Bảng Quyết Định Lương
CREATE TABLE QuyetDinhLuong (
    SoQuyetDinhLuong VARCHAR(20) PRIMARY KEY,
    NgayQuyetDinhLuong DATE,
    MucLuongCoBan DECIMAL(18, 2),
    MaNV VARCHAR(20),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Danh Mục Phụ Cấp
CREATE TABLE PhuCap (
    MaPhuCap VARCHAR(20) PRIMARY KEY,
    TenPhuCap NVARCHAR(100) NOT NULL, -- Phụ cấp lương, Phụ cấp độc hại...
    SoTienPhuCap DECIMAL(18, 2)
);

-- Bảng Chi Tiết Phụ Cấp Theo Quyết Định Lương
CREATE TABLE PhuCap_Luong (
    SoQuyetDinhLuong VARCHAR(20),
    MaPhuCap VARCHAR(20),
    PRIMARY KEY (SoQuyetDinhLuong, MaPhuCap),
    FOREIGN KEY (SoQuyetDinhLuong) REFERENCES QuyetDinhLuong(SoQuyetDinhLuong),
    FOREIGN KEY (MaPhuCap) REFERENCES PhuCap(MaPhuCap)
);

-- Bảng Chức Vụ
CREATE TABLE ChucVu (
    MaChucVu VARCHAR(20) PRIMARY KEY,
    TenChucVu NVARCHAR(100) NOT NULL,
    HeSoLuong FLOAT,
    PhuCapChucVu DECIMAL(18, 2)
);

-- Bảng Quyết Định Chức Vụ
CREATE TABLE QuyetDinhChucVu (
    SoQuyetDinhChucVu VARCHAR(20) PRIMARY KEY,
    NgayQuyetDinhChucVu DATE,
    MaNV VARCHAR(20),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Chi Tiết Quyết Định Chức Vụ
CREATE TABLE ChiTietQuyetDinhChucVu (
    SoQuyetDinhChucVu VARCHAR(20),
    MaChucVu VARCHAR(20),
    PRIMARY KEY (SoQuyetDinhChucVu, MaChucVu),
    FOREIGN KEY (SoQuyetDinhChucVu) REFERENCES QuyetDinhChucVu(SoQuyetDinhChucVu),
    FOREIGN KEY (MaChucVu) REFERENCES ChucVu(MaChucVu)
);

-- Bảng Bảng Chấm Công (Tổng hợp tháng)
CREATE TABLE BangChamCong (
    MaBangChamCong VARCHAR(20) PRIMARY KEY,
    TuNgay DATE,
    DenNgay DATE
);

-- Bảng Chi Tiết Bảng Chấm Công
CREATE TABLE ChiTietBangChamCong (
    MaNV VARCHAR(20),
    MaBangChamCong VARCHAR(20),
    SoGioLamViec FLOAT,
    PRIMARY KEY (MaNV, MaBangChamCong),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (MaBangChamCong) REFERENCES BangChamCong(MaBangChamCong)
);

-- Bảng Phiếu Ghi Nhận Giờ Phụ Trội
CREATE TABLE PhieuGhiNhanPhuTroi (
    SoPhieuGhiNhanPhuTroi VARCHAR(20) PRIMARY KEY,
    NgayPhuTroi DATE,
    HinhThucPhuTroi NVARCHAR(50), -- Tăng ca, Ngày lễ, Ngày nghỉ
    SoGioPhuTroi FLOAT,
    HeSoPhuTroi FLOAT DEFAULT 1.5
);

-- Bảng Chi Tiết Phiếu Phụ Trội Theo Nhân Viên
CREATE TABLE ChiTietPhieuPhuTroi (
    MaNV VARCHAR(20),
    SoPhieuGhiNhanPhuTroi VARCHAR(20),
    SoGioPhuTroiThamGia FLOAT,
    PRIMARY KEY (MaNV, SoPhieuGhiNhanPhuTroi),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV),
    FOREIGN KEY (SoPhieuGhiNhanPhuTroi) REFERENCES PhieuGhiNhanPhuTroi(SoPhieuGhiNhanPhuTroi)
);

-- Bảng Quyết Định Khen Thưởng / Kỷ Luật (Chung)
CREATE TABLE QuyetDinhKhenThuong_KyLuat (
    SoQuyetDinhKhenThuong_KyLuat VARCHAR(20) PRIMARY KEY,
    NgayQuyetDinh DATE,
    NoiDungQuyetDinh NVARCHAR(MAX)
);

-- Bảng Khen Thưởng / Kỷ Luật Áp Dụng Cho Cá Nhân
CREATE TABLE KhenThuong_KyLuatCaNhan (
    SoQuyetDinhKhenThuong_KyLuat VARCHAR(20),
    MaNV VARCHAR(20),
    SoTienKhenThuong_KyLuatCaNhan DECIMAL(18, 2),
    PRIMARY KEY (SoQuyetDinhKhenThuong_KyLuat, MaNV),
    FOREIGN KEY (SoQuyetDinhKhenThuong_KyLuat) REFERENCES QuyetDinhKhenThuong_KyLuat(SoQuyetDinhKhenThuong_KyLuat),
    FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV)
);

-- Bảng Khen Thưởng / Kỷ Luật Áp Dụng Cho Tập Thể Phòng Ban
CREATE TABLE KhenThuong_KyLuatTapThe (
    SoQuyetDinhKhenThuong_KyLuat VARCHAR(20),
    MaPhongBan VARCHAR(20),
    SoTienKhenThuong_KyLuatTapThe DECIMAL(18, 2),
    PRIMARY KEY (SoQuyetDinhKhenThuong_KyLuat, MaPhongBan),
    FOREIGN KEY (SoQuyetDinhKhenThuong_KyLuat) REFERENCES QuyetDinhKhenThuong_KyLuat(SoQuyetDinhKhenThuong_KyLuat),
    FOREIGN KEY (MaPhongBan) REFERENCES PhongBan(MaPhongBan)
);
GO

--------------------------------------------------------------------------------
-- 2. INSERT DỮ LIỆU MẪU (SAMPLE DATA)
--------------------------------------------------------------------------------

-- 1. Phòng ban
INSERT INTO PhongBan (MaPhongBan, TenPhongBan, DienThoaiPhongBan) VALUES
('PB01', N'Phòng Tài Chính Kế Toán', '02838111222'),
('PB02', N'Phòng Kỹ Thuật Sơn', '02838333444'),
('PB03', N'Phòng Sản Xuất', '02838555666');

-- 2. Nhân viên
INSERT INTO NhanVien (MaNV, HoTen, Phai, NgaySinh, DiaChiNV, DienThoaiNV) VALUES
('NV01', N'Nguyễn Văn An', N'Nam', '1995-05-12', N'Quận 1, TP.HCM', '0901112233'),
('NV02', N'Trần Thị Bích', N'Nữ', '1998-08-20', N'Quận 3, TP.HCM', '0904445566'),
('NV03', N'Lê Hoàng Long', N'Nam', '1990-02-15', N'Thủ Đức, TP.HCM', '0907778899');

-- 3. Quyết định tuyển dụng
INSERT INTO QuyetDinhTuyenDung (SoQuyetDinhTuyenDung, NgayQuyetDinhTuyenDung, ThoiGianThuViec, MucLuongThuViec, NoiDungQuyetDinh, MaNV, MaPhongBan) VALUES
('QDTĐ01', '2023-01-10', 2, 6000000, N'Thử việc vị trí kế toán viên', 'NV01', 'PB01'),
('QDTĐ02', '2023-03-01', 2, 7000000, N'Thử việc kỹ sư pha chế sơn', 'NV02', 'PB02'),
('QDTĐ03', '2023-05-10', 3, 5500000, N'Thử việc vận hành dây chuyền', 'NV03', 'PB03');

-- 4. Danh mục loại hợp đồng
INSERT INTO LoaiHopDong (MaLoaiHopDong, TenLoaiHopDong, ThoiHanHopDong) VALUES 
('LHD01', N'Hợp đồng dài hạn', N'Không thời hạn'),
('LHD02', N'Hợp đồng ngắn hạn', N'12 tháng');

-- 5. Hợp đồng lao động
INSERT INTO HopDong (SoHopDong, NgayLapHopDong, NoiDungHopDong, MaLoaiHopDong, MaNV) VALUES
('HD01', '2023-03-10', N'Hợp đồng lao động chính thức dài hạn', 'LHD01', 'NV01'),
('HD02', '2023-05-01', N'Hợp đồng lao động dài hạn', 'LHD01', 'NV02'),
('HD03', '2023-08-10', N'Hợp đồng ngắn hạn', 'LHD02', 'NV03');

-- 6. Danh mục bảo hiểm
INSERT INTO BaoHiem (MaBaoHiem, TenBaoHiem, PhanTramBaoHiem) VALUES
('BHXH', N'Bảo hiểm xã hội', 8.0),
('BHYT', N'Bảo hiểm y tế', 1.5);

-- 7. Sổ bảo hiểm nhân viên
INSERT INTO SoBaoHiem (MaSoBaoHiem, NgayLapSoBaoHiem, ThoiHanSoBaoHiem, MaNV, MaBaoHiem) VALUES
('SBH01', '2023-03-15', N'Lâu dài', 'NV01', 'BHXH'),
('SBH02', '2023-03-15', N'Lâu dài', 'NV01', 'BHYT'),
('SBH03', '2023-05-05', N'Lâu dài', 'NV02', 'BHXH');

-- 8. Quyết định lương
INSERT INTO QuyetDinhLuong (SoQuyetDinhLuong, NgayQuyetDinhLuong, MucLuongCoBan, MaNV) VALUES
('QDL01', '2023-03-10', 9000000, 'NV01'),
('QDL02', '2023-05-01', 11000000, 'NV02'),
('QDL03', '2023-08-10', 8000000, 'NV03');

-- 9. Danh mục phụ cấp
INSERT INTO PhuCap (MaPhuCap, TenPhuCap, SoTienPhuCap) VALUES
('PC01', N'Phụ cấp độc hại', 1000000),
('PC02', N'Phụ cấp trách nhiệm', 1500000);

-- 10. Phụ cấp lương
INSERT INTO PhuCap_Luong (SoQuyetDinhLuong, MaPhuCap) VALUES
('QDL02', 'PC01'),
('QDL01', 'PC02');

-- 11. Chức vụ
INSERT INTO ChucVu (MaChucVu, TenChucVu, HeSoLuong, PhuCapChucVu) VALUES
('CV01', N'Trưởng phòng', 2.34, 2000000),
('CV02', N'Nhân viên chính thức', 1.86, 500000);

-- 12. Quyết định chức vụ
INSERT INTO QuyetDinhChucVu (SoQuyetDinhChucVu, NgayQuyetDinhChucVu, MaNV) VALUES
('QDCV01', '2023-03-10', 'NV01'),
('QDCV02', '2023-05-01', 'NV02');

-- 13. Chi tiết quyết định chức vụ
INSERT INTO ChiTietQuyetDinhChucVu (SoQuyetDinhChucVu, MaChucVu) VALUES
('QDCV01', 'CV02'),
('QDCV02', 'CV01');

-- 14. Bảng chấm công
INSERT INTO BangChamCong (MaBangChamCong, TuNgay, DenNgay) VALUES
('BCC2026-10', '2026-10-01', '2026-10-31');

-- 15. Chi tiết bảng chấm công
INSERT INTO ChiTietBangChamCong (MaNV, MaBangChamCong, SoGioLamViec) VALUES
('NV01', 'BCC2026-10', 160),
('NV02', 'BCC2026-10', 160),
('NV03', 'BCC2026-10', 150);

-- 16. Phiếu ghi nhận giờ phụ trội
INSERT INTO PhieuGhiNhanPhuTroi (SoPhieuGhiNhanPhuTroi, NgayPhuTroi, HinhThucPhuTroi, SoGioPhuTroi, HeSoPhuTroi) VALUES
('PPT01', '2026-10-10', N'Tăng ca', 10, 1.5),
('PPT02', '2026-10-15', N'Ngày lễ', 8, 1.5);

-- 17. Chi tiết phiếu phụ trội
INSERT INTO ChiTietPhieuPhuTroi (MaNV, SoPhieuGhiNhanPhuTroi, SoGioPhuTroiThamGia) VALUES
('NV01', 'PPT01', 10),
('NV03', 'PPT02', 8);

-- 18. Quyết định khen thưởng / kỷ luật
INSERT INTO QuyetDinhKhenThuong_KyLuat (SoQuyetDinhKhenThuong_KyLuat, NgayQuyetDinh, NoiDungQuyetDinh) VALUES
('QDKT01', '2026-09-30', N'Thưởng thành tích xuất sắc tháng 9'),
('QDKL01', '2026-10-05', N'Quyết định xử phạt đi trễ');

-- 19. Khen thưởng kỷ luật cá nhân
INSERT INTO KhenThuong_KyLuatCaNhan (SoQuyetDinhKhenThuong_KyLuat, MaNV, SoTienKhenThuong_KyLuatCaNhan) VALUES
('QDKT01', 'NV01', 1500000),
('QDKL01', 'NV03', 200000);

-- 20. Khen thưởng kỷ luật tập thể
INSERT INTO KhenThuong_KyLuatTapThe (SoQuyetDinhKhenThuong_KyLuat, MaPhongBan, SoTienKhenThuong_KyLuatTapThe) VALUES
('QDKT01', 'PB01', 5000000);
GO