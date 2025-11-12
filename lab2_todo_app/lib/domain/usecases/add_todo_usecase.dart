import '../entities/todo_entity.dart';
import '../repositories/todo_repository.dart';

/// Use Case for adding a todo
/// Following Single Responsibility Principle (SRP)
/// Each use case has one specific business logic responsibility
class AddTodoUseCase {
  final TodoRepository repository;

  AddTodoUseCase(this.repository);

  /// Execute the use case
  Future<void> execute(TodoEntity todo) async {
    // Business logic validation
    if (todo.title.trim().isEmpty) {
      throw ArgumentError('Todo title cannot be empty');
    }

    await repository.addTodo(todo);
  }
}
