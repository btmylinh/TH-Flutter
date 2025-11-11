# Hệ thống Đánh giá Nhà hàng

Ứng dụng Flutter cho phép người dùng xem danh sách nhà hàng, đọc và gửi đánh giá kèm ảnh.

## Tính năng

- ✅ **Xác thực người dùng**: Firebase Authentication (Đăng ký/Đăng nhập)
- ✅ **Dữ liệu thời gian thực**: Cloud Firestore lưu trữ thông tin nhà hàng và đánh giá
- ✅ **Tải ảnh**: Image Picker + Firebase Cloud Storage
- ✅ **Hiển thị danh sách**: Sliver Widgets với hiệu ứng cuộn
- ✅ **Thông báo**: Firebase Cloud Messaging (FCM)
- ✅ **Clean Architecture**: Tách biệt Domain, Data, Presentation layers
- ✅ **State Management**: BLoC Pattern
- ✅ **Dependency Injection**: GetIt

## Cấu trúc dự án (Clean Architecture)

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart
│   ├── usecases/
│   │   └── usecase.dart
│   ├── services/
│   │   └── firebase_service.dart
│   └── injection/
│       └── injection_container.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── datasources/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── bloc/
│   │       └── pages/
│   ├── restaurant/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   └── review/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart
```

## Cài đặt Firebase

### Bước 1: Tạo Firebase Project

1. Truy cập [Firebase Console](https://console.firebase.google.com/)
2. Tạo một project mới
3. Thêm ứng dụng Android/iOS

### Bước 2: Cài đặt Firebase CLI

```bash
npm install -g firebase-tools
firebase login
```

### Bước 3: Cấu hình FlutterFire

```bash
# Cài đặt FlutterFire CLI
dart pub global activate flutterfire_cli

# Cấu hình Firebase cho project
flutterfire configure
```

### Bước 4: Enable Firebase Services

Trong Firebase Console, bật các dịch vụ sau:

#### Authentication

- Email/Password authentication

#### Cloud Firestore

Tạo database với cấu trúc:

**Collection: restaurants**

```json
{
  "name": "Nhà hàng ABC",
  "description": "Mô tả nhà hàng",
  "address": "123 Đường ABC, Quận 1, TP.HCM",
  "imageUrl": "https://example.com/image.jpg",
  "averageRating": 4.5,
  "reviewCount": 10,
  "categories": ["Việt Nam", "Hải sản"]
}
```

**Collection: reviews**

```json
{
  "restaurantId": "restaurant_id",
  "userId": "user_id",
  "userName": "Tên người dùng",
  "content": "Nội dung đánh giá",
  "rating": 5.0,
  "imageUrls": ["url1", "url2"],
  "createdAt": "2024-01-01T00:00:00.000Z"
}
```

#### Cloud Storage

- Tạo Storage bucket
- Cấu hình Storage Rules:

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /reviews/{imageId} {
      allow read: if true;
      allow write: if request.auth != null;
    }
  }
}
```

#### Cloud Messaging (FCM)

- Enable Cloud Messaging
- Tải xuống file `google-services.json` (Android) và `GoogleService-Info.plist` (iOS)

### Bước 5: Cấu hình Platform

#### Android

1. Đặt file `google-services.json` vào `android/app/`
2. Cập nhật `android/app/build.gradle.kts`:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services") // Thêm dòng này
}
```

3. Cập nhật `android/build.gradle.kts`:

```kotlin
dependencies {
    classpath("com.google.gms:google-services:4.4.0")
}
```

#### iOS

1. Đặt file `GoogleService-Info.plist` vào `ios/Runner/`
2. Cập nhật `ios/Podfile`:

```ruby
platform :ios, '13.0'
```

## Chạy ứng dụng

### Cài đặt dependencies

```bash
flutter pub get
```

### Chạy ứng dụng

```bash
flutter run
```

## Sử dụng

1. **Đăng ký/Đăng nhập**: Tạo tài khoản mới hoặc đăng nhập
2. **Xem danh sách nhà hàng**: Cuộn để xem các nhà hàng
3. **Xem chi tiết**: Nhấn vào nhà hàng để xem thông tin chi tiết và đánh giá
4. **Thêm đánh giá**:
   - Nhấn nút "Thêm đánh giá"
   - Chọn số sao
   - Viết nhận xét
   - Thêm ảnh (tùy chọn)
   - Gửi đánh giá

## Thêm dữ liệu mẫu

Trong Firebase Console > Firestore, thêm một số nhà hàng mẫu:

```javascript
// Collection: restaurants
{
  name: "Phở Hà Nội",
  description: "Phở truyền thống Hà Nội, nước dùng đậm đà",
  address: "45 Nguyễn Huệ, Quận 1, TP.HCM",
  imageUrl: "https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43",
  averageRating: 0,
  reviewCount: 0,
  categories: ["Việt Nam", "Phở"]
}

{
  name: "Sushi Tokyo",
  description: "Sushi tươi ngon, đầu bếp Nhật Bản",
  address: "123 Lê Lợi, Quận 1, TP.HCM",
  imageUrl: "https://images.unsplash.com/photo-1579584425555-c3ce17fd4351",
  averageRating: 0,
  reviewCount: 0,
  categories: ["Nhật Bản", "Sushi"]
}

{
  name: "Pizza Italia",
  description: "Pizza Ý chính gống, lò nướng đá truyền thống",
  address: "78 Pasteur, Quận 3, TP.HCM",
  imageUrl: "https://images.unsplash.com/photo-1513104890138-7c749659a591",
  averageRating: 0,
  reviewCount: 0,
  categories: ["Ý", "Pizza"]
}
```

## Công nghệ sử dụng

- **Flutter**: Framework phát triển ứng dụng
- **Firebase Authentication**: Xác thực người dùng
- **Cloud Firestore**: Database NoSQL thời gian thực
- **Firebase Storage**: Lưu trữ ảnh
- **Firebase Cloud Messaging**: Gửi thông báo
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **image_picker**: Chọn ảnh từ thư viện/camera
- **cached_network_image**: Cache và hiển thị ảnh
- **flutter_rating_bar**: Hiển thị và chọn rating

## Ghi chú

- Đảm bảo đã cấu hình Firebase đúng cách
- Kiểm tra quyền truy cập Camera/Gallery trên thiết bị
- Cần kết nối internet để sử dụng
- FCM notifications cần cấu hình thêm Cloud Functions (không bắt buộc)

## Tác giả

Dự án mẫu cho môn học Lập trình Mobile
