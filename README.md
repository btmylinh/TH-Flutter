# baitap1

# Ứng dụng Quản lý Chi tiêu Cá nhân

Ứng dụng quản lý chi tiêu cá nhân được xây dựng với Flutter, sử dụng Clean Architecture và BLoC/Cubit pattern.

## Tính năng

### 1. Xác thực người dùng

- Đăng ký tài khoản mới
- Đăng nhập với email/password
- Đăng xuất
- Firebase Authentication

### 2. Quản lý giao dịch

- Thêm giao dịch mới với form validation
- Sửa giao dịch
- Xóa giao dịch
- Hiển thị danh sách giao dịch theo thời gian thực (StreamBuilder)
- Lưu trữ dữ liệu trên Cloud Firestore
- Mỗi user có bộ dữ liệu riêng

### 3. Phân tích chi tiêu

- Biểu đồ tròn (Pie Chart) hiển thị chi tiêu theo danh mục
- Biểu đồ đường (Line Chart) hiển thị xu hướng chi tiêu theo tháng
- Thống kê tổng chi tiêu
- Sử dụng package fl_chart

### 4. Giao diện người dùng

- Sử dụng CustomScrollView với SliverAppBar
- SliverList để tối ưu hiệu suất
- Material Design 3
- Responsive và mượt mà

## Kiến trúc

Dự án sử dụng **Clean Architecture** với 3 layers:

### 1. Domain Layer

- **Entities**: Các đối tượng nghiệp vụ thuần túy
- **Repositories**: Abstract repositories
- **Use Cases**: Business logic

### 2. Data Layer

- **Models**: Data models extend entities
- **Data Sources**: Remote data sources (Firebase)
- **Repository Implementations**: Implement domain repositories

### 3. Presentation Layer

- **Cubit**: State management với BLoC pattern
- **Pages**: UI screens
- **Widgets**: Reusable widgets

## Cấu trúc thư mục

```
lib/
├── core/
│   ├── di/                     # Dependency Injection
│   ├── errors/                 # Error handling
│   ├── usecases/              # Base use case
│   └── utils/                 # Constants & utilities
├── features/
│   ├── auth/                  # Authentication feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── transaction/           # Transaction feature
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── analytics/             # Analytics feature
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Dependencies chính

- **firebase_core**: Firebase initialization
- **firebase_auth**: Authentication
- **cloud_firestore**: Database
- **flutter_bloc**: State management
- **equatable**: Value equality
- **dartz**: Functional programming
- **get_it**: Dependency injection
- **intl**: Internationalization & formatting
- **fl_chart**: Charts & graphs

## Cài đặt

### 1. Clone project và cài dependencies

```bash
flutter pub get
```

### 2. Cấu hình Firebase

1. Tạo project trên [Firebase Console](https://console.firebase.google.com/)
2. Thêm ứng dụng Android/iOS
3. Tải file `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)
4. Đặt file vào thư mục tương ứng:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
5. Bật Firebase Authentication (Email/Password)
6. Tạo Firestore Database

### 3. Cài đặt FlutterFire CLI (tùy chọn)

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 4. Chạy ứng dụng

```bash
flutter run
```

## Firestore Database Structure

```
users/
  {userId}/
    transactions/
      {transactionId}/
        - userId: string
        - amount: number
        - description: string
        - category: string
        - date: timestamp
        - createdAt: timestamp
```

## Firestore Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /users/{userId}/transactions/{transactionId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## Danh mục chi tiêu

- Ăn uống
- Di chuyển
- Mua sắm
- Giải trí
- Hóa đơn
- Sức khỏe
- Giáo dục
- Khác

## Screenshots

### Màn hình đăng nhập

- Form đăng nhập với validation
- Chuyển đến màn hình đăng ký

### Trang chủ

- SliverAppBar với gradient
- Hiển thị tổng chi tiêu
- Danh sách giao dịch với SliverList
- Floating action button để thêm giao dịch

### Form giao dịch

- Nhập số tiền (validation)
- Mô tả
- Chọn danh mục
- Chọn ngày
- Modal bottom sheet

### Trang phân tích

- Biểu đồ tròn chi tiêu theo danh mục
- Biểu đồ đường xu hướng chi tiêu
- Thống kê chi tiết

## Tính năng nâng cao

- **Real-time updates**: Dữ liệu tự động cập nhật khi có thay đổi
- **Form validation**: Kiểm tra đầu vào người dùng
- **Error handling**: Xử lý lỗi toàn diện
- **Performance optimization**: Sử dụng Sliver widgets
- **Clean code**: Tuân thủ SOLID principles
- **Dependency injection**: Dễ dàng test và maintain

## Testing

```bash
flutter test
```

## Build

### Android

```bash
flutter build apk --release
```

### iOS

```bash
flutter build ios --release
```

## Tác giả

Dự án học tập - Lập trình Mobile

## License

MIT License
