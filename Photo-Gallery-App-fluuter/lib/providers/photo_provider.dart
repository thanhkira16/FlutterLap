import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/photo.dart';
import '../utils/storage_util.dart';
import '../utils/permission_util.dart';

/// Provider for managing photo gallery state and operations
class PhotoProvider extends ChangeNotifier {
  final List<Photo> _photos = [];
  bool _isLoading = false;
  String? _errorMessage;
  final ImagePicker _imagePicker = ImagePicker();

  List<Photo> get photos => List.unmodifiable(_photos);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get photoCount => _photos.length;

  /// Initialize the provider and load existing photos
  Future<void> init() async {
    await loadPhotos();
  }

  /// Load all photos from local storage
  Future<void> loadPhotos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final photoPaths = await StorageUtil.getAllPhotoPaths();
      _photos.clear();

      for (final path in photoPaths) {
        final file = File(path);
        if (await file.exists()) {
          final photo = Photo(
            id: path.hashCode.toString(),
            filePath: path,
            capturedDate: file.statSync().modified,
          );
          _photos.add(photo);
        }
      }

      // Sort by captured date in descending order (newest first)
      _photos.sort((a, b) => b.capturedDate.compareTo(a.capturedDate));

      await _savePhotosMetadata();
    } catch (e) {
      _errorMessage = 'Failed to load photos: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Take a photo using the device camera
  Future<void> takePhoto() async {
    try {
      _errorMessage = null;

      // Request camera permission
      final hasPermission = await PermissionUtil.requestCameraPermission();
      if (!hasPermission) {
        _errorMessage = 'Camera permission denied';
        notifyListeners();
        return;
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await _addPhoto(File(pickedFile.path));
      }
    } catch (e) {
      _errorMessage = 'Failed to take photo: $e';
      notifyListeners();
    }
  }

  /// Pick a photo from the device gallery
  Future<void> pickFromGallery() async {
    try {
      _errorMessage = null;

      // Request gallery permission
      final hasPermission = await PermissionUtil.requestGalleryPermission();
      if (!hasPermission) {
        _errorMessage = 'Gallery permission denied';
        notifyListeners();
        return;
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        await _addPhoto(File(pickedFile.path));
      }
    } catch (e) {
      _errorMessage = 'Failed to pick photo: $e';
      notifyListeners();
    }
  }

  /// Pick multiple photos from the gallery
  Future<void> pickMultipleFromGallery() async {
    try {
      _errorMessage = null;

      // Request gallery permission
      final hasPermission = await PermissionUtil.requestGalleryPermission();
      if (!hasPermission) {
        _errorMessage = 'Gallery permission denied';
        notifyListeners();
        return;
      }

      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        for (final file in pickedFiles) {
          await _addPhoto(File(file.path));
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to pick multiple photos: $e';
      notifyListeners();
    }
  }

  /// Internal method to add a photo
  Future<void> _addPhoto(File photoFile) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Save photo to app directory
      final savedPath = await StorageUtil.savePhoto(photoFile);

      // Create Photo object
      final photo = Photo(
        id: savedPath.hashCode.toString(),
        filePath: savedPath,
        capturedDate: DateTime.now(),
      );

      // Add to photos list (insert at beginning for newest first)
      _photos.insert(0, photo);

      // Save metadata
      await _savePhotosMetadata();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to add photo: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete a photo by ID
  Future<void> deletePhoto(String photoId) async {
    try {
      final photoIndex = _photos.indexWhere((p) => p.id == photoId);
      if (photoIndex != -1) {
        final photo = _photos[photoIndex];
        await StorageUtil.deletePhoto(photo.filePath);
        _photos.removeAt(photoIndex);
        await _savePhotosMetadata();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = 'Failed to delete photo: $e';
      notifyListeners();
    }
  }

  /// Delete multiple photos
  Future<void> deleteMultiplePhotos(List<String> photoIds) async {
    try {
      for (final photoId in photoIds) {
        final photoIndex = _photos.indexWhere((p) => p.id == photoId);
        if (photoIndex != -1) {
          final photo = _photos[photoIndex];
          await StorageUtil.deletePhoto(photo.filePath);
        }
      }
      _photos.removeWhere((p) => photoIds.contains(p.id));
      await _savePhotosMetadata();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to delete photos: $e';
      notifyListeners();
    }
  }

  /// Clear all photos
  Future<void> clearAllPhotos() async {
    try {
      await StorageUtil.clearAllPhotos();
      _photos.clear();
      await _savePhotosMetadata();
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to clear photos: $e';
      notifyListeners();
    }
  }

  /// Save photos metadata to SharedPreferences
  Future<void> _savePhotosMetadata() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final photoJsonList = _photos.map((p) => jsonEncode(p.toJson())).toList();
      await prefs.setStringList('photos_metadata', photoJsonList);
    } catch (e) {
      // Silently fail - this is just for metadata caching
      if (kDebugMode) print('Failed to save photos metadata: $e');
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
