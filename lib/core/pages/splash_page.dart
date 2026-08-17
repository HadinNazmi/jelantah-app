import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/admin/auth/login_page.dart' as admin;
import 'package:jelantah_app/donatur/auth/login_page.dart' as donatur;
import 'package:jelantah_app/admin/manajemen/pages/dashboard_manajemen_page.dart';
import 'package:jelantah_app/admin/pengelola/pages/dashboard_pengelola_page.dart';
import 'package:jelantah_app/donatur/pages/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // Memberikan sedikit delay agar transisi tidak terlalu mengagetkan
    await Future.delayed(const Duration(milliseconds: 600));
    
    final token = await AuthService.getToken();
    final role = await AuthService.getRole();

    if (!mounted) return;

    if (token != null && role != null) {
      if (role == 'manajemen') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardManajemenPage()),
        );
      } else if (role == 'pengelola') {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DashboardPengelolaPage()),
        );
      } else {
        // Asumsi donatur
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      }
    } else {
      // Jika belum login, rute ke halaman login berdasarkan platform (Web vs Mobile)
      if (kIsWeb) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const admin.AdminLoginPage()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const donatur.LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF047857),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.eco_rounded, size: 80, color: Colors.white),
            SizedBox(height: 24),
            CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
