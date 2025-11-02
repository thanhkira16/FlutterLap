#  Note App - Flutter

Một ứng dụng ghi chú đơn giản được xây dựng bằng Flutter với Provider State Management, cho phép người dùng tạo, chỉnh sửa và xóa ghi chú một cách dễ dàng.

##  Chức năng chính

-  **Tạo ghi chú mới** với tiêu đề và nội dung
-  **Chỉnh sửa ghi chú** hiện có 
-  **Xóa ghi chú** với xác nhận
-  **Làm mới** danh sách ghi chú

##  Công nghệ & Kỹ thuật

### **Framework & Language**
- **Flutter** - Cross-platform development framework
- **Dart** - Programming language

### **State Management**
- **Provider** - State management solution
- **ChangeNotifier** - Observable pattern implementation
- **Consumer** - Widget để listen state changes

### **UI Components**
- **Material Design** - Google's design system
- **TextField/TextFormField** - Input components với validation
- **FloatingActionButton** - Primary action button
- **AppBar** - Navigation bar with actions
- **ListView** - Scrollable list display
- **Card** - Content containers
- **SnackBar** - Feedback messages

### **Architecture**
- **Model-View-Provider (MVP)** pattern
- **Separation of Concerns** - Models, Providers, Screens
- **Clean Code** principles

##  Cài đặt và Chạy

### **Yêu cầu hệ thống**
- Flutter SDK (3.9.2 hoặc mới hơn)
- Dart SDK
- Android Studio / VS Code
- Android Emulator hoặc thiết bị Android
- Web browser (Chrome/Edge) cho web development

### **1. Clone repository**
```bash
git clone https://github.com/bichle04/notes-app-flutter.git
cd note_app
```

### **2. Cài đặt dependencies**
```bash
flutter pub get
```

### **3. Chạy ứng dụng**

#### **Trên Android Emulator:**
```bash
# Khởi động emulator
flutter emulators --launch <emulator_id>

# Chạy app
flutter run
```

#### **Trên Web Browser:**
```bash
flutter run -d chrome
```

#### **Build cho production:**
```bash
# Android APK
flutter build apk

# Web
flutter build web

# iOS (trên macOS)
flutter build ios
```

### **4. Development workflow**
```bash
# Chạy với hot reload
flutter run

# Trong terminal flutter run:
# r - Hot reload
# R - Hot restart  
# q - Quit

```
