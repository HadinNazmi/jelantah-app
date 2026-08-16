import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/api/donasi_api.dart';
import 'package:jelantah_app/core/models/donasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class DonasiDetailPage extends StatefulWidget {
  final int donasiId;

  const DonasiDetailPage({super.key, required this.donasiId});

  @override
  State<DonasiDetailPage> createState() => _DonasiDetailPageState();
}

class _DonasiDetailPageState extends State<DonasiDetailPage> {
  DonasiModel? _donasi;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await AuthService.getToken();
    if (token == null) return;

    final result = await DonasiApi.getDonasiDetail(token, widget.donasiId);
    if (result['success'] == true) {
      setState(() {
        _donasi = DonasiModel.fromJson(result['data']);
        _isLoading = false;
      });
    }
  }

  Color _statusColor() {
    switch (_donasi?.status) {
      case 'selesai':
        return Colors.green;
      case 'verifikasi':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _donasi == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final donasi = _donasi!;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Pengajuan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _statusColor().withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 32,
                  backgroundColor: _statusColor(),
                  child: Icon(
                    donasi.status == 'selesai' ? Icons.check_circle : Icons.hourglass_top,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(donasi.status.toUpperCase()),
                  backgroundColor: _statusColor().withOpacity(0.2),
                ),
                const SizedBox(height: 8),
                Text(
                  donasi.status == 'selesai'
                      ? 'Donasi Berhasil Diproses'
                      : donasi.status == 'verifikasi'
                          ? 'Sedang Diverifikasi'
                          : 'Menunggu Verifikasi',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Foto bukti
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Foto Timbangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      ApiClient.imageUrl(donasi.fotoBukti),
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 200,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.broken_image),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Data comparison
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DataRow(icon: Icons.oil_barrel, label: 'INPUT DONATUR', value: '${donasi.jumlahInput} Liter'),
                  const Divider(),
                  _DataRow(
                    icon: Icons.fact_check,
                    label: 'HASIL VERIFIKASI',
                    value: donasi.jumlahTerverifikasi != null
                        ? '${donasi.jumlahTerverifikasi} Liter'
                        : '-',
                  ),
                  const Divider(),
                  _DataRow(
                    icon: Icons.stars,
                    label: 'POIN DITERIMA',
                    value: donasi.poinDiperoleh != null ? '${donasi.poinDiperoleh} Poin' : '-',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Timeline sederhana
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Riwayat Proses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _TimelineItem(title: 'Diajukan', time: donasi.createdAt, done: true),
                  if (donasi.verifiedAt != null)
                    _TimelineItem(
                      title: 'Diverifikasi oleh Pengelola',
                      time: donasi.verifiedAt!,
                      subtitle: donasi.verifikatorNama != null ? 'Operator: ${donasi.verifikatorNama}' : null,
                      done: true,
                    ),
                  if (donasi.status == 'selesai')
                    _TimelineItem(title: 'Selesai & Poin Diterima', time: donasi.verifiedAt ?? '', done: true, isLast: true),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Lokasi
          if (donasi.lokasi != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.location_on, color: Colors.green),
                title: Text(donasi.lokasi!.nama),
                subtitle: Text(donasi.lokasi!.alamat),
              ),
            ),
        ],
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.green.shade50, child: Icon(icon, color: Colors.green)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final String? subtitle;
  final bool done;
  final bool isLast;

  const _TimelineItem({
    required this.title,
    required this.time,
    this.subtitle,
    this.done = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: done ? Colors.green : Colors.grey.shade300,
            child: Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                if (subtitle != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Text(subtitle!, style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}