import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class KonfigurasiPoinPage extends StatefulWidget {
  const KonfigurasiPoinPage({super.key});

  @override
  State<KonfigurasiPoinPage> createState() => _KonfigurasiPoinPageState();
}

class _KonfigurasiPoinPageState extends State<KonfigurasiPoinPage> {
  List<dynamic> _riwayat = [];
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

    final response = await ApiClient.get('konfigurasi-poin', token: token);

    if (response.statusCode == 200) {
      setState(() {
        _riwayat = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _setRateBaru() async {
    final controller = TextEditingController();

    final rate = await showDialog<double>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Rate Poin Baru'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Liter per 1 poin', hintText: 'Misal: 1.00'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, double.tryParse(controller.text)),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (rate == null || _token == null) return;

    final response = await ApiClient.post(
      'konfigurasi-poin',
      body: {'liter_per_poin': rate},
      token: _token,
    );

    if (response.statusCode == 201) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Rate poin berhasil diperbarui')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Konfigurasi Poin'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _setRateBaru,
        icon: const Icon(Icons.add),
        label: const Text('Set Rate Baru'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _riwayat.length,
              itemBuilder: (context, index) {
                final item = _riwayat[index];
                final isTerbaru = index == 0;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isTerbaru ? Colors.green.shade50 : null,
                  child: ListTile(
                    leading: Icon(Icons.stars, color: isTerbaru ? Colors.green : Colors.grey),
                    title: Text('${item['liter_per_poin']} liter = 1 poin'),
                    subtitle: Text('Berlaku sejak: ${item['berlaku_mulai']}'),
                    trailing: isTerbaru ? const Chip(label: Text('AKTIF')) : null,
                  ),
                );
              },
            ),
    );
  }
}