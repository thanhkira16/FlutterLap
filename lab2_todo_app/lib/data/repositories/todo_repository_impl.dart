import '../../domain/entities/todo_entity.dart';
import '../../domain/repositories/todo_repository.dart';
import '../datasources/local/todo_local_datasource.dart';
import '../models/todo_model.dart';

/// Repository Implementation
/// Following Dependency Inversion Principle (DIP) - implements abstract interface
/// Single Responsibility Principle (SRP) - handles data operations coordination
class TodoRepositoryImpl implements TodoRepository {
  final TodoLocalDataSource localDataSource;

  TodoRepositoryImpl({required this.localDataSource});

  @override
  Future<List<TodoEntity>> getTodos() async {
    try {
      final todos = await localDataSource.getTodos();
      return todos.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get todos: $e');
    }
  }

  @override
  Future<void> addTodo(TodoEntity todo) async {
    try {
      final todos = await localDataSource.getTodos();
      final newTodo = TodoModel.fromEntity(todo);
      todos.add(newTodo);
      await localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  @override
  Future<void> updateTodo(TodoEntity todo) async {
    try {
      final todos = await localDataSource.getTodos();
      final index = todos.indexWhere((t) => t.id == todo.id);

      if (index == -1) {
        throw Exception('Todo not found');
      }

      todos[index] = TodoModel.fromEntity(todo);
      await localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  @override
  Future<void> deleteTodo(String id) async {
    try {
      final todos = await localDataSource.getTodos();
      todos.removeWhere((todo) => todo.id == id);
      await localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }

  @override
  Future<void> toggleTodo(String id) async {
    try {
      final todos = await localDataSource.getTodos();
      final index = todos.indexWhere((t) => t.id == id);

      if (index == -1) {
        throw Exception('Todo not found');
      }

      final todo = todos[index];
      final updatedTodo = todo.copyWith(
        isCompleted: !todo.isCompleted,
        completedAt: !todo.isCompleted ? DateTime.now() : null,
      );

      todos[index] = updatedTodo;
      await localDataSource.saveTodos(todos);
    } catch (e) {
      throw Exception('Failed to toggle todo: $e');
    }
  }
}
