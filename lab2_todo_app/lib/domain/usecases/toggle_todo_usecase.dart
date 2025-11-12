import '../repositories/todo_repository.dart';

/// Use Case for toggling todo completion status
/// Following Single Responsibility Principle (SRP)
class ToggleTodoUseCase {
  final TodoRepository repository;

  ToggleTodoUseCase(this.repository);

  /// Execute the use case
  Future<void> execute(String id) async {
    if (id.isEmpty) {
      throw ArgumentError('Todo ID cannot be empty');
    }

    await repository.toggleTodo(id);
  }
}
