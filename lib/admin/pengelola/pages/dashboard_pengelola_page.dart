import 'package:flutter/material.dart';
import 'package:jelantah_app/admin/pengelola/pages/donasi_masuk_page.dart';
import 'package:jelantah_app/admin/pengelola/pages/lokasi_list_page.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/admin/auth/login_page.dart';

class DashboardPengelolaPage extends StatefulWidget {
  const DashboardPengelolaPage({super.key});

  @override
  State<DashboardPengelolaPage> createState() => _DashboardPengelolaPageState();
}

class _DashboardPengelolaPageState extends State<DashboardPengelolaPage> {
  int _selectedIndex = 0;

final List<Widget> _pages = const [
  DonasiMasukPage(),
  LokasiListPage(),
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
              NavigationRailDestination(
                icon: Icon(Icons.inbox),
                label: Text('Donasi Masuk'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.location_on),
                label: Text('Kelola Lokasi'),
              ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: _pages[_selectedIndex]),
        ],
      ),
    );
  }
}