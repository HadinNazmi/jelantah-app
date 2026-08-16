import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/lokasi_api.dart';
import 'package:jelantah_app/core/models/lokasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/donatur/pages/donasi_form_page.dart';

class LokasiDetailPage extends StatefulWidget {
  final int lokasiId;

  const LokasiDetailPage({super.key, required this.lokasiId});

  @override
  State<LokasiDetailPage> createState() => _LokasiDetailPageState();
}

class _LokasiDetailPageState extends State<LokasiDetailPage> {
  LokasiModel? _lokasi;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await AuthService.getToken();
    if (token == null) return;

    final result = await LokasiApi.getLokasiDetail(token, widget.lokasiId);
    if (result['success'] == true) {
      setState(() {
        _lokasi = LokasiModel.fromJson(result['data']);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _lokasi == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final lokasi = _lokasi!;

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Lokasi')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(lokasi.nama, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(lokasi.alamat, style: TextStyle(color: Colors.grey.shade600)),
                  ],
                ),
              ),
              Chip(
                label: Text(lokasi.sedangBuka ? 'BUKA' : 'TUTUP'),
                backgroundColor: lokasi.sedangBuka ? Colors.green.shade100 : Colors.red.shade100,
              ),
            ],
          ),
          const SizedBox(height: 20),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.schedule, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Jam Operasional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lokasi.hariOperasional ?? '-',
                          style: TextStyle(color: Colors.grey.shade700),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${lokasi.jamBuka ?? '-'} - ${lokasi.jamTutup ?? '-'}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          if (lokasi.pengelolaNama != null)
            Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(lokasi.pengelolaNama!),
                subtitle: const Text('Pengelola Lokasi'),
              ),
            ),
          const SizedBox(height: 80),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 50,
          child: ElevatedButton.icon(
            onPressed: lokasi.sedangBuka
                ? () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DonasiFormPage(lokasiId: lokasi.id, lokasiNama: lokasi.nama),
                      ),
                    );
                  }
                : null,
            icon: const Icon(Icons.add_circle),
            label: const Text('Ajukan Donasi'),
          ),
        ),
      ),
    );
  }
}