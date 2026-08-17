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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.person_add_rounded, color: Color(0xFF047857)),
            SizedBox(width: 10),
            Text('Tambah Akun Pengelola', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: 'Email Login',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: jabatanController,
                decoration: InputDecoration(
                  labelText: 'Jabatan / Catatan (Opsional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF047857),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (confirmed != true || _token == null) return;

    final response = await ApiClient.post(
      'manajemen/pengelola',
      body: {
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'password': passwordController.text,
        'jabatan': jabatanController.text.trim(),
      },
      token: _token,
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Akun pengelola berhasil dibuat')),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal membuat akun, cek data yang diisi')),
        );
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(Icons.edit_note_rounded, color: Color(0xFF047857)),
            SizedBox(width: 10),
            Text('Edit Data Pengelola', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Nama Lengkap', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Nomor HP', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: jabatanController,
                decoration: InputDecoration(labelText: 'Jabatan', border: OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF047857),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan Perubahan'),
          ),
        ],
      ),
    );

    if (confirmed != true || _token == null) return;

    final response = await ApiClient.put(
      'manajemen/pengelola/${pengelola['id']}',
      body: {
        'name': nameController.text.trim(),
        'phone': phoneController.text.trim(),
        'jabatan': jabatanController.text.trim(),
      },
      token: _token,
    );

    if (response.statusCode == 200) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data pengelola berhasil diperbarui')),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'] ?? 'Status akun berhasil diubah')),
        );
      }
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
            // Page Header with Action Button (Responsive Wrap)
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
                        'Kelola Pengelola TPS',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Manajemen akun pengelola dan penugasan lokasi TPS.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
                      ),
                    ],
                  ),
                ),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _tambahPengelola,
                      icon: const Icon(Icons.person_add_rounded, size: 18),
                      label: const Text('Tambah Pengelola'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047857),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
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

            // Content Table Card Container
            Container(
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
              child: _isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : _pengelolaList.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(child: Text('Belum ada akun pengelola', style: TextStyle(color: Colors.grey))),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _pengelolaList.length,
                          separatorBuilder: (_, __) => const Divider(color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final pengelola = _pengelolaList[index];
                            final lokasi = pengelola['lokasi'];
                            final isActive = pengelola['is_active'] == 1 || pengelola['is_active'] == true;

                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 22,
                                    backgroundColor: isActive ? const Color(0xFF047857).withValues(alpha: 0.1) : const Color(0xFFF1F5F9),
                                    child: Icon(
                                      Icons.person_rounded,
                                      color: isActive ? const Color(0xFF047857) : const Color(0xFF94A3B8),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              pengelola['name'] ?? '-',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF0F172A),
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: isActive ? const Color(0xFF10B981).withValues(alpha: 0.1) : const Color(0xFFE2E8F0),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: Text(
                                                isActive ? 'AKTIF' : 'NONAKTIF',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.bold,
                                                  color: isActive ? const Color(0xFF047857) : const Color(0xFF64748B),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          '${pengelola['email'] ?? '-'}${lokasi != null ? ' • Lokasi: ${lokasi['nama']}' : ' • Belum ditugaskan di TPS'}',
                                          style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Actions: Edit & Active Switch
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.edit_rounded, size: 20, color: Color(0xFF0284C7)),
                                        onPressed: () => _editPengelola(pengelola),
                                        tooltip: 'Edit Data',
                                      ),
                                      const SizedBox(width: 8),
                                      Switch(
                                        value: isActive,
                                        activeColor: const Color(0xFF047857),
                                        onChanged: (_) => _toggleStatus(pengelola),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}