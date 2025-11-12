# Personal Profile App

Ứng dụng hồ sơ cá nhân được xây dựng bằng Flutter 

## Mô tả dự án

Personal Profile App là một ứng dụng hiển thị thông tin cá nhân, bao gồm:
- Thông tin cá nhân (tên, chức danh, tiểu sử)
- Ảnh đại diện
- Danh sách kỹ năng với thanh tiến trình
- Liên kết mạng xã hội
- Chế độ Dark Mode / Light Mode

## Tính năng chính

- **Responsive UI**: Giao diện tự động điều chỉnh theo kích thước màn hình
- **Dark Mode Toggle**: Chuyển đổi giữa chế độ sáng và tối
- **State Management**: Sử dụng Provider để quản lý state
- **Material Design 3**: UI hiện đại với Material Design 3

## Cấu trúc thư mục

```
lib/
├── main.dart                           # Entry point, dependency injection
├── core/                               # Core functionality
│   ├── constants/
│   │   └── app_constants.dart          # App-wide constants
│   └── theme/
│       ├── app_theme.dart              # Theme configuration
│       └── theme_provider.dart         # Theme state management
└── features/
    └── profile/                        # Profile feature
        ├── data/                       # Data layer
        │   ├── datasources/
        │   │   └── profile_local_datasource.dart
        │   ├── models/
        │   │   ├── profile_model.dart
        │   │   ├── skill_model.dart
        │   │   └── social_link_model.dart
        │   └── repositories/
        │       └── profile_repository_impl.dart
        ├── domain/                     # Domain layer (Business logic)
        │   ├── entities/
        │   │   ├── profile.dart
        │   │   ├── skill.dart
        │   │   └── social_link.dart
        │   ├── repositories/
        │   │   └── profile_repository.dart
        │   └── usecases/
        │       └── get_profile_usecase.dart
        └── presentation/               # Presentation layer (UI)
            ├── pages/
            │   └── profile_page.dart
            ├── providers/
            │   └── profile_provider.dart
            └── widgets/
                ├── profile_header.dart
                ├── skills_section.dart
                ├── social_links_section.dart
                └── theme_toggle_button.dart
```

## Cài đặt và chạy

### 1. Clone repository

```bash
git clone <repository-url>
cd lab1_profile_app
```

### 2. Cài đặt dependencies

```bash
flutter pub get
```

### 3. Chạy ứng dụng

#### Trên Android Emulator:
```bash
# Liệt kê devices
flutter devices

# Khởi động emulator
flutter emulators --launch <emulator_name>

# Chạy app
flutter run -d <device_id>
```

#### Trên Windows Desktop:
```bash
flutter run -d windows
```

#### Trên Web:
```bash
flutter run -d chrome
```

### 4. Build release

#### Android APK:
```bash
flutter build apk --release
```

#### Windows:
```bash
flutter build windows --release
```
