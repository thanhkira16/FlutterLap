import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/theme/app_theme.dart';
import 'data/datasources/local/todo_local_datasource.dart';
import 'data/repositories/todo_repository_impl.dart';
import 'domain/repositories/todo_repository.dart';
import 'domain/usecases/add_todo_usecase.dart';
import 'domain/usecases/delete_todo_usecase.dart';
import 'domain/usecases/get_todos_usecase.dart';
import 'domain/usecases/toggle_todo_usecase.dart';
import 'presentation/pages/todo_page.dart';

/// Main entry point of the application
/// Demonstrates Dependency Injection and Clean Architecture principles
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  final sharedPreferences = await SharedPreferences.getInstance();

  // Data Layer
  final TodoLocalDataSource localDataSource = TodoLocalDataSourceImpl(
    sharedPreferences: sharedPreferences,
  );

  // Repository Layer (Dependency Inversion)
  final TodoRepository repository = TodoRepositoryImpl(
    localDataSource: localDataSource,
  );

  // Use Cases Layer
  final getTodosUseCase = GetTodosUseCase(repository);
  final addTodoUseCase = AddTodoUseCase(repository);
  final toggleTodoUseCase = ToggleTodoUseCase(repository);
  final deleteTodoUseCase = DeleteTodoUseCase(repository);

  runApp(
    MyApp(
      getTodosUseCase: getTodosUseCase,
      addTodoUseCase: addTodoUseCase,
      toggleTodoUseCase: toggleTodoUseCase,
      deleteTodoUseCase: deleteTodoUseCase,
    ),
  );
}

/// Root widget of the application
class MyApp extends StatelessWidget {
  final GetTodosUseCase getTodosUseCase;
  final AddTodoUseCase addTodoUseCase;
  final ToggleTodoUseCase toggleTodoUseCase;
  final DeleteTodoUseCase deleteTodoUseCase;

  const MyApp({
    super.key,
    required this.getTodosUseCase,
    required this.addTodoUseCase,
    required this.toggleTodoUseCase,
    required this.deleteTodoUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo App - Clean Architecture',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: TodoPage(
        getTodosUseCase: getTodosUseCase,
        addTodoUseCase: addTodoUseCase,
        toggleTodoUseCase: toggleTodoUseCase,
        deleteTodoUseCase: deleteTodoUseCase,
      ),
    );
  }
}
