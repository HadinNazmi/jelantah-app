import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/auth_api.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/admin/pengelola/pages/dashboard_pengelola_page.dart';
import 'package:jelantah_app/admin/manajemen/pages/dashboard_manajemen_page.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _handleLogin() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await AuthApi.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      platform: 'web',
    );

    setState(() => _isLoading = false);

    if (result['success'] == true) {
      final data = result['data'];
      final role = data['user']['role'];

      await AuthService.saveToken(data['token']);
      await AuthService.saveRole(role);

      if (!mounted) return;

      if (role == 'pengelola') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPengelolaPage()),
        );
      } else if (role == 'manajemen') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardManajemenPage()),
        );
      } else {
        setState(() => _errorMessage = 'Akun ini tidak memiliki akses ke web admin');
      }
    } else {
      setState(() {
        _errorMessage = result['message'] ?? 'Login gagal';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.eco, size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  const Text(
                    'Admin — Si Jelantah',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Text(
                    'Untuk Pengelola & Manajemen',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_errorMessage != null)
                    Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Masuk'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}