import 'package:flutter/material.dart';
import 'package:jelantah_app/admin/manajemen/pages/dashboard_content_page.dart';
import 'package:jelantah_app/admin/manajemen/pages/kelola_pengelola_page.dart';
import 'package:jelantah_app/admin/manajemen/pages/konfigurasi_poin_page.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/admin/auth/login_page.dart';

class DashboardManajemenPage extends StatefulWidget {
  const DashboardManajemenPage({super.key});

  @override
  State<DashboardManajemenPage> createState() => _DashboardManajemenPageState();
}

class _DashboardManajemenPageState extends State<DashboardManajemenPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    DashboardContentPage(),
    KelolaPengelolaPage(),
    KonfigurasiPoinPage(),
  ];

  Future<void> _logout() async {
    await AuthService.logout();
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const AdminLoginPage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            labelType: NavigationRailLabelType.all,
            leading: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Icon(Icons.eco, size: 32, color: Colors.green),
            ),
            trailing: Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: IconButton(
                    icon: const Icon(Icons.logout),
                    onPressed: _logout,
                    tooltip: 'Logout',
                  ),
                ),
              ),
            ),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.dashboard), label: Text('Dashboard')),
              NavigationRailDestination(icon: Icon(Icons.people), label: Text('Pengelola')),
              NavigationRailDestination(icon: Icon(Icons.stars), label: Text('Poin')),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}