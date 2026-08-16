import 'package:flutter/material.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/donatur/auth/login_page.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await AuthService.logout();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            }
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}