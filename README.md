# 💰 Ứng dụng Quản lý Chi tiêu Cá nhân

Ứng dụng quản lý tài chính cá nhân được xây dựng bằng Flutter, giúp bạn theo dõi thu chi, phân tích chi tiêu và quản lý ngân sách hiệu quả.

## 📱 Tính năng chính

### 1. Quản lý Giao dịch
-  **Thêm giao dịch mới** với các thông tin:
  - Loại: Thu nhập / Chi tiêu
  - Số tiền (VND)
  - Mô tả chi tiết
  - Danh mục (Ăn uống, Mua sắm, Di chuyển, Lương, Thưởng, v.v.)
  - Ngày giao dịch
-  **Chỉnh sửa giao dịch** - Tap vào giao dịch để sửa
-  **Xóa giao dịch** - Swipe sang trái với xác nhận

### 2. Hiển thị Danh sách
-  **Nhóm theo ngày** - Tự động group giao dịch
-  **Hiển thị thông minh**:
  - "Hôm nay" cho ngày hiện tại
  - "Hôm qua" cho ngày trước đó
  - "Thứ X, dd/MM/yyyy" cho các ngày khác
-  **Pull to refresh** - Vuốt xuống để tải lại
-  **Filter theo tháng** - Lọc giao dịch theo tháng/năm
-  **Tổng quan nhanh**:
  - Tổng thu nhập
  - Tổng chi tiêu
  - Số dư hiện tại

### 3. Thống kê & Biểu đồ
-  **Tổng quan tháng**:
  - Thu nhập trong tháng
  - Chi tiêu trong tháng
  - Số dư tháng
-  **Biểu đồ Tròn (Pie Chart)**:
  - Tỷ lệ chi tiêu theo danh mục
  - Interactive - Touch để highlight
  - Legend chi tiết với màu sắc
-  **Biểu đồ Cột (Bar Chart)**:
  - Chi tiêu theo ngày trong tháng
  - Touch tooltip hiển thị chi tiết
  - Auto scale theo dữ liệu
-  **Thống kê bổ sung**:
  - Danh mục chi nhiều nhất
  - Chi tiêu trung bình mỗi ngày

### 4. Giao diện & Trải nghiệm
-  **Material Design 3** - Giao diện hiện đại
-  **Animations mượt mà** - Page transitions
-  **Icons đa dạng** - 12+ icons theo danh mục
-  **Responsive** - Hỗ trợ nhiều kích thước màn hình
-  **Tiếng Việt** - Hỗ trợ đầy đủ locale Việt Nam
-  **Empty states** - UI thân thiện khi chưa có dữ liệu

## 🚀 Cài đặt

### Yêu cầu
- Flutter SDK 3.0 trở lên
- Dart SDK 3.0 trở lên
- Android Studio / VS Code

### Các bước cài đặt

1. **Cài đặt dependencies**
```bash
flutter pub get
```

2. **Chạy ứng dụng**
```bash
flutter run
```

## 📖 Hướng dẫn sử dụng

### Thêm giao dịch
1. Nhấn nút + ở góc dưới
2. Chọn loại (Chi tiêu/Thu nhập)
3. Nhập số tiền, mô tả, chọn danh mục và ngày
4. Nhấn THÊM GIAO DỊCH

### Chỉnh sửa/Xóa
- **Sửa**: Tap vào giao dịch
- **Xóa**: Swipe sang trái

### Xem thống kê
- Chuyển sang tab Thống kê
- Chọn tháng để xem biểu đồ

## 🏗️ Kiến trúc

- **Framework**: Flutter 3.x
- **Database**: SQLite (sqflite)
- **State Management**: Provider
- **Charts**: fl_chart

---

**Made with ❤️ using Flutter**
