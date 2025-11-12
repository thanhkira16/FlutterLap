# Todo App - Clean Architecture

## Giới thiệu

Đây là ứng dụng Todo App được xây dựng bằng Flutter. Ứng dụng cho phép quản lý danh sách công việc với khả năng lưu trữ offline hoàn toàn.

## Mục tiêu

- Quản lý danh sách công việc đơn giản và hiệu quả
- Áp dụng Clean Architecture để tổ chức code
- Tuân thủ các nguyên tắc SOLID
- Sử dụng Local State Management với setState()
- Lưu trữ dữ liệu offline với SharedPreferences

## Tính năng chính

### 1. Quản lý công việc
- Thêm công việc mới với tiêu đề và mô tả
- Đánh dấu hoàn thành công việc
- Xóa công việc với xác nhận
- Sắp xếp tự động (công việc chưa hoàn thành trước)

### 2. Thống kê
- Tổng số công việc
- Số công việc đang chờ
- Số công việc đã hoàn thành
- Tỷ lệ hoàn thành (%)

### 3. Lưu trữ Offline
- Tự động lưu trữ vào bộ nhớ local
- Không cần kết nối internet
- Dữ liệu được bảo toàn sau khi đóng app

### 4. Giao diện người dùng
- Material Design 3
- Dark mode tự động
- Responsive layout
- Animations mượt mà

## Kiến trúc Clean Architecture

### Cấu trúc thư mục

```
lib/
├── main.dart                     # Entry point
├── core/                         # Shared utilities
│   ├── constants/
│   ├── theme/
│   └── utils/
├── domain/                       # Business logic
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── data/                         # Data layer
│   ├── models/
│   ├── datasources/
│   └── repositories/
└── presentation/                 # UI layer
    ├── pages/
    ├── widgets/
    └── state/
```



## Cài đặt và Chạy

### Yêu cầu

- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2

### Cài đặt dependencies

```bash
flutter pub get
```

### Chạy ứng dụng

```bash
# Chạy trên device/emulator
flutter run

# Chạy trên Chrome
flutter run -d chrome

# Chạy trên Windows
flutter run -d windows
```

### Build

```bash
# Build APK (Android)
flutter build apk --release

# Build App Bundle (Android)
flutter build appbundle

# Build iOS
flutter build ios --release

# Build Windows
flutter build windows --release
```

## Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  shared_preferences: ^2.2.2
```
