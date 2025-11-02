import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/expense.dart';
import 'package:uuid/uuid.dart';

class ExpenseProvider extends ChangeNotifier {
  late Box<Expense> _expenseBox;
  List<Expense> _expenses = [];

  List<Expense> get expenses => _expenses;

  double get totalExpenses {
    return _expenses.fold(0, (sum, expense) => sum + expense.amount);
  }

  Future<void> init() async {
    _expenseBox = await Hive.openBox<Expense>('expenses');
    _loadExpenses();
  }

  void _loadExpenses() {
    _expenses = _expenseBox.values.toList();
    _expenses.sort((a, b) => b.date.compareTo(a.date));
    notifyListeners();
  }

  Future<void> addExpense({
    required String title,
    required double amount,
    required DateTime date,
    required String category,
  }) async {
    const uuid = Uuid();
    final expense = Expense(
      id: uuid.v4(),
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    await _expenseBox.put(expense.id, expense);
    _loadExpenses();
  }

  Future<void> updateExpense({
    required String id,
    required String title,
    required double amount,
    required DateTime date,
    required String category,
  }) async {
    final expense = Expense(
      id: id,
      title: title,
      amount: amount,
      date: date,
      category: category,
    );
    await _expenseBox.put(id, expense);
    _loadExpenses();
  }

  Future<void> deleteExpense(String id) async {
    await _expenseBox.delete(id);
    _loadExpenses();
  }

  List<Expense> getExpensesByCategory(String category) {
    return _expenses.where((e) => e.category == category).toList();
  }

  List<Expense> getExpensesByDateRange(DateTime start, DateTime end) {
    return _expenses.where((e) {
      final date = DateTime(e.date.year, e.date.month, e.date.day);
      final startDate = DateTime(start.year, start.month, start.day);
      final endDate = DateTime(end.year, end.month, end.day);
      return date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, double> getTotalByCategory() {
    final map = <String, double>{};
    for (final expense in _expenses) {
      map[expense.category] = (map[expense.category] ?? 0) + expense.amount;
    }
    return map;
  }

  List<String> getCategories() {
    final categories = <String>{};
    for (final expense in _expenses) {
      categories.add(expense.category);
    }
    return categories.toList();
  }
}
