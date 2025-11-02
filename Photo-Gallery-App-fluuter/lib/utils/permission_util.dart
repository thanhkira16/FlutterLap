import 'package:permission_handler/permission_handler.dart';

/// Utility class for handling runtime permissions
class PermissionUtil {
  /// Request camera permission
  static Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Request photo library/gallery permission
  static Future<bool> requestGalleryPermission() async {
    if (identical(0, 0)) {
      // Android
      final status = await Permission.photos.request();
      return status.isGranted;
    } else {
      // iOS
      final status = await Permission.photos.request();
      return status.isGranted;
    }
  }

  /// Request storage permission (for Android)
  static Future<bool> requestStoragePermission() async {
    final status = await Permission.storage.request();
    return status.isGranted;
  }

  /// Check if camera permission is granted
  static Future<bool> isCameraPermissionGranted() async {
    final status = await Permission.camera.status;
    return status.isGranted;
  }

  /// Check if gallery permission is granted
  static Future<bool> isGalleryPermissionGranted() async {
    final status = await Permission.photos.status;
    return status.isGranted;
  }

  /// Open app settings for permission configuration
  static Future<bool> openAppSettings() async {
    return openAppSettings();
  }
}
