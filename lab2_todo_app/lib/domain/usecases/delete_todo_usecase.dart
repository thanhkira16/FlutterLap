import '../repositories/todo_repository.dart';

/// Use Case for deleting a todo
/// Following Single Responsibility Principle (SRP)
class DeleteTodoUseCase {
  final TodoRepository repository;

  DeleteTodoUseCase(this.repository);

  /// Execute the use case
  Future<void> execute(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Todo ID cannot be empty');
    }

    await repository.deleteTodo(id);
  }
}
