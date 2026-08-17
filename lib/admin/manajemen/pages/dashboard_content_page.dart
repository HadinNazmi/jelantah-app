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
      return const Center(child: Text('Gagal memuat data'));
    }

    final perLokasi = _data!['per_lokasi'] as List<dynamic>;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Liter Terkumpul',
                    value: '${_data!['total_liter_keseluruhan'] ?? 0}',
                    icon: Icons.oil_barrel,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    label: 'Donasi Selesai',
                    value: '${_data!['total_donasi_selesai'] ?? 0}',
                    icon: Icons.check_circle,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    label: 'Donasi Pending',
                    value: '${_data!['total_donasi_pending'] ?? 0}',
                    icon: Icons.hourglass_top,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Rekap per Lokasi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ...perLokasi.map((lokasi) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.location_on, color: Colors.green),
                    title: Text(lokasi['nama'] ?? '-'),
                    trailing: Text(
                      '${lokasi['total_terkumpul'] ?? 0} L',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}