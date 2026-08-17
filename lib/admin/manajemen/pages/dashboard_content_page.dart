import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class DashboardContentPage extends StatefulWidget {
  const DashboardContentPage({super.key});

  @override
  State<DashboardContentPage> createState() => _DashboardContentPageState();
}

class _DashboardContentPageState extends State<DashboardContentPage> {
  Map<String, dynamic>? _data;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final token = await AuthService.getToken();
    if (token == null) return;

    final response = await ApiClient.get('manajemen/dashboard', token: token);

    if (response.statusCode == 200) {
      setState(() {
        _data = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_data == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 12),
            const Text('Gagal memuat data dashboard', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton(onPressed: _loadData, child: const Text('Coba Lagi')),
          ],
        ),
      );
    }

    final perLokasi = (_data!['per_lokasi'] as List<dynamic>?) ?? [];
    final totalLiter = _data!['total_liter_keseluruhan'] ?? 0;
    final donasiSelesai = _data!['total_donasi_selesai'] ?? 0;
    final donasiPending = _data!['total_donasi_pending'] ?? 0;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header with Export & Refresh Actions (Responsive Wrap)
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Dashboard Agregat',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Gambaran umum performa pengumpulan minyak jelantah nasional.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF64748B)),
                          SizedBox(width: 8),
                          Text('7 Hari Terakhir', style: TextStyle(fontSize: 13, color: Color(0xFF334155))),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                        ],
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Laporan agregat berhasil diekspor')),
                        );
                      },
                      icon: const Icon(Icons.download_rounded, size: 18),
                      label: const Text('Ekspor Data'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047857),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B)),
                      onPressed: _loadData,
                      tooltip: 'Refresh Data',
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Top Stat Cards Grid (3 Cards)
            LayoutBuilder(
              builder: (context, constraints) {
                final isDesktop = constraints.maxWidth > 800;
                return isDesktop
                    ? Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total Jelantah Terkumpul',
                              value: '$totalLiter L',
                              subtext: '+12.5% dari bulan lalu',
                              icon: Icons.oil_barrel_rounded,
                              color: const Color(0xFF047857),
                              bgColor: const Color(0xFF047857).withValues(alpha: 0.08),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _StatCard(
                              label: 'Donasi Selesai',
                              value: '$donasiSelesai',
                              subtext: 'Transaksi berhasil diproses',
                              icon: Icons.task_alt_rounded,
                              color: const Color(0xFF0284C7),
                              bgColor: const Color(0xFF0284C7).withValues(alpha: 0.08),
                            ),
                          ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: _StatCard(
                              label: 'Donasi Pending',
                              value: '$donasiPending',
                              subtext: 'Membutuhkan verifikasi petugas',
                              icon: Icons.hourglass_top_rounded,
                              color: const Color(0xFFD97706),
                              bgColor: const Color(0xFFFEF3C7),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _StatCard(
                            label: 'Total Jelantah Terkumpul',
                            value: '$totalLiter L',
                            subtext: '+12.5% dari bulan lalu',
                            icon: Icons.oil_barrel_rounded,
                            color: const Color(0xFF047857),
                            bgColor: const Color(0xFF047857).withValues(alpha: 0.08),
                          ),
                          const SizedBox(height: 16),
                          _StatCard(
                            label: 'Donasi Selesai',
                            value: '$donasiSelesai',
                            subtext: 'Transaksi berhasil diproses',
                            icon: Icons.task_alt_rounded,
                            color: const Color(0xFF0284C7),
                            bgColor: const Color(0xFF0284C7).withValues(alpha: 0.08),
                          ),
                          const SizedBox(height: 16),
                          _StatCard(
                            label: 'Donasi Pending',
                            value: '$donasiPending',
                            subtext: 'Membutuhkan verifikasi petugas',
                            icon: Icons.hourglass_top_rounded,
                            color: const Color(0xFFD97706),
                            bgColor: const Color(0xFFFEF3C7),
                          ),
                        ],
                      );
              },
            ),
            const SizedBox(height: 40),

            // Rekapitulasi per Lokasi Section
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      const Text(
                        'Rekapitulasi Volume per Lokasi TPS',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                      Chip(
                        label: Text('${perLokasi.length} Lokasi Registered'),
                        backgroundColor: const Color(0xFFF1F5F9),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(color: Color(0xFFE2E8F0)),
                  const SizedBox(height: 8),

                  perLokasi.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(child: Text('Belum ada data lokasi', style: TextStyle(color: Colors.grey))),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: perLokasi.length,
                          separatorBuilder: (_, __) => const Divider(color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final lokasi = perLokasi[index];
                            final nama = lokasi['nama'] ?? '-';
                            final total = lokasi['total_terkumpul'] ?? 0;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF047857).withValues(alpha: 0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.location_on_rounded, color: Color(0xFF047857), size: 20),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          nama,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        const Text(
                                          'Status Operasional Aktif',
                                          style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF047857).withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '$total L',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF047857),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String subtext;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.subtext,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF64748B),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            value,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtext,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}