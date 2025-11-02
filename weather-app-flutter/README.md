#  Weather App - Flutter

Một ứng dụng thời tiết thông minh được xây dựng bằng Flutter, cho phép người dùng xem thông tin thời tiết theo vị trí GPS hiện tại hoặc tìm kiếm theo tên thành phố với tính năng autocomplete giống Google Maps.

##  Chức năng chính

-  **Thời tiết theo GPS** - Tự động lấy thời tiết tại vị trí hiện tại
-  **Tìm kiếm thành phố** với autocomplete thông minh
-  **Dự báo 5 ngày** - Hiển thị thời tiết cho 5 ngày tới với cuộn ngang
-  **Hiển thị chi tiết** nhiệt độ, mô tả, tọa độ, thời gian cập nhật
-  **Làm mới** dữ liệu thời tiết real-time với nút reload

##  Công nghệ & Kỹ thuật

### **API Integration**
- **OpenWeatherMap Current Weather API** - Real-time weather data
- **OpenWeatherMap 5-day Forecast API** - Extended weather predictions  
- **OpenWeatherMap Geocoding API** - Location search and coordinates

### **Location Services**
- **Geolocator** - GPS location access
- **Location Permissions** - Runtime permission handling
- **Position Tracking** - Latitude/longitude coordinates

### **UI Components**
- **Material Design** - Google's design system
- **FutureBuilder** - Async data loading for weather and forecast
- **TypeAheadField** - Autocomplete search input với gợi ý thông minh
- **AppBar** - Navigation with reload action button
- **Horizontal ScrollView** - 5-day forecast cards với swipe gesture
- **Weather Icons** - Visual representation of weather conditions
- **Loading States** - User feedback during API calls

### **Architecture**
- **Service-Model-View** pattern với clean separation
- **Separation of Concerns** - Services, Models, Screens rõ ràng
- **Environment Variables** - Secure API key management với .env
- **State Management** - Efficient setState với Future-based loading
- **Code Structure** - Professional organization without redundant comments

##  Cài đặt và Chạy

### **Yêu cầu hệ thống**
- Flutter SDK (3.9.2 hoặc mới hơn)
- Dart SDK  
- Android Studio / VS Code với Flutter extension
- Android Emulator hoặc thiết bị Android thật
- Web browser (Chrome/Edge) cho web development
- **OpenWeatherMap API Key** (miễn phí, đăng ký tại openweathermap.org)

### **1. Clone repository**
```bash
git clone https://github.com/bichle04/weather-app-flutter.git
cd weather_app
```

### **2. Cài đặt dependencies**
```bash
flutter pub get
```

### **3. Cấu hình API Key**

#### **Lấy API Key miễn phí:**
1. Truy cập [OpenWeatherMap API](https://openweathermap.org/api)
2. Đăng ký tài khoản miễn phí
3. Vào **API Keys** section trong dashboard
4. Copy API key của bạn

#### **Thiết lập Environment:**
```bash
# Copy file template
cp .env.example .env

# Mở file .env và thay thế:
OPENWEATHER_API_KEY=your_actual_api_key_here
```


### **4. Chạy ứng dụng**

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

#### **Trên Windows Desktop:**
```bash
# Cần bật Developer Mode trước
# Run: start ms-settings:developers
flutter run -d windows
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

### **5. Development workflow**
```bash
# Chạy với hot reload
flutter run

# Trong terminal flutter run:
# r - Hot reload
# R - Hot restart  
# q - Quit
```

##  Dependencies chính

```yaml
dependencies:
  flutter: sdk
  geolocator: ^13.0.1      # GPS location services
  http: ^1.2.2             # HTTP client for API calls
  flutter_dotenv: ^5.1.0   # Environment variables management  
  flutter_typeahead: ^5.2.0 # Autocomplete search với suggestions
```