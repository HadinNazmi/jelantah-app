import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/auth_api.dart';
import 'package:jelantah_app/core/api/dompet_api.dart';
import 'package:jelantah_app/core/api/lokasi_api.dart';
import 'package:jelantah_app/core/models/dompet_model.dart';
import 'package:jelantah_app/core/models/lokasi_model.dart';
import 'package:jelantah_app/core/models/user_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/donatur/pages/donasi_form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  UserModel? _user;
  DompetModel? _dompet;
  List<LokasiModel> _lokasiList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final token = await AuthService.getToken();
    if (token == null) return;

    final meResult = await AuthApi.getMe(token);
    final dompetResult = await DompetApi.getMyDompet(token);
    final lokasiResult = await LokasiApi.getLokasiList(token);

    setState(() {
      if (meResult['success'] == true) {
        _user = UserModel.fromJson(meResult['data']);
      }
      if (dompetResult['success'] == true) {
        _dompet = DompetModel.fromJson(dompetResult['data']);
      }
      if (lokasiResult['success'] == true) {
        _lokasiList = (lokasiResult['data'] as List)
            .map((item) => LokasiModel.fromJson(item))
            .toList();
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Beranda')),
      body: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Halo, ${_user?.name ?? '-'}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    label: 'Total Poin',
                    value: '${_dompet?.totalPoin ?? 0}',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    label: 'Total Minyak (L)',
                    value: '${_dompet?.totalKontribusi.toStringAsFixed(1) ?? '0.0'}',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Lokasi Donasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (_lokasiList.isEmpty)
              const Text('Belum ada lokasi tersedia.')
            else
              ..._lokasiList.map((lokasi) => _LokasiCard(lokasi: lokasi)),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          Text(label, style: TextStyle(color: Colors.grey.shade700)),
        ],
      ),
    );
  }
}

class _LokasiCard extends StatelessWidget {
  final LokasiModel lokasi;

  const _LokasiCard({required this.lokasi});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(lokasi.nama),
        subtitle: Text(lokasi.alamat),
        trailing: Chip(
          label: Text(lokasi.sedangBuka ? 'Buka' : 'Tutup'),
          backgroundColor: lokasi.sedangBuka ? Colors.green.shade100 : Colors.red.shade100,
        ),
        onTap: lokasi.sedangBuka
            ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DonasiFormPage(
                      lokasiId: lokasi.id,
                      lokasiNama: lokasi.nama,
                    ),
                  ),
                );
              }
            : null,
      ),
    );
  }
}