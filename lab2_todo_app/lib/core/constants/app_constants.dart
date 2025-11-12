/// Application-wide constants
/// Following Single Responsibility Principle (SRP)
class AppConstants {
  AppConstants._(); // Private constructor to prevent instantiation

  // Storage keys
  static const String todosStorageKey = 'todos_storage_key';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double itemSpacing = 8.0;
  static const double borderRadius = 12.0;

  // Animation durations
  static const int animationDurationMs = 300;
}
