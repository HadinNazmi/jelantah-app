import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/models/lokasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/admin/pengelola/pages/lokasi_kelola_page.dart';

class LokasiListPage extends StatefulWidget {
  const LokasiListPage({super.key});

  @override
  State<LokasiListPage> createState() => _LokasiListPageState();
}

class _LokasiListPageState extends State<LokasiListPage> {
  List<LokasiModel> _lokasiList = [];
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

    final response = await ApiClient.get('pengelola/lokasi', token: token);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _lokasiList = [LokasiModel.fromJson(data)];
        _isLoading = false;
      });
    } else {
      setState(() {
        _lokasiList = [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lokasi Saya'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lokasiList.isEmpty
              ? const Center(child: Text('Anda belum memiliki lokasi yang dikelola'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _lokasiList.length,
                  itemBuilder: (context, index) {
                    final lokasi = _lokasiList[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: lokasi.statusAktif ? Colors.green : Colors.grey,
                        ),
                        title: Text(lokasi.nama),
                        subtitle: Text(lokasi.alamat),
                        trailing: Chip(
                          label: Text(lokasi.sedangBuka ? 'Buka' : 'Tutup'),
                          backgroundColor: lokasi.sedangBuka ? Colors.green.shade100 : Colors.red.shade100,
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => LokasiKelolaPage(lokasi: lokasi)),
                          );
                          _loadData();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}