-- QUERY TẠO DATABASE --
-- 1. Tạo bảng Người dùng (để xử lý Đăng ký/Đăng nhập)
CREATE TABLE users (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100),
    age INT,
    avatar VARCHAR(255)
);

-- 2. Tạo bảng Hình ảnh (Trang chủ & Quản lý ảnh đã tạo)
CREATE TABLE images (
    imageID INT PRIMARY KEY AUTO_INCREMENT,
    imageName VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL,
    description TEXT,
    userID INT,
    isDeleted TINYINT(1) DEFAULT 0, -- 0: chưa xóa, 1: đã xóa (soft delete)
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE
);

-- 3. Tạo bảng Bình luận (Chi tiết ảnh)
CREATE TABLE comments (
    commentID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    imageID INT,
    comment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    content TEXT,
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (imageID) REFERENCES images(imageID) ON DELETE CASCADE
);

-- 4. Tạo bảng Lưu ảnh (Để kiểm tra nút Save và danh sách ảnh đã lưu)
CREATE TABLE saved_images (
    userID INT,
    imageID INT,
    saveDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userID, imageID), -- Một user chỉ lưu một ảnh 1 lần
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (imageID) REFERENCES images(imageID) ON DELETE CASCADE
);

-- QUERY INSERT DỮ LIỆU MẪU --
-- 1. DỮ LIỆU BẢNG USERS
INSERT INTO users (email, password, fullname, age, avatar) VALUES
('trong.mai@gmail.com', 'hash_password_123', 'Mai Đức Trọng', 20, 'avatar_trong.jpg'),
('nguyen.van.a@fpt.edu.vn', 'hash_password_456', 'Nguyễn Văn A', 22, 'avatar_a.png'),
('tran.thi.b@gmail.com', 'hash_password_789', 'Trần Thị B', 21, 'avatar_b.jpg'),
('le.van.c@yahoo.com', 'hash_password_abc', 'Lê Văn C', 25, 'avatar_c.webp'),
('hoang.thi.d@gmail.com', 'hash_password_xyz', 'Hoàng Thị D', 19, 'avatar_d.jpg');

-- 2. DỮ LIỆU BẢNG IMAGES (Trang chủ & Ảnh đã tạo)
-- Giả định ID từ 1 đến 5 cho Users
INSERT INTO images (imageName, path, description, userID, isDeleted) VALUES
('Hoàng hôn biển', 'https://picsum.photos/id/10/800/600', 'Phú Quốc 2024', 1, 0),
('Góc làm việc', 'https://picsum.photos/id/20/800/600', 'Clean setup', 1, 0),
('Mèo Ragdoll', 'https://picsum.photos/id/30/800/600', 'Mèo béo', 2, 0),
('Phố cổ', 'https://picsum.photos/id/40/800/600', 'Hà Nội mùa thu', 2, 0),
('Sushi', 'https://picsum.photos/id/50/800/600', 'Đồ ăn Nhật', 3, 0),
('Rừng xanh', 'https://picsum.photos/id/61/800/600', 'Nature', 4, 0),
('Siêu xe', 'https://picsum.photos/id/70/800/600', 'Ferrari', 5, 0),
('Tokyo Night', 'https://picsum.photos/id/80/800/600', 'Neon light', 1, 0),
('Coffee morning', 'https://picsum.photos/id/90/800/600', 'Daily coffee', 3, 0),
('Workout', 'https://picsum.photos/id/100/800/600', 'Gym motivation', 4, 0);

-- 3. DỮ LIỆU BẢNG COMMENTS (Trang chi tiết)
INSERT INTO comments (userID, imageID, content) VALUES
(2, 1, 'Góc chụp đẹp quá Trọng ơi!'),
(3, 1, 'Thích màu sắc của tấm này ghê.'),
(1, 3, 'Mèo này giống gì vậy bạn?'),
(4, 5, 'Nhìn thèm quá đi mất thôi.'),
(5, 2, 'Bàn làm việc gọn gàng thật sự.'),
(2, 8, 'Tokyo luôn đẹp như vậy.'),
(3, 10, 'Cố gắng duy trì thói quen này nhé!'),
(1, 7, 'Con xe này giá bao nhiêu vậy anh C?');

-- 4. DỮ LIỆU BẢNG SAVED_IMAGES (Ảnh đã lưu)
INSERT INTO saved_images (userID, imageID) VALUES
(1, 3), (1, 5), (1, 7), -- Trọng lưu ảnh mèo, đồ ăn, siêu xe
(2, 1), (2, 8),          -- Nguyễn Văn A lưu ảnh biển và Tokyo
(3, 2), (3, 10),         -- Trần Thị B lưu ảnh setup bàn và chạy bộ
(4, 1), (4, 4),          -- Lê Văn C lưu ảnh biển và kiến trúc
(5, 9);                 -- Hoàng Thị D lưu ảnh cà phê