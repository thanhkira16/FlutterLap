import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Utility class for handling local file storage operations
class StorageUtil {
  static const String _photosFolderName = 'gallery_photos';
  static const uuid = Uuid();

  /// Get the directory where photos will be stored
  static Future<Directory> getPhotosDirectory() async {
    final appDir = await getApplicationDocumentsDirectory();
    final photosDir = Directory('${appDir.path}/$_photosFolderName');

    if (!await photosDir.exists()) {
      await photosDir.create(recursive: true);
    }

    return photosDir;
  }

  /// Generate a unique filename for a photo
  static String generatePhotoFileName() {
    return 'photo_${uuid.v4()}.jpg';
  }

  /// Save a photo file to the gallery directory
  static Future<String> savePhoto(File sourceFile) async {
    try {
      final photosDir = await getPhotosDirectory();
      final fileName = generatePhotoFileName();
      final destinationPath = '${photosDir.path}/$fileName';

      final savedFile = await sourceFile.copy(destinationPath);
      return savedFile.path;
    } catch (e) {
      throw Exception('Failed to save photo: $e');
    }
  }

  /// Delete a photo file
  static Future<void> deletePhoto(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw Exception('Failed to delete photo: $e');
    }
  }

  /// Get all photos from the gallery directory
  static Future<List<String>> getAllPhotoPaths() async {
    try {
      final photosDir = await getPhotosDirectory();

      if (!await photosDir.exists()) {
        return [];
      }

      final files = photosDir.listSync();
      return files
          .whereType<File>()
          .where((file) => _isImageFile(file.path))
          .map((file) => file.path)
          .toList()
        ..sort(
          (a, b) => File(
            b,
          ).statSync().modified.compareTo(File(a).statSync().modified),
        );
    } catch (e) {
      throw Exception('Failed to get photos: $e');
    }
  }

  /// Check if a file is an image based on extension
  static bool _isImageFile(String path) {
    final imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
    final extension = path.split('.').last.toLowerCase();
    return imageExtensions.contains(extension);
  }

  /// Clear all photos from the gallery directory
  static Future<void> clearAllPhotos() async {
    try {
      final photosDir = await getPhotosDirectory();

      if (await photosDir.exists()) {
        final files = photosDir.listSync();
        for (var file in files) {
          if (file is File) {
            await file.delete();
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to clear photos: $e');
    }
  }
}
