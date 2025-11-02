import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/notes_provider.dart';
import '../models/note.dart';
import 'add_edit_note_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // Thêm dữ liệu mẫu khi khởi động app (chỉ nếu chưa có notes)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      if (notesProvider.notesCount == 0) {
        notesProvider.addSampleData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _refreshNotes(context),
            tooltip: 'Làm mới',
          ),
          Consumer<NotesProvider>(
            builder: (context, notesProvider, child) {
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Center(
                  child: Text(
                    '${notesProvider.notesCount}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          if (notesProvider.notesCount == 0) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_add, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Chưa có ghi chú nào',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Nhấn nút + để tạo ghi chú mới',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: notesProvider.notesCount,
            itemBuilder: (context, index) {
              final note = notesProvider.notes[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(
                    note.title.isEmpty ? 'Không có tiêu đề' : note.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: note.title.isEmpty ? Colors.grey : null,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (note.content.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          note.content,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      const SizedBox(height: 4),
                      Text(
                        note.formattedDate,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  onTap: () => _editNote(context, note),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _showDeleteDialog(context, note),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNote(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addNote(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddEditNoteScreen()),
    );
  }

  void _editNote(BuildContext context, Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddEditNoteScreen(note: note)),
    );
  }

  void _showDeleteDialog(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa ghi chú'),
          content: Text(
            'Bạn có chắc chắn muốn xóa ghi chú "${note.title.isEmpty ? 'Không có tiêu đề' : note.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<NotesProvider>(
                  context,
                  listen: false,
                ).deleteNote(note.id);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Đã xóa ghi chú'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _refreshNotes(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    // Hiển thị loading indicator ngắn
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Đang làm mới...'),
          ],
        ),
        duration: Duration(milliseconds: 800),
        backgroundColor: Colors.blue,
      ),
    );

    // Simulate refresh delay (có thể thay bằng API call thực tế)
    Future.delayed(const Duration(milliseconds: 500), () {
      // Gọi method refresh từ provider
      notesProvider.refresh();

      // Hiển thị success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Đã làm mới ${notesProvider.notesCount} ghi chú'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }
}
