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

  final List<String> _titles = const [
    'Dashboard Utama',
    'Kelola Pengelola TPS',
    'Konfigurasi Rate Poin',
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
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        children: [
          // Sidebar Navigation (Clean White Surface)
          Container(
            width: 260,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
            ),
            child: Column(
              children: [
                // Top Brand Logo
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF047857).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.eco_rounded, color: Color(0xFF047857), size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Si Jelantah CSR',
                        style: TextStyle(
                          color: Color(0xFF0F172A),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Navigation Items
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _ManagementNavItem(
                          icon: Icons.dashboard_rounded,
                          label: 'Dashboard Utama',
                          isSelected: _selectedIndex == 0,
                          onTap: () => setState(() => _selectedIndex = 0),
                        ),
                        const SizedBox(height: 8),
                        _ManagementNavItem(
                          icon: Icons.people_alt_rounded,
                          label: 'Kelola Pengelola',
                          isSelected: _selectedIndex == 1,
                          onTap: () => setState(() => _selectedIndex = 1),
                        ),
                        const SizedBox(height: 8),
                        _ManagementNavItem(
                          icon: Icons.settings_suggest_rounded,
                          label: 'Konfigurasi Poin',
                          isSelected: _selectedIndex == 2,
                          onTap: () => setState(() => _selectedIndex = 2),
                        ),
                      ],
                    ),
                  ),
                ),

                // User Profile & Logout Box at Bottom
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 18,
                          backgroundColor: Color(0xFF047857),
                          child: Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'CSR Manager',
                                style: TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'MANAGEMENT',
                                style: TextStyle(color: Color(0xFF64748B), fontSize: 10, letterSpacing: 0.8),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout, color: Color(0xFFEF4444), size: 20),
                          onPressed: _logout,
                          tooltip: 'Keluar',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Main Section (Top Header + Dynamic Page Content)
          Expanded(
            child: Column(
              children: [
                // Top Header Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Breadcrumb
                      Row(
                        children: [
                          const Text('Manajemen', style: TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 6),
                          const Icon(Icons.chevron_right, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 6),
                          Text(
                            _titles[_selectedIndex],
                            style: const TextStyle(color: Color(0xFF0F172A), fontSize: 13, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),

                      // System Online Status Badge
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFF047857).withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 8,
                                  height: 8,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF10B981),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Text(
                                  'Sistem Online',
                                  style: TextStyle(
                                    color: Color(0xFF047857),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Active Page Content
                Expanded(
                  child: _pages[_selectedIndex],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ManagementNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ManagementNavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF047857).withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: const Color(0xFF047857).withValues(alpha: 0.2)) : null,
          ),
          child: Row(
            children: [
              Icon(icon, color: isSelected ? const Color(0xFF047857) : const Color(0xFF64748B), size: 20),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF047857) : const Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}