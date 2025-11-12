/// Utility class for date formatting
/// Following Single Responsibility Principle (SRP)
class DateFormatter {
  DateFormatter._(); // Private constructor

  /// Format DateTime to readable string
  static String formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today ${_formatTime(date)}';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday ${_formatTime(date)}';
    } else {
      return '${date.day}/${date.month}/${date.year} ${_formatTime(date)}';
    }
  }

  static String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
