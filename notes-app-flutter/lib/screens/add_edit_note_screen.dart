import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/note.dart';
import '../providers/notes_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  bool _isLoading = false;
  bool get _isEditing => widget.note != null;

  @override
  void initState() {
    super.initState();
    // Nếu đang edit, load dữ liệu note hiện tại
    if (_isEditing) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Sửa ghi chú' : 'Thêm ghi chú'),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteDialog,
            ),
          TextButton(
            onPressed: _isLoading ? null : _saveNote,
            child: Text(
              'Lưu',
              style: TextStyle(
                color: _isLoading ? Colors.grey : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Title TextField
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Tiêu đề',
                        hintText: 'Nhập tiêu đề ghi chú...',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.title),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        // Cho phép title rỗng nhưng không thể cả title và content đều rỗng
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Content TextField
                    Expanded(
                      child: TextFormField(
                        controller: _contentController,
                        decoration: const InputDecoration(
                          labelText: 'Nội dung',
                          hintText: 'Nhập nội dung ghi chú...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                          alignLabelWithHint: true,
                        ),
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        validator: (value) {
                          // Kiểm tra nếu cả title và content đều rỗng
                          if (_titleController.text.trim().isEmpty &&
                              (value == null || value.trim().isEmpty)) {
                            return 'Vui lòng nhập tiêu đề hoặc nội dung';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Save Button
                    ElevatedButton.icon(
                      onPressed: _isLoading ? null : _saveNote,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.save),
                      label: Text(_isEditing ? 'Cập nhật' : 'Thêm mới'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),

                    if (_isEditing) ...[
                      const SizedBox(height: 8),
                      OutlinedButton.icon(
                        onPressed: _isLoading ? null : _showDeleteDialog,
                        icon: const Icon(Icons.delete, color: Colors.red),
                        label: const Text(
                          'Xóa ghi chú',
                          style: TextStyle(color: Colors.red),
                        ),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: const BorderSide(color: Colors.red),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }

  void _saveNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);

      if (_isEditing) {
        // Update existing note
        notesProvider.updateNote(widget.note!.id, title, content);
        _showSuccessMessage('Đã cập nhật ghi chú');
      } else {
        // Add new note
        notesProvider.addNote(title, content);
        _showSuccessMessage('Đã thêm ghi chú mới');
      }

      // Navigate back
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorMessage('Có lỗi xảy ra. Vui lòng thử lại.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Xóa ghi chú'),
          content: Text(
            'Bạn có chắc chắn muốn xóa ghi chú "${widget.note!.title.isEmpty ? 'Không có tiêu đề' : widget.note!.title}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
                _deleteNote();
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );
  }

  void _deleteNote() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final notesProvider = Provider.of<NotesProvider>(context, listen: false);
      notesProvider.deleteNote(widget.note!.id);

      _showSuccessMessage('Đã xóa ghi chú');
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorMessage('Không thể xóa ghi chú. Vui lòng thử lại.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
