import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class KelolaPengelolaPage extends StatefulWidget {
  const KelolaPengelolaPage({super.key});

  @override
  State<KelolaPengelolaPage> createState() => _KelolaPengelolaPageState();
}

class _KelolaPengelolaPageState extends State<KelolaPengelolaPage> {
  List<dynamic> _pengelolaList = [];
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

    final response = await ApiClient.get('manajemen/pengelola', token: token);

    if (response.statusCode == 200) {
      setState(() {
        _pengelolaList = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _tambahPengelola() async {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final jabatanController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Akun Pengelola'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama')),
              TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
              TextField(controller: jabatanController, decoration: const InputDecoration(labelText: 'Jabatan (opsional)')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
        ],
      ),
    );

    if (confirmed != true || _token == null) return;

    final response = await ApiClient.post(
      'manajemen/pengelola',
      body: {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'jabatan': jabatanController.text,
      },
      token: _token,
    );

    if (response.statusCode == 201) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Akun pengelola berhasil dibuat')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal membuat akun, cek data yang diisi')));
      }
    }
  }

  Future<void> _editPengelola(Map<String, dynamic> pengelola) async {
    final nameController = TextEditingController(text: pengelola['name']);
    final phoneController = TextEditingController(text: pengelola['phone'] ?? '');
    final jabatanController = TextEditingController(
      text: pengelola['data_pengelola'] != null ? pengelola['data_pengelola']['jabatan'] ?? '' : '',
    );

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Pengelola'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Nama')),
              TextField(controller: phoneController, decoration: const InputDecoration(labelText: 'Nomor HP')),
              TextField(controller: jabatanController, decoration: const InputDecoration(labelText: 'Jabatan')),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
        ],
      ),
    );

    if (confirmed != true || _token == null) return;

    final response = await ApiClient.put(
      'manajemen/pengelola/${pengelola['id']}',
      body: {
        'name': nameController.text,
        'phone': phoneController.text,
        'jabatan': jabatanController.text,
      },
      token: _token,
    );

    if (response.statusCode == 200) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data pengelola berhasil diperbarui')));
      }
    }
  }

  Future<void> _toggleStatus(Map<String, dynamic> pengelola) async {
    if (_token == null) return;

    final response = await ApiClient.put(
      'manajemen/pengelola/${pengelola['id']}/toggle-status',
      token: _token,
    );

    if (response.statusCode == 200) {
      _loadData();
      if (mounted) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Pengelola'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahPengelola,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Pengelola'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pengelolaList.isEmpty
              ? const Center(child: Text('Belum ada akun pengelola'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pengelolaList.length,
                  itemBuilder: (context, index) {
                    final pengelola = _pengelolaList[index];
                    final lokasi = pengelola['lokasi'];
                    final isActive = pengelola['is_active'] == 1 || pengelola['is_active'] == true;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isActive ? Colors.green.shade100 : Colors.grey.shade300,
                          child: Icon(Icons.person, color: isActive ? Colors.green : Colors.grey),
                        ),
                        title: Text(pengelola['name'] ?? '-'),
                        subtitle: Text(
                          '${pengelola['email'] ?? '-'}${lokasi != null ? ' • Lokasi: ${lokasi['nama']}' : ' • Belum ada lokasi'}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _editPengelola(pengelola),
                              tooltip: 'Edit',
                            ),
                            Switch(
                              value: isActive,
                              onChanged: (_) => _toggleStatus(pengelola),
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