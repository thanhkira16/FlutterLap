import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

// Core
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

// Data Layer
import 'features/profile/data/datasources/profile_local_datasource.dart';
import 'features/profile/data/repositories/profile_repository_impl.dart';

// Domain Layer
import 'features/profile/domain/repositories/profile_repository.dart';
import 'features/profile/domain/usecases/get_profile_usecase.dart';

// Presentation Layer
import 'features/profile/presentation/providers/profile_provider.dart';
import 'features/profile/presentation/pages/profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Dependency Injection - Manual DI following Clean Architecture
    // In production, consider using get_it or injectable
    final ProfileLocalDataSource dataSource = ProfileLocalDataSourceImpl();
    final ProfileRepository repository = ProfileRepositoryImpl(dataSource);
    final GetProfileUseCase getProfileUseCase = GetProfileUseCase(repository);

    return MultiProvider(
      providers: [
        // Theme Provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),

        // Profile Provider with dependency injection
        ChangeNotifierProvider(
          create: (_) => ProfileProvider(getProfileUseCase),
        ),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Personal Profile App',
            debugShowCheckedModeBanner: false,

            // Theme configuration
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,

            // Home page
            home: const ProfilePage(),
          );
        },
      ),
    );
  }
}
