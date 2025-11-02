class Note {
  final String id;
  String title;
  String content;
  final DateTime createdAt;
  DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  // Constructor để tạo note mới với thời gian hiện tại
  Note.create({required this.title, required this.content})
    : id = DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt = DateTime.now(),
      updatedAt = DateTime.now();

  // Method để copy note với thông tin mới
  Note copyWith({String? title, String? content}) {
    return Note(
      id: id,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Method để format thời gian
  String get formattedDate {
    return '${updatedAt.day}/${updatedAt.month}/${updatedAt.year}';
  }

  // Method để kiểm tra note có rỗng không
  bool get isEmpty {
    return title.trim().isEmpty && content.trim().isEmpty;
  }
}
