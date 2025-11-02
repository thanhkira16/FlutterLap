import 'dart:io';

/// Represents a single photo in the gallery
class Photo {
  final String id;
  final String filePath;
  final DateTime capturedDate;

  Photo({required this.id, required this.filePath, required this.capturedDate});

  /// Get the File object for this photo
  File getFile() => File(filePath);

  /// Convert Photo to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'filePath': filePath,
      'capturedDate': capturedDate.toIso8601String(),
    };
  }

  /// Create Photo from JSON
  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'] as String,
      filePath: json['filePath'] as String,
      capturedDate: DateTime.parse(json['capturedDate'] as String),
    );
  }

  /// Check if the photo file exists
  bool get exists => getFile().existsSync();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          filePath == other.filePath;

  @override
  int get hashCode => id.hashCode ^ filePath.hashCode;
}
