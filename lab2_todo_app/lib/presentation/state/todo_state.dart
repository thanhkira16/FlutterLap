import '../../domain/entities/todo_entity.dart';

/// State class for managing todo list state
/// Following Single Responsibility Principle (SRP)
class TodoState {
  final List<TodoEntity> todos;
  final bool isLoading;
  final String? error;

  const TodoState({this.todos = const [], this.isLoading = false, this.error});

  /// Create initial state
  factory TodoState.initial() {
    return const TodoState(todos: [], isLoading: false, error: null);
  }

  /// Create loading state
  TodoState copyWithLoading() {
    return TodoState(todos: todos, isLoading: true, error: null);
  }

  /// Create success state
  TodoState copyWithTodos(List<TodoEntity> newTodos) {
    return TodoState(todos: newTodos, isLoading: false, error: null);
  }

  /// Create error state
  TodoState copyWithError(String error) {
    return TodoState(todos: todos, isLoading: false, error: error);
  }

  /// Get statistics
  int get totalTodos => todos.length;
  int get completedTodos => todos.where((t) => t.isCompleted).length;
  int get pendingTodos => todos.where((t) => !t.isCompleted).length;
  double get completionRate =>
      totalTodos == 0 ? 0 : completedTodos / totalTodos;
}
