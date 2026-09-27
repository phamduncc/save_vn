import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/screens/home_navigation_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: SafeVnApp(),
    ),
  );
}

class SafeVnApp extends StatelessWidget {
  const SafeVnApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SafeVN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const HomeNavigationShell(),
    );
  }
}
