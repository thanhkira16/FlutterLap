import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use Case for getting all todos
/// Following Single Responsibility Principle (SRP)
class GetTodosUseCase {
  final TodoRepository repository;

  GetTodosUseCase(this.repository);

  /// Execute the use case
  Future<List<TodoEntity>> execute() async {
    final todos = await repository.getTodos();

    // Business logic: Sort todos by creation date (newest first)
    // Uncompleted tasks first, then completed
    todos.sort((a, b) {
      if (a.isCompleted != b.isCompleted) {
        return a.isCompleted ? 1 : -1;
      }
      return b.createdAt.compareTo(a.createdAt);
    });

    return todos;
  }
}
