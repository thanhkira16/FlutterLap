import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/photo_provider.dart';
import 'screens/home_screen.dart';
import 'theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final photoProvider = PhotoProvider();
  await photoProvider.init();

  runApp(
    ChangeNotifierProvider(
      create: (context) => photoProvider,
      child: const PhotoGalleryApp(),
    ),
  );
}

class PhotoGalleryApp extends StatefulWidget {
  const PhotoGalleryApp({super.key});

  @override
  State<PhotoGalleryApp> createState() => _PhotoGalleryAppState();
}

class _PhotoGalleryAppState extends State<PhotoGalleryApp> {
  late bool _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = false;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Photo Gallery',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(),
    );
  }
}
