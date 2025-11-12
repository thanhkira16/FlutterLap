import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../domain/entities/todo_entity.dart';
import '../../domain/usecases/add_todo_usecase.dart';
import '../../domain/usecases/delete_todo_usecase.dart';
import '../../domain/usecases/get_todos_usecase.dart';
import '../../domain/usecases/toggle_todo_usecase.dart';
import '../state/todo_state.dart';
import '../widgets/add_todo_dialog.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/todo_item_widget.dart';

/// Main Todo Page - StatefulWidget for local state management
/// Following Single Responsibility Principle (SRP)
/// Open/Closed Principle (OCP) - open for extension via dependency injection
class TodoPage extends StatefulWidget {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  const TodoPage({
    super.key,
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.toggleTodoUseCase,
    required this.deleteTodoUseCase,
  });

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TodoState _state = TodoState.initial();

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  /// Load todos using setState()
  Future<void> _loadTodos() async {
    setState(() {
      _state = _state.copyWithLoading();
    });

    try {
      final todos = await widget.getTodosUseCase.execute();
      setState(() {
        _state = _state.copyWithTodos(todos);
      });
    } catch (e) {
      setState(() {
        _state = _state.copyWithError(e.toString());
      });
      if (mounted) {
        _showErrorSnackBar('Failed to load tasks: ${e.toString()}');
      }
    }
  }

  /// Add a new todo
  Future<void> _addTodo() async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (ctx) => const AddTodoDialog(),
    );

    if (result == null) return;

    try {
      final newTodo = TodoEntity(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: result['title']!,
        description: result['description']!.isEmpty
            ? null
            : result['description'],
        isCompleted: false,
        createdAt: DateTime.now(),
      );

      await widget.addTodoUseCase.execute(newTodo);
      await _loadTodos();

      if (mounted) {
        _showSuccessSnackBar('Task added successfully');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to add task: ${e.toString()}');
      }
    }
  }

  /// Toggle todo completion
  Future<void> _toggleTodo(String id) async {
    try {
      await widget.toggleTodoUseCase.execute(id);
      await _loadTodos();
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to update task: ${e.toString()}');
      }
    }
  }

  /// Delete a todo
  Future<void> _deleteTodo(String id) async {
    try {
      await widget.deleteTodoUseCase.execute(id);
      await _loadTodos();

      if (mounted) {
        _showSuccessSnackBar('Task deleted successfully');
      }
    } catch (e) {
      if (mounted) {
        _showErrorSnackBar('Failed to delete task: ${e.toString()}');
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo App'),
        actions: [
          if (_state.todos.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(
                right: AppConstants.defaultPadding,
              ),
              child: Center(
                child: Chip(
                  label: Text(
                    '${_state.completedTodos}/${_state.totalTodos}',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  avatar: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTodo,
        icon: const Icon(Icons.add),
        label: const Text('Add Task'),
      ),
    );
  }

  Widget _buildBody() {
    if (_state.isLoading && _state.todos.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_state.todos.isEmpty) {
      return const EmptyStateWidget();
    }

    return RefreshIndicator(
      onRefresh: _loadTodos,
      child: Column(
        children: [
          if (_state.todos.isNotEmpty) _buildStatisticsCard(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(
                top: AppConstants.itemSpacing,
                bottom: 80,
              ),
              itemCount: _state.todos.length,
              itemBuilder: (context, index) {
                final todo = _state.todos[index];
                return TodoItemWidget(
                  key: ValueKey(todo.id),
                  todo: todo,
                  onToggle: () => _toggleTodo(todo.id),
                  onDelete: () => _deleteTodo(todo.id),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCard() {
    final theme = Theme.of(context);
    final completionPercentage = (_state.completionRate * 100).toStringAsFixed(
      0,
    );

    return Container(
      margin: const EdgeInsets.all(AppConstants.defaultPadding),
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.secondaryContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            icon: Icons.format_list_bulleted,
            label: 'Total',
            value: _state.totalTodos.toString(),
            color: theme.colorScheme.primary,
          ),
          _buildStatItem(
            icon: Icons.pending_actions,
            label: 'Pending',
            value: _state.pendingTodos.toString(),
            color: theme.colorScheme.tertiary,
          ),
          _buildStatItem(
            icon: Icons.check_circle,
            label: 'Completed',
            value: _state.completedTodos.toString(),
            color: theme.colorScheme.secondary,
          ),
          _buildStatItem(
            icon: Icons.trending_up,
            label: 'Progress',
            value: '$completionPercentage%',
            color: theme.colorScheme.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
