@echo off
REM Firebase Setup Script for Windows Command Prompt
REM Chay script nay de setup Firebase cho du an

echo ================================
echo    FIREBASE SETUP SCRIPT
echo ================================
echo.

echo Buoc 1: Kiem tra Node.js...
where node >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Node.js chua duoc cai dat!
    echo Vui long tai va cai dat Node.js tu: https://nodejs.org/
    echo Sau do chay lai script nay.
    pause
    exit /b
)
echo [OK] Node.js da cai dat
echo.

echo Buoc 2: Cai dat Firebase CLI...
call npm install -g firebase-tools
echo [OK] Firebase CLI da duoc cai dat
echo.

echo Buoc 3: Dang nhap Firebase...
echo Trinh duyet se mo de ban dang nhap Google...
call firebase login
echo [OK] Dang nhap Firebase thanh cong
echo.

echo Buoc 4: Kiem tra Dart...
where dart >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Dart chua duoc cai dat!
    echo Vui long cai dat Flutter SDK
    pause
    exit /b
)
echo [OK] Dart da cai dat
echo.

echo Buoc 5: Cai dat FlutterFire CLI...
call dart pub global activate flutterfire_cli
echo [OK] FlutterFire CLI da duoc cai dat
echo.

echo Buoc 6: Cau hinh Firebase cho project...
echo Ban se duoc hoi:
echo   - Chon Firebase project (hoac tao moi)
echo   - Chon platforms (Android, iOS, Web)
echo.
pause

call flutterfire configure

echo.
echo ================================
echo    CAC BUOC TIEP THEO:
echo ================================
echo.
echo 1. Truy cap Firebase Console: https://console.firebase.google.com/
echo.
echo 2. Bat Authentication:
echo    - Chon project cua ban
echo    - Vao 'Authentication' ^> 'Sign-in method'
echo    - Bat 'Email/Password'
echo.
echo 3. Tao Firestore Database:
echo    - Vao 'Firestore Database'
echo    - Click 'Create database'
echo    - Chon 'Test mode' (cho development)
echo    - Chon location: asia-southeast1
echo.
echo 4. Cau hinh Security Rules:
echo    - Trong Firestore, tab 'Rules'
echo    - Copy rules tu file FIREBASE_SETUP.md
echo.
echo 5. Chay ung dung:
echo    flutter run
echo.
echo ================================

pause
