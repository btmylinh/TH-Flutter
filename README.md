# Hệ thống Đánh giá Nhà hàng (Restaurant Rating System)

Ứng dụng Flutter toàn diện sử dụng Firebase và Clean Architecture để xây dựng hệ thống đánh giá nhà hàng với các tính năng nâng cao.

## 🎯 Mục tiêu

Xây dựng một ứng dụng cho phép người dùng:

- Xem danh sách các nhà hàng
- Đọc và gửi đánh giá kèm theo ảnh
- Nhận thông báo về đánh giá mới
- Quản lý hồ sơ cá nhân

## ✨ Tính năng chính

### 1. Xác thực và Quản lý Người dùng

- ✅ Đăng ký/Đăng nhập với Firebase Authentication
- ✅ Lưu trữ hồ sơ người dùng trong Cloud Firestore
- ✅ Quản lý phiên đăng nhập

### 2. Dữ liệu Thời gian Thực

- ✅ Cloud Firestore để lưu trữ nhà hàng, đánh giá, và điểm số
- ✅ StreamBuilder cho dữ liệu real-time
- ✅ Tự động cập nhật UI khi có thay đổi

### 3. Tải và Quản lý Ảnh

- ✅ Chọn ảnh từ thư viện hoặc chụp ảnh mới (image_picker)
- ✅ Tải ảnh lên Firebase Cloud Storage
- ✅ Hiển thị ảnh với cached_network_image

### 4. Thông báo Push

- ✅ Firebase Cloud Messaging (FCM)
- ✅ Thông báo khi có đánh giá mới
- ✅ Xử lý thông báo foreground/background

### 5. Cloud Functions (Backend Serverless)

- ✅ Tự động tính điểm trung bình khi có đánh giá mới
- ✅ Gửi thông báo đến người dùng quan tâm
- ✅ Xóa ảnh khi đánh giá bị xóa

### 6. Clean Architecture

- ✅ Tách biệt Domain, Data, và Presentation layers
- ✅ Dependency Injection với GetIt
- ✅ State Management với BLoC pattern
- ✅ Repository pattern cho data access

## 🏗️ Kiến trúc Dự án

```
lib/
├── core/
│   ├── error/
│   │   └── failures.dart
│   ├── usecases/
│   │   └── usecase.dart
│   └── services/
│       └── notification_service.dart
├── data/
│   ├── datasources/
│   │   ├── auth_remote_data_source.dart
│   │   ├── restaurant_remote_data_source.dart
│   │   └── review_remote_data_source.dart
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── restaurant_model.dart
│   │   └── review_model.dart
│   └── repositories/
│       ├── auth_repository_impl.dart
│       ├── restaurant_repository_impl.dart
│       └── review_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── user_entity.dart
│   │   ├── restaurant_entity.dart
│   │   └── review_entity.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── restaurant_repository.dart
│   │   └── review_repository.dart
│   └── usecases/
│       ├── sign_in_with_email.dart
│       ├── sign_up_with_email.dart
│       ├── sign_out.dart
│       ├── get_current_user.dart
│       ├── get_restaurants.dart
│       ├── get_reviews.dart
│       └── add_review.dart
├── presentation/
│   ├── bloc/
│   │   ├── auth/
│   │   ├── restaurant/
│   │   └── review/
│   └── screens/
│       ├── auth/
│       ├── home/
│       └── restaurant/
├── firebase_options.dart
├── injection_container.dart
└── main.dart

functions/
├── index.js
├── package.json
└── README.md
```

## 🚀 Cài đặt

### Yêu cầu

- Flutter SDK (>=3.9.2)
- Dart SDK
- Firebase CLI
- Node.js (cho Cloud Functions)

### Bước 1: Clone và cài đặt dependencies

```bash
cd baitap3
flutter pub get
```

### Bước 2: Cấu hình Firebase

1. Tạo project Firebase tại [Firebase Console](https://console.firebase.google.com/)

2. Cài đặt Firebase CLI:

```bash
npm install -g firebase-tools
```

3. Đăng nhập Firebase:

```bash
firebase login
```

4. Cấu hình FlutterFire:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

5. Cập nhật `lib/firebase_options.dart` với thông tin project của bạn

### Bước 3: Cấu hình Firebase Services

#### 3.1 Authentication

- Vào Firebase Console > Authentication
- Enable Email/Password sign-in method

#### 3.2 Cloud Firestore

- Tạo database trong Firestore
- Deploy Firestore rules:

```bash
firebase deploy --only firestore:rules
```

#### 3.3 Cloud Storage

- Enable Cloud Storage
- Deploy Storage rules:

```bash
firebase deploy --only storage
```

#### 3.4 Cloud Messaging

- Vào Project Settings > Cloud Messaging
- Lưu Server key (cho backend nếu cần)

### Bước 4: Deploy Cloud Functions

```bash
cd functions
npm install
firebase deploy --only functions
```

### Bước 5: Thêm dữ liệu mẫu

Sử dụng Firebase Console để thêm dữ liệu mẫu vào collection `restaurants`:

```json
{
  "name": "Nhà hàng Phở Việt",
  "description": "Quán phở truyền thống với hương vị đậm đà",
  "address": "123 Đường Lê Lợi, Quận 1, TP.HCM",
  "category": "Món Việt",
  "imageUrl": "https://example.com/pho.jpg",
  "averageRating": 0,
  "reviewCount": 0,
  "createdAt": "2024-01-01T00:00:00Z"
}
```

### Bước 6: Chạy ứng dụng

```bash
flutter run
```

## 📱 Sử dụng

### Đăng ký/Đăng nhập

1. Mở ứng dụng
2. Nhập email và mật khẩu
3. Nhấn "Đăng ký" nếu chưa có tài khoản

### Xem và Đánh giá Nhà hàng

1. Danh sách nhà hàng hiển thị ngay sau khi đăng nhập
2. Chọn một nhà hàng để xem chi tiết
3. Nhấn "Viết đánh giá" để thêm đánh giá mới
4. Chọn số sao, viết nhận xét, và thêm ảnh
5. Nhấn "Gửi đánh giá"

### Nhận Thông báo

- Ứng dụng tự động yêu cầu quyền thông báo
- Nhận thông báo khi có đánh giá mới cho nhà hàng yêu thích

## 🔧 Công nghệ Sử dụng

### Frontend

- **Flutter**: Framework UI
- **flutter_bloc**: State management
- **get_it**: Dependency injection
- **dartz**: Functional programming (Either type)
- **equatable**: Value equality
- **image_picker**: Chọn/chụp ảnh
- **cached_network_image**: Cache và hiển thị ảnh
- **flutter_rating_bar**: Widget đánh giá sao
- **intl**: Format ngày tháng

### Firebase

- **firebase_core**: Firebase initialization
- **firebase_auth**: Authentication
- **cloud_firestore**: NoSQL database
- **firebase_storage**: File storage
- **firebase_messaging**: Push notifications
- **flutter_local_notifications**: Local notifications

### Backend

- **Cloud Functions**: Node.js serverless functions
- **firebase-admin**: Admin SDK

## 📊 Cơ sở Dữ liệu

### Collections

#### users

```
{
  id: string,
  email: string,
  displayName: string,
  photoUrl?: string,
  createdAt: timestamp
}
```

#### restaurants

```
{
  id: string,
  name: string,
  description: string,
  address: string,
  category: string,
  imageUrl: string,
  averageRating: number,
  reviewCount: number,
  createdAt: timestamp
}
```

#### reviews

```
{
  id: string,
  restaurantId: string,
  userId: string,
  userName: string,
  userPhotoUrl?: string,
  rating: number,
  comment: string,
  imageUrls: string[],
  createdAt: timestamp
}
```

## 🔐 Security Rules

### Firestore Rules

- Users: Chỉ owner mới có thể chỉnh sửa
- Restaurants: Public read, admin write only
- Reviews: Public read, authenticated users can create/edit/delete own reviews

### Storage Rules

- Review images: Max 5MB, image types only
- Profile images: Max 2MB, owner only

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test
```

## 📦 Build cho Production

### Android

```bash
flutter build apk --release
# hoặc
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## 🎓 Kiến thức Đạt được

Dự án này giúp bạn học:

1. ✅ Clean Architecture trong Flutter
2. ✅ BLoC pattern cho state management
3. ✅ Firebase Authentication
4. ✅ Cloud Firestore với real-time updates
5. ✅ Firebase Cloud Storage
6. ✅ Firebase Cloud Messaging
7. ✅ Cloud Functions
8. ✅ Image picker và upload
9. ✅ Dependency injection
10. ✅ Repository pattern
11. ✅ Error handling với Either
12. ✅ Security rules cho Firestore và Storage

## 📝 Ghi chú

- Đảm bảo cấu hình đúng Firebase project
- Kiểm tra permissions cho camera và gallery trên iOS (Info.plist)
- Thêm google-services.json (Android) và GoogleService-Info.plist (iOS)
- Cloud Functions cần billing account để deploy

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón! Hãy tạo issue hoặc pull request.

## 📄 License

MIT License

## 👨‍💻 Tác giả

Dự án thực hành Flutter & Firebase

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
