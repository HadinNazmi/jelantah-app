import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/models/donasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class DonasiMasukPage extends StatefulWidget {
  const DonasiMasukPage({super.key});

  @override
  State<DonasiMasukPage> createState() => _DonasiMasukPageState();
}

class _DonasiMasukPageState extends State<DonasiMasukPage> {
  List<DonasiModel> _donasiList = [];
  bool _isLoading = true;
  String? _token;

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

  @override
  Widget build(BuildContext context) {
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
                IconButton(
                  icon: const Icon(Icons.refresh_rounded, color: Color(0xFF64748B)),
                  onPressed: _loadData,
                  tooltip: 'Refresh Data',
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
                : _donasiList.isEmpty
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
                        itemCount: _donasiList.length,
                        itemBuilder: (context, index) {
                          final donasi = _donasiList[index];
                          final color = _statusColor(donasi.status);

                          return Container(
                            margin: const EdgeInsets.only(bottom: 20),
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
                                // Top Header Row
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Donasi #${donasi.id}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF0F172A),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          donasi.createdAt,
                                          style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        donasi.status.toUpperCase(),
                                        style: TextStyle(
                                          color: color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                const Divider(color: Color(0xFFF1F5F9)),
                                const SizedBox(height: 16),

                                // Data Comparison Row & Image Preview
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Info Columns
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('INPUT DONATUR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${donasi.jumlahInput} Liter',
                                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                                          ),
                                          const SizedBox(height: 16),
                                          const Text('HASIL VERIFIKASI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                          const SizedBox(height: 4),
                                          Text(
                                            donasi.jumlahTerverifikasi != null ? '${donasi.jumlahTerverifikasi} Liter' : 'Belum Diverifikasi',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: donasi.jumlahTerverifikasi != null ? const Color(0xFF047857) : const Color(0xFF94A3B8),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Foto Bukti Preview
                                    SizedBox(
                                      width: 280,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Text('FOTO BUKTI TIMBANGAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                                          const SizedBox(height: 6),
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(12),
                                            child: Image.network(
                                              ApiClient.imageUrl(donasi.fotoBukti),
                                              width: double.infinity,
                                              height: 160,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                width: double.infinity,
                                                height: 160,
                                                color: const Color(0xFFF1F5F9),
                                                child: const Icon(Icons.broken_image, size: 40, color: Color(0xFF94A3B8)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),

                                // Bottom Action Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    if (donasi.status == 'pending')
                                      ElevatedButton.icon(
                                        onPressed: () => _verifikasi(donasi),
                                        icon: const Icon(Icons.fact_check_rounded, size: 18),
                                        label: const Text('Verifikasi Penimbangan'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF0284C7),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    if (donasi.status == 'verifikasi') ...[
                                      ElevatedButton.icon(
                                        onPressed: () => _selesaikan(donasi),
                                        icon: const Icon(Icons.check_circle_rounded, size: 18),
                                        label: const Text('Tandai Selesai & Beri Poin'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF10B981),
                                          foregroundColor: Colors.white,
                                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
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