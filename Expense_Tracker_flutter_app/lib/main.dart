import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'providers/expense_provider.dart';
import 'models/expense.dart';
import 'screens/home_screen.dart';
import 'theme/app_themes.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ExpenseAdapter());

  final expenseProvider = ExpenseProvider();
  await expenseProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => expenseProvider,
      child: const ExpenseTrackerApp(),
    ),
  );
}

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
