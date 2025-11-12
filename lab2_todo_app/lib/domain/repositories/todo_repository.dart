import '../entities/todo_entity.dart';

/// Repository Interface - Dependency Inversion Principle (DIP)
/// High-level modules (use cases) depend on abstractions, not concrete implementations
abstract class TodoRepository {
  /// Get all todos
  Future<List<TodoEntity>> getTodos();

  /// Add a new todo
  Future<void> addTodo(TodoEntity todo);

  /// Update an existing todo
  Future<void> updateTodo(TodoEntity todo);

  /// Delete a todo by id
  Future<void> deleteTodo(String id);

  /// Toggle todo completion status
  Future<void> toggleTodo(String id);
}
