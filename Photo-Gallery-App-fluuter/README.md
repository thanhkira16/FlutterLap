# � Photo Gallery App - Flutter

A beautiful and feature-rich photo gallery application built with Flutter and Dart. Capture photos with your device camera, select photos from your gallery, and manage them with ease. All photos are stored locally on your device with a responsive grid layout and fullscreen viewing experience.

## 📱 Features

### Core Functionality
- ✅ **Take Photos** - Capture photos using device camera
- ✅ **Select Photos** - Pick single or multiple photos from gallery
- ✅ **View Photos** - Display photos in responsive 3-column grid layout
- ✅ **Fullscreen View** - View photos in fullscreen with Hero animation
- ✅ **Delete Photos** - Remove individual photos or batch delete

### Advanced Features
- 🔍 **Interactive Zoom** - Pinch-to-zoom in fullscreen view (0.5x to 3.0x)
- �️ **Photo Metadata** - View capture date, file path, and file size
- � **Batch Operations** - Select multiple photos and delete all at once
- 🎯 **Selection Mode** - Long-press to select, visual feedback with checkmarks
- 📊 **Photo Information** - Dialog showing detailed photo metadata

### Data Management
- 💾 **Local Storage** - All photos stored locally using path_provider
- � **Organized Structure** - Photos stored in app-specific directory
- � **Unique Naming** - UUID-based filenames prevent conflicts
- � **Date Tracking** - Capture date stored with each photo

### UI/UX
- 🌓 **Dark/Light Mode** - Beautiful Material Design 3 themed application
- 📱 **Responsive Design** - Adaptive grid layout for different screen sizes
- ⚡ **Smooth Animations** - Fluid Hero transitions and interactions
- 🎨 **Beautiful UI** - Clean, modern interface with Material Design
- ✨ **Empty State** - Helpful message when no photos available
- ⚠️ **Error Handling** - Graceful error messages and recovery

## 🏗️ Technical Architecture

### Framework & Language
- **Flutter** - Cross-platform mobile development framework
- **Dart** - Programming language for Flutter

### Key Technologies
| Component | Package | Version | Purpose |
|-----------|---------|---------|---------|
| State Management | Provider | ^6.1.2 | Efficient state management with ChangeNotifier |
| Image Picker | image_picker | ^1.1.2 | Camera and gallery access |
| Permissions | permission_handler | ^11.4.4 | Runtime permission requests |
| File Storage | path_provider | ^2.1.2 | Access app storage directory |
| Data Caching | shared_preferences | ^2.2.2 | Store metadata |
| ID Generation | uuid | ^4.0.0 | Unique identifier generation |
| Date Formatting | intl | ^0.20.1 | Internationalization and date formatting |

### Architecture Pattern
- **Model-View-Provider (MVP)** - Clean separation of concerns
- **Provider Pattern** - Reactive state management with ChangeNotifier
- **Local First** - All data persisted locally on device
- **Provider Pattern** - Reactive state management
- **Local First** - All data persisted locally for offline access

### Data Model
```dart
class Photo {
  String id;           // Unique identifier (UUID v4)
  String filePath;     // Local file path to photo
  DateTime capturedDate; // Date and time photo was taken/captured
}
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.9.2 or newer)
- Dart SDK (included with Flutter)
- Android Studio, Xcode, or VS Code with Flutter extension
- Android Emulator, iOS Simulator, or physical device

### Installation

1. **Navigate to project directory:**
```bash
cd Expense_Tracker_flutter_lap7
```

2. **Install dependencies:**
```bash
flutter pub get
```

3. **Run the app:**

#### On Android Emulator/Device:
```bash
flutter run
```

#### On iOS Simulator:
```bash
flutter run
```

#### On Web:
```bash
flutter run -d chrome
```

#### With Release Mode:
```bash
flutter run --release
```

## 📖 Usage Guide

### Taking a Photo
1. Tap the **Camera** FloatingActionButton at the bottom right
2. Allow camera permission when prompted
3. Take a photo using your device camera
4. Photo is automatically saved to gallery

### Selecting Photos from Gallery
1. Tap the **Gallery** FloatingActionButton (single photo) or **Multiple Gallery** (multiple photos)
2. Allow gallery permission when prompted
3. Select photo(s) from your device gallery
4. Photos are copied to app storage

### Viewing Photos in Fullscreen
1. Tap any photo in the grid
2. Photo opens in fullscreen with Hero animation
3. **Pinch and zoom** to zoom in/out (0.5x to 3.0x)
4. **Drag** to pan when zoomed in
5. Tap the **info icon** to see photo metadata (date, path, size)

### Deleting Photos
1. **Single Delete**: Long-press a photo to select it (blue checkmark appears)
2. **Multiple Delete**: Long-press multiple photos to select them
3. **Batch Delete**: Press menu → "Delete All" for all photos
4. Confirm deletion in the dialog

### Photo Selection Mode
- **Long-press** any photo to enter selection mode
- Photos show **blue checkmarks** when selected
- Tap **"Select All"** from options menu to select all
- Tap **"Delete"** button to delete selected photos
- Tap photos to deselect or tap **"Cancel"** to exit selection

## 📁 Project Structure

```
lib/
├── main.dart                          # App entry point, PhotoProvider initialization
├── models/
│   └── photo.dart                     # Photo model with file handling
├── providers/
│   └── photo_provider.dart            # State management with ChangeNotifier
├── screens/
│   ├── home_screen.dart              # Main gallery grid screen
│   └── fullscreen_photo_screen.dart  # Fullscreen viewer with zoom
├── widgets/
│   └── expense_chart.dart            # (Deprecated - kept for reference)
├── utils/
│   ├── storage_util.dart             # File operations and storage
│   └── permission_util.dart          # Permission request handling
└── theme/
    └── app_themes.dart               # Light and dark theme definitions
```

## 🎯 Key Implementation Details

### State Management
```dart
// PhotoProvider extends ChangeNotifier
- init()                      // Initialize and load photos
- loadPhotos()               // Reload all photos
- takePhoto()                // Capture photo with camera
- pickFromGallery()          // Select single photo
- pickMultipleFromGallery()  // Select multiple photos
- deletePhoto()              // Delete single photo
- deleteMultiplePhotos()     // Batch delete photos
- clearAllPhotos()           // Delete all photos
```

### Local Storage
```dart
// Storage utility functions
- getPhotosDirectory()       // Get app storage directory
- generatePhotoFileName()    // Create unique UUID-based filename
- savePhoto()               // Copy photo to app storage
- deletePhoto()             // Remove photo file
- getAllPhotoPaths()        // Get all stored photos
- clearAllPhotos()          // Remove all photos
```

### Permission Handling
```dart
// Permission utility functions
- requestCameraPermission()     // Ask for camera access
- requestGalleryPermission()    // Ask for gallery access
- isCameraPermissionGranted()   // Check camera status
- isGalleryPermissionGranted()  // Check gallery status
```

## 🎨 UI Components

### Widgets Used
- `Scaffold` - Main app structure
- `GridView.builder` - 3-column grid for photo display
- `Image.file` - Display photos from file system
- `FloatingActionButton` - Multiple FABs for actions
- `Hero` - Smooth animation for fullscreen transition
- `InteractiveViewer` - Pinch-zoom and pan functionality
- `Card` - Photo item containers
- `Dialog` - Photo info and delete confirmation
- `ListView.builder` - Efficient list rendering
- `AlertDialog` - Confirmation dialogs

### Theme Features
- Material Design 3 color schemes
- Adaptive colors for light/dark modes
- Custom input decoration
- Consistent spacing and padding
- Rounded corners and shadows
- Primary: #2196F3 (Blue)
- Accent: #FF9800 (Orange)

## 🏗️ Build Instructions

### Debug Build
```bash
flutter build apk --debug
flutter build ios
```

### Release Build
```bash
# Android APK
flutter build apk --release

# Android App Bundle (Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 📂 Storage Details

### Photo Storage Location
```
/data/data/com.example.photo_gallery_app/app_flutter/gallery_photos/ (Android)
/Documents/gallery_photos/ (iOS)
```

### Photo Naming
- Format: `{UUID}.jpg`
- Example: `550e8400-e29b-41d4-a716-446655440000.jpg`
- Benefits: Unique, no conflicts, sortable by date

## 🐛 Troubleshooting

### Common Issues

**Issue: "flutter: Unhandled Exception: Permission denied"**
```bash
# Solution: Check Android/iOS permission configurations
# Android: Check AndroidManifest.xml for permissions
# iOS: Check Info.plist for permission descriptions
```

**Issue: Photos not loading**
- Ensure `flutter pub get` completed successfully
- Check that photos directory is created
- Verify file permissions are granted
- Try: `flutter clean && flutter pub get`

**Issue: App crashes on launch**
- Delete app data: `flutter clean`
- Clear app cache on device
- Reinstall app
- Check Logcat/console for detailed errors

**Issue: Camera not working**
- Grant camera permission when prompted
- Check AndroidManifest.xml/Info.plist
- Test on physical device (emulator may lack camera)
- Verify permission_handler package installed

**Issue: Gallery selection not working**
- Grant gallery/storage permission when prompted
- Check file permissions
- Verify image_picker package installed
- Try: `flutter pub get`

**Issue: Photos not saving**
- Check storage permissions granted
- Verify app has write access
- Check available storage space
- Try different photos

## ✨ Future Enhancements

- 🏷️ **Photo Tagging** - Add tags to photos for organization
- � **Albums** - Organize photos into albums
- � **Search** - Search photos by date or metadata
- 🎨 **Filters** - Apply image filters and effects
- � **Export** - Share or backup photos
- 📍 **Location** - Store photo location if available
- � **Sharing** - Share photos with others
- 📹 **Video** - Support for video capture
- � **Encryption** - Add PIN/Biometric security
- ☁️ **Cloud Backup** - Backup to cloud storage

## 📝 License

This project is licensed under the MIT License - see LICENSE file for details.

## 📚 Learning Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language](https://dart.dev)
- [image_picker Package](https://pub.dev/packages/image_picker)
- [permission_handler Package](https://pub.dev/packages/permission_handler)
- [path_provider Package](https://pub.dev/packages/path_provider)
- [Provider Pattern](https://pub.dev/packages/provider)

**Built with ❤️ using Flutter**
