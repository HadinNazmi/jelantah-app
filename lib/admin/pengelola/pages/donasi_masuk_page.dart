import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/models/donasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'dart:convert';

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
        title: const Text('Verifikasi Donasi'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Jumlah aktual (liter)'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, double.tryParse(controller.text)),
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
          const SnackBar(content: Text('Donasi ditandai selesai')),
        );
      }
    }
  }

  Color _statusColor(String status) {
    switch (status) {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Donasi Masuk'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _donasiList.isEmpty
              ? const Center(child: Text('Belum ada pengajuan donasi'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _donasiList.length,
                  itemBuilder: (context, index) {
                    final donasi = _donasiList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Donasi #${donasi.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                Chip(
                                  label: Text(donasi.status.toUpperCase()),
                                  backgroundColor: _statusColor(donasi.status).withOpacity(0.15),
                                  labelStyle: TextStyle(color: _statusColor(donasi.status)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text('Jumlah input: ${donasi.jumlahInput} liter'),
                            if (donasi.jumlahTerverifikasi != null)
                              Text('Jumlah terverifikasi: ${donasi.jumlahTerverifikasi} liter'),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                ApiClient.imageUrl(donasi.fotoBukti),
                                width: double.infinity,
                                height: 180,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: double.infinity,
                                  height: 180,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.broken_image, size: 48, color: Colors.grey),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (donasi.status == 'pending')
                                  ElevatedButton(
                                    onPressed: () => _verifikasi(donasi),
                                    child: const Text('Verifikasi'),
                                  ),
                                if (donasi.status == 'verifikasi') ...[
                                  const SizedBox(width: 8),
                                  ElevatedButton(
                                    onPressed: () => _selesaikan(donasi),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                                    child: const Text('Tandai Selesai'),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}