# Firebase Setup Script for Windows PowerShell
# Chạy script này để setup Firebase cho dự án

Write-Host "================================" -ForegroundColor Cyan
Write-Host "🔥 FIREBASE SETUP SCRIPT" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""

# Kiểm tra Node.js
Write-Host "📦 Bước 1: Kiểm tra Node.js..." -ForegroundColor Yellow
if (Get-Command node -ErrorAction SilentlyContinue) {
    $nodeVersion = node --version
    Write-Host "✅ Node.js đã cài đặt: $nodeVersion" -ForegroundColor Green
} else {
    Write-Host "❌ Node.js chưa được cài đặt!" -ForegroundColor Red
    Write-Host "Vui lòng tải và cài đặt Node.js từ: https://nodejs.org/" -ForegroundColor Yellow
    Write-Host "Sau đó chạy lại script này." -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""

# Cài đặt Firebase CLI
Write-Host "🔧 Bước 2: Cài đặt Firebase CLI..." -ForegroundColor Yellow
Write-Host "Đang cài đặt firebase-tools..." -ForegroundColor Gray
npm install -g firebase-tools
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Firebase CLI đã được cài đặt" -ForegroundColor Green
} else {
    Write-Host "⚠️ Có lỗi khi cài Firebase CLI" -ForegroundColor Red
}

Write-Host ""

# Đăng nhập Firebase
Write-Host "🔐 Bước 3: Đăng nhập Firebase..." -ForegroundColor Yellow
Write-Host "Trình duyệt sẽ mở để bạn đăng nhập Google..." -ForegroundColor Gray
firebase login
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Đăng nhập Firebase thành công" -ForegroundColor Green
} else {
    Write-Host "⚠️ Đăng nhập Firebase thất bại" -ForegroundColor Red
}

Write-Host ""

# Kiểm tra Dart
Write-Host "📦 Bước 4: Kiểm tra Dart..." -ForegroundColor Yellow
if (Get-Command dart -ErrorAction SilentlyContinue) {
    $dartVersion = dart --version 2>&1 | Out-String
    Write-Host "✅ Dart đã cài đặt" -ForegroundColor Green
} else {
    Write-Host "❌ Dart chưa được cài đặt!" -ForegroundColor Red
    Write-Host "Vui lòng cài đặt Flutter SDK" -ForegroundColor Yellow
    pause
    exit
}

Write-Host ""

# Cài đặt FlutterFire CLI
Write-Host "🔧 Bước 5: Cài đặt FlutterFire CLI..." -ForegroundColor Yellow
Write-Host "Đang cài đặt flutterfire_cli..." -ForegroundColor Gray
dart pub global activate flutterfire_cli
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ FlutterFire CLI đã được cài đặt" -ForegroundColor Green
} else {
    Write-Host "⚠️ Có lỗi khi cài FlutterFire CLI" -ForegroundColor Red
}

Write-Host ""

# Cấu hình Firebase
Write-Host "⚙️ Bước 6: Cấu hình Firebase cho project..." -ForegroundColor Yellow
Write-Host "Bạn sẽ được hỏi:" -ForegroundColor Gray
Write-Host "  - Chọn Firebase project (hoặc tạo mới)" -ForegroundColor Gray
Write-Host "  - Chọn platforms (Android, iOS, Web)" -ForegroundColor Gray
Write-Host ""
Write-Host "Nhấn Enter để tiếp tục..." -ForegroundColor Cyan
pause

flutterfire configure

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Cấu hình Firebase thành công!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📝 File 'lib/firebase_options.dart' đã được tạo" -ForegroundColor Green
} else {
    Write-Host "⚠️ Có lỗi khi cấu hình Firebase" -ForegroundColor Red
}

Write-Host ""
Write-Host "================================" -ForegroundColor Cyan
Write-Host "📋 CÁC BƯỚC TIẾP THEO:" -ForegroundColor Cyan
Write-Host "================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Truy cập Firebase Console: https://console.firebase.google.com/" -ForegroundColor Yellow
Write-Host ""
Write-Host "2. Bật Authentication:" -ForegroundColor Yellow
Write-Host "   - Chọn project của bạn" -ForegroundColor Gray
Write-Host "   - Vào 'Authentication' > 'Sign-in method'" -ForegroundColor Gray
Write-Host "   - Bật 'Email/Password'" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Tạo Firestore Database:" -ForegroundColor Yellow
Write-Host "   - Vào 'Firestore Database'" -ForegroundColor Gray
Write-Host "   - Click 'Create database'" -ForegroundColor Gray
Write-Host "   - Chọn 'Test mode' (cho development)" -ForegroundColor Gray
Write-Host "   - Chọn location: asia-southeast1" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Cấu hình Security Rules:" -ForegroundColor Yellow
Write-Host "   - Trong Firestore, tab 'Rules'" -ForegroundColor Gray
Write-Host "   - Copy rules từ file FIREBASE_SETUP.md" -ForegroundColor Gray
Write-Host ""
Write-Host "5. Chạy ứng dụng:" -ForegroundColor Yellow
Write-Host "   flutter run" -ForegroundColor Cyan
Write-Host ""
Write-Host "================================" -ForegroundColor Cyan

Write-Host ""
Write-Host "Nhấn Enter để đóng..." -ForegroundColor Gray
pause
