import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/todo_model.dart';

/// Local Data Source - Handles local storage operations
/// Following Single Responsibility Principle (SRP)
/// Interface Segregation Principle (ISP) - specific interface for local operations
abstract class TodoLocalDataSource {
  Future<List<TodoModel>> getTodos();
  Future<void> saveTodos(List<TodoModel> todos);
  Future<void> clearTodos();
}

/// Implementation of TodoLocalDataSource using SharedPreferences
/// Following Dependency Inversion Principle (DIP) - depends on abstraction
class TodoLocalDataSourceImpl implements TodoLocalDataSource {
  final SharedPreferences sharedPreferences;

  TodoLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<TodoModel>> getTodos() async {
    try {
      final jsonString = sharedPreferences.getString(
        AppConstants.todosStorageKey,
      );

      if (jsonString == null || jsonString.isEmpty) {
        return [];
      }

      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => TodoModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to load todos: $e');
    }
  }

  @override
  Future<void> saveTodos(List<TodoModel> todos) async {
    try {
      final jsonList = todos.map((todo) => todo.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await sharedPreferences.setString(
        AppConstants.todosStorageKey,
        jsonString,
      );
    } catch (e) {
      throw Exception('Failed to save todos: $e');
    }
  }

  @override
  Future<void> clearTodos() async {
    try {
      await sharedPreferences.remove(AppConstants.todosStorageKey);
    } catch (e) {
      throw Exception('Failed to clear todos: $e');
    }
  }
}
