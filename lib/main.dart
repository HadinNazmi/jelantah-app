import 'package:flutter/material.dart';
import 'package:jelantah_app/core/theme/app_theme.dart';
import 'package:jelantah_app/admin/auth/login_page.dart';

void main() {
  runApp(const JelantahApp());
}

class JelantahApp extends StatelessWidget {
  const JelantahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sedekah Jelantah',
      theme: AppTheme.lightTheme,
      home: const AdminLoginPage(),
      // home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

