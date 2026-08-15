import 'package:flutter/material.dart';
import 'package:jelantah_app/donatur/auth/login_page.dart';

void main() {
  runApp(const JelantahApp());
}

class JelantahApp extends StatelessWidget {
  const JelantahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jelantah App',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}