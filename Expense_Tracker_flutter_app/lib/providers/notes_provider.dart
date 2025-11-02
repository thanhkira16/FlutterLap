import 'package:flutter/foundation.dart';
import '../models/note.dart';

class NotesProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  // Getter để lấy danh sách notes (chỉ đọc)
  List<Note> get notes => List.unmodifiable(_notes);

  // Getter để lấy số lượng notes
  int get notesCount => _notes.length;

  // Thêm note mới
  void addNote(String title, String content) {
    if (title.trim().isEmpty && content.trim().isEmpty) {
      return; // Không thêm note rỗng
    }

    final newNote = Note.create(title: title.trim(), content: content.trim());

    _notes.insert(0, newNote); // Thêm vào đầu danh sách
    notifyListeners();
  }

  // Cập nhật note
  void updateNote(String id, String title, String content) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index != -1) {
      _notes[index] = _notes[index].copyWith(
        title: title.trim(),
        content: content.trim(),
      );
      notifyListeners();
    }
  }

  // Xóa note
  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  // Lấy note theo id
  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  // Tìm kiếm notes theo từ khóa
  List<Note> searchNotes(String keyword) {
    if (keyword.trim().isEmpty) {
      return notes;
    }

    final lowerKeyword = keyword.toLowerCase();
    return _notes
        .where(
          (note) =>
              note.title.toLowerCase().contains(lowerKeyword) ||
              note.content.toLowerCase().contains(lowerKeyword),
        )
        .toList();
  }

  // Xóa tất cả notes
  void clearAllNotes() {
    _notes.clear();
    notifyListeners();
  }

  // Thêm dữ liệu mẫu (để test)
  void addSampleData() {
    _notes.addAll([
      Note.create(
        title: 'Ghi chú đầu tiên',
        content:
            'Đây là nội dung của ghi chú đầu tiên. Bạn có thể viết bất cứ điều gì ở đây.',
      ),
      Note.create(
        title: 'Danh sách mua sắm',
        content: '- Sữa\n- Bánh mì\n- Trứng\n- Rau củ',
      ),
      Note.create(
        title: 'Ý tưởng dự án',
        content: 'Tạo một ứng dụng ghi chú đơn giản với Flutter và Provider.',
      ),
    ]);
    notifyListeners();
  }

  // Method để refresh/reload dữ liệu
  void refresh() {
    // Trong thực tế, đây có thể là nơi bạn gọi API để load dữ liệu mới
    // Hiện tại chỉ cần trigger rebuild UI
    notifyListeners();
  }
}
