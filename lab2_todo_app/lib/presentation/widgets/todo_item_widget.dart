import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/date_formatter.dart';
import '../../domain/entities/todo_entity.dart';

/// Todo item widget - displays a single todo
/// Following Single Responsibility Principle (SRP)
class TodoItemWidget extends StatelessWidget {
  final TodoEntity todo;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const TodoItemWidget({
    super.key,
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.itemSpacing,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppConstants.defaultPadding,
          vertical: AppConstants.itemSpacing,
        ),
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (_) => onToggle(),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
        title: Text(
          todo.title,
          style: theme.textTheme.titleMedium?.copyWith(
            decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
            color: todo.isCompleted
                ? theme.colorScheme.onSurface.withOpacity(0.5)
                : theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description != null && todo.description!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                todo.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                  decoration: todo.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.4),
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormatter.formatDate(todo.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withOpacity(0.4),
                  ),
                ),
                if (todo.isCompleted && todo.completedAt != null) ...[
                  const SizedBox(width: 12),
                  Icon(
                    Icons.check_circle,
                    size: 14,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Completed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => _showDeleteConfirmation(context),
          color: theme.colorScheme.error,
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Task'),
        content: const Text('Are you sure you want to delete this task?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
