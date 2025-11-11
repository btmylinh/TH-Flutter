# Ứng dụng Sách Điện Tử

Một ứng dụng đọc sách điện tử được xây dựng bằng Flutter với giao diện hiện đại và nhiều tính năng tùy chỉnh.

## 🎯 Mục tiêu

Xây dựng một ứng dụng đơn giản cho phép người dùng đọc sách điện tử với trải nghiệm người dùng tốt nhất.

## ✨ Tính năng

### 1. Hiển thị Trang Sách (PageView)

- ✅ Sử dụng `PageView` để tạo hiệu ứng lật trang mượt mà
- ✅ Vuốt ngang để chuyển trang
- ✅ Tự động phân chia nội dung thành các trang hợp lý

### 2. Vẽ Văn Bản Tùy Chỉnh (CustomPainter)

- ✅ Sử dụng `CustomPainter` để vẽ văn bản lên canvas
- ✅ Tùy chỉnh bố cục và kiểu chữ độc đáo
- ✅ Đường trang trí đầu và cuối trang
- ✅ Căn lề và khoảng cách dòng tối ưu

### 3. Lưu Trữ Cài Đặt (SharedPreferences)

- ✅ Lưu kích thước font chữ
- ✅ Lưu chế độ tối/sáng
- ✅ Lưu trang cuối cùng đã đọc
- ✅ Lưu chương hiện tại
- ✅ Tự động khôi phục khi mở lại app

### 4. Điều Hướng & UI (Scaffold, AppBar, BottomNavigationBar)

- ✅ AppBar với tiêu đề và các nút điều khiển
- ✅ BottomNavigationBar với 3 tùy chọn:
  - Mở mục lục
  - Chuyển chương trước
  - Chuyển chương sau
- ✅ FloatingActionButton để xem thông tin và tiến độ
- ✅ Ẩn/hiện thanh điều khiển khi tap vào màn hình

### 5. Xử Lý Tệp (Assets)

- ✅ Đọc nội dung sách từ file JSON trong assets
- ✅ Parse dữ liệu JSON thành model
- ✅ Xử lý lỗi khi tải file

### 6. Tính năng Bổ Sung

- ✅ Chế độ tối/sáng
- ✅ Điều chỉnh kích thước chữ (12-32)
- ✅ Mục lục với khả năng chuyển chương nhanh
- ✅ Hiển thị tiến độ đọc
- ✅ Thông tin sách và vị trí đọc hiện tại
- ✅ Dialog cài đặt với preview trực tiếp
- ✅ UI responsive và mượt mà

## 📁 Cấu Trúc Dự Án

```
lib/
├── main.dart                          # Entry point của app
├── models/
│   └── book.dart                      # Model cho Book và Chapter
├── services/
│   ├── book_service.dart              # Service để đọc file sách
│   └── preferences_service.dart       # Service quản lý SharedPreferences
├── screens/
│   └── book_reader_screen.dart        # Màn hình đọc sách chính
└── widgets/
    ├── book_page_painter.dart         # CustomPainter vẽ trang sách
    ├── table_of_contents.dart         # Dialog mục lục
    └── settings_dialog.dart           # Dialog cài đặt

assets/
└── book.json                          # File dữ liệu sách (Truyện Kiều)
```

## 🛠️ Công Nghệ Sử Dụng

- **Flutter SDK**: Framework chính
- **shared_preferences**: Lưu trữ cài đặt người dùng
- **Material Design 3**: Giao diện hiện đại
- **CustomPainter**: Vẽ văn bản tùy chỉnh
- **PageView**: Hiệu ứng lật trang
- **JSON**: Format dữ liệu sách

## 🚀 Cách Chạy Ứng Dụng

1. **Cài đặt Flutter**:

   ```bash
   # Kiểm tra Flutter đã cài đặt chưa
   flutter doctor
   ```

2. **Cài đặt dependencies**:

   ```bash
   flutter pub get
   ```

3. **Chạy ứng dụng**:

   ```bash
   # Chạy trên emulator/device
   flutter run

   # Hoặc chạy trên Chrome (web)
   flutter run -d chrome
   ```

## 📖 Hướng Dẫn Sử Dụng

### Đọc Sách

1. Mở app, sách sẽ tự động tải
2. Vuốt trái/phải để chuyển trang
3. Tap vào màn hình để ẩn/hiện thanh điều khiển

### Điều Chỉnh Cài Đặt

1. Nhấn nút **Settings** (⚙️) trên AppBar
2. Kéo thanh trượt để điều chỉnh kích thước chữ
3. Xem preview trực tiếp
4. Nhấn "Áp dụng" để lưu

### Chuyển Đổi Chế Độ Tối/Sáng

- Nhấn nút **🌙/☀️** trên AppBar
- Cài đặt được lưu tự động

### Mục Lục

1. Nhấn nút "Mục lục" ở thanh dưới
2. Chọn chương muốn đọc
3. Chương hiện tại được highlight

### Xem Tiến Độ

- Nhấn nút **%** (FloatingActionButton) để xem % đã đọc
- Nhấn nút **ℹ️** để xem thông tin chi tiết

## 📝 Thêm Sách Mới

Để thêm sách mới, chỉnh sửa file `assets/book.json`:

```json
{
  "title": "Tên sách",
  "author": "Tác giả",
  "chapters": [
    {
      "title": "Tên chương",
      "content": "Nội dung chương..."
    }
  ]
}
```

## 🎨 Tùy Chỉnh Giao Diện

### Thay đổi màu chủ đề

Chỉnh sửa trong `lib/main.dart`:

```dart
colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
```

### Thay đổi font chữ mặc định

Chỉnh sửa trong `lib/widgets/book_page_painter.dart`:

```dart
fontFamily: 'Serif',
```

## 📱 Screenshots

Ứng dụng hỗ trợ:

- 📖 Chế độ sáng với nền trắng
- 🌙 Chế độ tối với nền đen
- 📏 Điều chỉnh kích thước chữ linh hoạt
- 📚 Mục lục dễ điều hướng
- ⚙️ Cài đặt trực quan

## 🔧 Yêu Cầu Hệ Thống

- Flutter SDK: >= 3.9.2
- Dart SDK: >= 3.0.0
- Android: minSdkVersion 21 trở lên
- iOS: iOS 11 trở lên

## 📚 Kiến Thức Áp Dụng

Dự án này áp dụng các kiến thức từ Flutter:

- **Chương 8**: Xử lý tệp từ assets
- **Chương 11**: SharedPreferences để lưu cài đặt
- **Chương 13**: CustomPainter để vẽ văn bản
- **Chương 16**:
  - PageView cho hiệu ứng lật trang
  - Scaffold, AppBar, BottomNavigationBar
  - Dialog và các widget phức tạp

## 🤝 Đóng Góp

Mọi đóng góp đều được chào đón! Hãy tạo Pull Request hoặc Issue nếu bạn có ý tưởng cải thiện.

## 📄 License

Dự án này được tạo ra cho mục đích học tập.

---

**Tác giả**: Được tạo bởi GitHub Copilot  
**Ngày tạo**: 11/11/2025  
**Sách mẫu**: Truyện Kiều - Nguyễn Du
