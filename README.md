# 📷 CAPSTONE SLOT 15 - API QUẢN LÝ ẢNH VÀ NGƯỜI DÙNG

API Backend cho ứng dụng quản lý và chia sẻ ảnh. CAPSTONE SLOT 15 - NODE 53

## 🚀 Công nghệ sử dụng

- **Node.js** - Runtime environment
- **Express.js** - Web framework
- **Prisma** - ORM cho database
- **MySQL** - Database
- **JWT** - Authentication
- **Multer** - Upload file
- **Swagger** - API Documentation
- **Bcrypt** - Mã hóa password

---

## 📋 Yêu cầu hệ thống

- Node.js >= 18.x
- MySQL >= 8.x
- npm hoặc yarn

---

## ⚙️ Cài đặt và Chạy project

### 1. Clone repository

```bash
git clone <repository-url>
cd CapstoneSlot15
```

### 2. Cài đặt dependencies

```bash
npm install
```

### 3. Cấu hình Environment Variables

Tạo file `.env` ở thư mục root với nội dung:

```env
# Database
DATABASE_URL="mysql://username:password@localhost:3306/database_name"

# Server
PORT=your_port

# JWT Secrets
ACCESS_TOKEN_SECRET=your_access_token_secret_key_here
REFRESH_TOKEN_SECRET=your_refresh_token_secret_key_here

# Cloudinary (optional - nếu dùng Cloudinary)
CLOUDINARY_NAME=your_cloudinary_name
CLOUDINARY_API_KEY=your_cloudinary_api_key
CLOUDINARY_API_SECRET=your_cloudinary_api_secret

# Upload folder
FOLDER_IMAGE=public/images
```

**Lưu ý:**
- Thay `username`, `password`, `database_name` bằng thông tin MySQL của bạn
- Tạo secret key ngẫu nhiên cho JWT (có thể dùng: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`)

### 4. Setup Database

Mở MySQL Workbench hoặc terminal MySQL và chạy các câu lệnh trong file `query.sql`:

```sql
-- 1. Tạo database
CREATE DATABASE capstone_slot15;
USE capstone_slot15;

-- 2. Tạo các bảng
CREATE TABLE users (
    userID INT PRIMARY KEY AUTO_INCREMENT,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    fullname VARCHAR(100),
    age INT,
    avatar VARCHAR(255)
);

CREATE TABLE images (
    imageID INT PRIMARY KEY AUTO_INCREMENT,
    imageName VARCHAR(255) NOT NULL,
    path VARCHAR(255) NOT NULL,
    description TEXT,
    userID INT,
    isDeleted TINYINT(1) DEFAULT 0,
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE
);

CREATE TABLE comments (
    commentID INT PRIMARY KEY AUTO_INCREMENT,
    userID INT,
    imageID INT,
    comment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    content TEXT,
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (imageID) REFERENCES images(imageID) ON DELETE CASCADE
);

CREATE TABLE saved_images (
    userID INT,
    imageID INT,
    saveDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (userID, imageID),
    FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE,
    FOREIGN KEY (imageID) REFERENCES images(imageID) ON DELETE CASCADE
);

-- 3. (Optional) Insert dữ liệu mẫu
-- Xem chi tiết trong file query.sql
```

### 5. Chạy server

**Lưu ý:** Đảm bảo đã chạy `npm install` ở bước 2 trước khi start server.

```bash
npm run dev
```

Server sẽ chạy tại: `http://localhost:your_port`

### 6. Xem API Documentation

Truy cập Swagger UI tại: `http://localhost:your_port/api-docs`

---

## 📚 API Endpoints

### 🔐 Authentication

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| POST | `/api/auth/register` | Đăng ký tài khoản mới | ❌ |
| POST | `/api/auth/login` | Đăng nhập | ❌ |
| POST | `/api/auth/refresh-token` | Làm mới access token | ✅ |

### 👤 Users

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/users/profile` | Lấy thông tin user hiện tại | ✅ |
| GET | `/api/users/saved-images` | Lấy danh sách ảnh đã lưu | ✅ |
| GET | `/api/users/uploaded-images` | Lấy danh sách ảnh đã upload | ✅ |
| POST | `/api/users/uploadImage` | Upload ảnh mới (multipart) | ✅ |
| POST | `/api/users/save-image/:imageId` | Lưu ảnh vào collection | ✅ |

### 🖼️ Images

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/images` | Lấy danh sách ảnh (có phân trang & filter) | ❌ |
| GET | `/api/images/:id` | Lấy chi tiết ảnh theo ID | ❌ |
| GET | `/api/images/checkSaved/:id` | Kiểm tra ảnh đã lưu chưa | ✅ |
| DELETE | `/api/images/:id` | Xóa ảnh (soft delete) | ✅ |

### 💬 Comments

| Method | Endpoint | Description | Auth Required |
|--------|----------|-------------|---------------|
| GET | `/api/comments/:id` | Lấy comments theo imageID | ❌ |
| POST | `/api/comments` | Tạo comment mới | ✅ |

---

## 📖 Chi tiết API

### Authentication

#### 1. Đăng ký
```http
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "123456"
}
```

#### 2. Đăng nhập
```http
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "123456"
}
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Login successfully",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "user": {
      "userID": 1,
      "email": "user@example.com",
      "fullname": "Nguyễn Văn A"
    }
  }
}
```

#### 3. Làm mới access token
```http
POST /api/auth/refresh-token
Authorization: Bearer <refresh_token>
```

**Response:**
```json
{
  "statusCode": 200,
  "message": "Refresh token successfully",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "refreshToken": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
  }
}
```

---

### Images

#### 1. Lấy danh sách ảnh (có phân trang & filter)
```http
GET /api/images?page=1&pageSize=10&filters={"imageName":"sunset"}
```

**Query Parameters:**
- `page` (optional): Số trang, mặc định = 1
- `pageSize` (optional): Số lượng item/trang, mặc định = 3
- `filters` (optional): JSON string để filter, ví dụ: `{"imageName":"sunset"}`

**Response:**
```json
{
  "statusCode": 200,
  "message": "Get all images successfully",
  "data": {
    "page": 1,
    "pageSize": 10,
    "totalItem": 50,
    "totalPage": 5,
    "items": [...]
  }
}
```

#### 2. Lấy chi tiết ảnh
```http
GET /api/images/5
```

#### 3. Xóa ảnh (Soft Delete)
```http
DELETE /api/images/5
Authorization: Bearer <token>
```

#### 4. Kiểm tra ảnh đã lưu chưa
```http
GET /api/images/checkSaved/5
Authorization: Bearer <token>
```

---

### Users

#### 1. Upload ảnh
```http
POST /api/users/uploadImage
Authorization: Bearer <token>
Content-Type: multipart/form-data

file: [File]
imageName: "Beautiful Sunset"
description: "A beautiful sunset at the beach"
```

**Lưu ý:** 
- Sử dụng Postman hoặc Insomnia để test upload file
- Swagger UI có thể bị timeout với file lớn

#### 2. Lưu ảnh vào collection
```http
POST /api/users/save-image/5
Authorization: Bearer <token>
```

#### 3. Lấy thông tin profile
```http
GET /api/users/profile
Authorization: Bearer <token>
```

#### 4. Lấy danh sách ảnh đã lưu
```http
GET /api/users/saved-images
Authorization: Bearer <token>
```

#### 5. Lấy danh sách ảnh đã upload
```http
GET /api/users/uploaded-images
Authorization: Bearer <token>
```

---

### Comments

#### 1. Tạo comment
```http
POST /api/comments
Authorization: Bearer <token>
Content-Type: application/json

{
  "imageID": 5,
  "content": "Ảnh đẹp quá!"
}
```

#### 2. Lấy comments theo imageID
```http
GET /api/comments/5
```

---

## 🗄️ Database Schema

### users
- userID (PK, auto increment)
- email (unique)
- password (hashed)
- fullname
- age
- avatar

### images
- imageID (PK, auto increment)
- imageName
- path (filename or cloudinary public_id)
- description
- userID (FK)
- isDeleted (boolean)

### comments
- commentID (PK, auto increment)
- userID (FK)
- imageID (FK)
- content
- comment_date

### saved_images
- userID (FK)
- imageID (FK)
- saveDate
- PK: (userID, imageID)

---

## 🔒 Authentication

API sử dụng **JWT Bearer Token** để authentication.

**Cách sử dụng:**

1. Đăng nhập để lấy `accessToken`
2. Thêm token vào header của request:
```
Authorization: Bearer <your_access_token>
```

**Token expiration:**
- Access Token: 5 giây (để test, có thể thay đổi trong code)
- Refresh Token: 1 ngày

---

## 📁 Cấu trúc thư mục

```
CapstoneSlot15/
├── prisma/
│   └── schema.prisma          # Database schema
├── public/
│   └── images/                # Uploaded images
├── src/
│   ├── common/
│   │   ├── cloudinary/        # Cloudinary config
│   │   ├── constant/          # Constants & env variables
│   │   ├── helper/            # Helper functions
│   │   ├── middleware/        # Middlewares (auth, error handling)
│   │   ├── multer/            # File upload config
│   │   ├── prisma/            # Prisma client
│   │   └── swagger/           # Swagger configuration
│   ├── controllers/           # Controllers
│   ├── services/              # Business logic
│   └── routers/               # API routes
├── .env                       # Environment variables
├── package.json
├── server.js                  # Entry point
└── README.md
```

---

## 🐛 Troubleshooting

### Lỗi kết nối Database
- Kiểm tra MySQL đã chạy chưa
- Kiểm tra `DATABASE_URL` trong `.env`
- Kiểm tra user/password có quyền truy cập database

### Lỗi upload file
- Đảm bảo folder `public/images` tồn tại
- Kiểm tra quyền write của folder
- Với Swagger: Nên dùng Postman để test upload file

### Lỗi JWT token
- Kiểm tra `ACCESS_TOKEN_SECRET` và `REFRESH_TOKEN_SECRET` trong `.env`
- Đảm bảo token được gửi đúng format: `Bearer <token>`

---

## 📝 Notes

- API này được xây dựng cho mục đích học tập
- Trong production, nên:
  - Tăng thời gian expire của access token
  - Thêm rate limiting
  - Thêm validation chi tiết hơn
  - Sử dụng HTTPS
  - Thêm logging
  - Setup CI/CD

---

## 👨‍💻 Author

**mdtrong1305**
