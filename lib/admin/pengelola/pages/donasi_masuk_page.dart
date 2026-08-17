import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/models/donasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/admin/pengelola/pages/donasi_detail_pengelola_page.dart';

class DonasiMasukPage extends StatefulWidget {
  const DonasiMasukPage({super.key});

  @override
  State<DonasiMasukPage> createState() => _DonasiMasukPageState();
}

class _DonasiMasukPageState extends State<DonasiMasukPage> {
  List<DonasiModel> _donasiList = [];
  bool _isLoading = true;
  String? _token;
  String _filter = 'semua';

  List<DonasiModel> get _filteredDonasiList {
    final now = DateTime.now();
    return _donasiList.where((donasi) {
      if (_filter == 'semua') return true;
      try {
        final date = DateTime.parse(donasi.createdAt);
        if (_filter == 'hari_ini') {
          return date.year == now.year && date.month == now.month && date.day == now.day;
        } else if (_filter == 'minggu_ini') {
          final difference = now.difference(date).inDays;
          return difference <= 7;
        } else if (_filter == 'bulan_ini') {
          return date.year == now.year && date.month == now.month;
        }
      } catch (e) {
        return true;
      }
      return true;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final token = await AuthService.getToken();
    _token = token;
    if (token == null) return;

    final response = await ApiClient.get('pengelola/donasi', token: token);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _donasiList = data.map((item) => DonasiModel.fromJson(item)).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _verifikasi(DonasiModel donasi) async {
    final controller = TextEditingController(text: donasi.jumlahInput.toString());

    final jumlahTerverifikasi = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.fact_check_rounded, color: Color(0xFF047857)),
            SizedBox(width: 10),
            Text('Verifikasi Penimbangan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Input oleh donatur: ${donasi.jumlahInput} Liter', style: const TextStyle(color: Color(0xFF64748B))),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Jumlah Penimbangan Aktual (Liter)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                prefixIcon: const Icon(Icons.oil_barrel_outlined),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, double.tryParse(controller.text)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF047857),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Verifikasi'),
          ),
        ],
      ),
    );

    if (jumlahTerverifikasi == null || _token == null) return;

    final response = await ApiClient.put(
      'pengelola/donasi/${donasi.id}/verifikasi',
      body: {'jumlah_terverifikasi': jumlahTerverifikasi},
      token: _token,
    );

    if (response.statusCode == 200) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donasi berhasil diverifikasi')),
        );
      }
    }
  }

  Future<void> _selesaikan(DonasiModel donasi) async {
    if (_token == null) return;

    final response = await ApiClient.put(
      'pengelola/donasi/${donasi.id}/selesai',
      token: _token,
    );

    if (response.statusCode == 200) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Donasi ditandai selesai & poin diterbitkan')),
        );
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'selesai':
        return const Color(0xFF10B981);
      case 'verifikasi':
        return const Color(0xFF0284C7);
      default:
        return const Color(0xFFD97706);
    }
  }

  void _tampilkanGambar(String imageUrl) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(24),
        child: Stack(
          alignment: Alignment.center,
          children: [
            InteractiveViewer(
              minScale: 0.5,
              maxScale: 4.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.pop(context),
                style: IconButton.styleFrom(backgroundColor: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredDonasiList;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Bar Header
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
                        'Donasi Masuk',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Daftar pengajuan minyak jelantah di lokasi TPS Anda.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filter,
                          items: const [
                            DropdownMenuItem(value: 'semua', child: Text('Semua Waktu')),
                            DropdownMenuItem(value: 'hari_ini', child: Text('Hari Ini')),
                            DropdownMenuItem(value: 'minggu_ini', child: Text('7 Hari Terakhir')),
                            DropdownMenuItem(value: 'bulan_ini', child: Text('Bulan Ini')),
                          ],
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _filter = value);
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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

            // Content Loading / Empty / Cards List
            _isLoading
                ? const Padding(
                    padding: EdgeInsets.all(64),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : filteredList.isEmpty
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(48),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: const [
                            Icon(Icons.inbox_outlined, size: 64, color: Color(0xFFCBD5E1)),
                            SizedBox(height: 16),
                            Text(
                              'Belum ada pengajuan donasi masuk',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredList.length,
                        itemBuilder: (context, index) {
                          final donasi = filteredList[index];
                          final color = _statusColor(donasi.status);

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: Color(0xFFE2E8F0)),
                            ),
                            elevation: 0,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(16),
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => DonasiDetailPengelolaPage(donasi: donasi),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                'Donasi #${donasi.id}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                              ),
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: color.withValues(alpha: 0.12),
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  donasi.status.toUpperCase(),
                                                  style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Text(
                                            'Donatur: ${donasi.donaturNama ?? '-'}  •  TPS: ${donasi.lokasi?.nama ?? '-'}',
                                            style: const TextStyle(color: Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${donasi.jumlahInput} Liter  •  ${donasi.createdAt}',
                                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (donasi.status == 'pending')
                                      ElevatedButton(
                                        onPressed: () => _verifikasi(donasi),
                                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7), foregroundColor: Colors.white),
                                        child: const Text('Verifikasi'),
                                      ),
                                    if (donasi.status == 'verifikasi')
                                      ElevatedButton(
                                        onPressed: () => _selesaikan(donasi),
                                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF10B981), foregroundColor: Colors.white),
                                        child: const Text('Selesai'),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ],
        ),
      ),
    );
  }
}