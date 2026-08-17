import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class KelolaLokasiPage extends StatefulWidget {
  const KelolaLokasiPage({super.key});

  @override
  State<KelolaLokasiPage> createState() => _KelolaLokasiPageState();
}

class _KelolaLokasiPageState extends State<KelolaLokasiPage> {
  List<dynamic> _lokasiList = [];
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

    final lokasiRes = await ApiClient.get('manajemen/lokasi', token: token);
    final pengelolaRes = await ApiClient.get('manajemen/pengelola', token: token);

    if (lokasiRes.statusCode == 200 && pengelolaRes.statusCode == 200) {
      setState(() {
        _lokasiList = jsonDecode(lokasiRes.body);
        _pengelolaList = jsonDecode(pengelolaRes.body);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _tambahLokasi() async {
    final namaController = TextEditingController();
    final alamatController = TextEditingController();
    final latController = TextEditingController();
    final lngController = TextEditingController();
    final jamBukaController = TextEditingController(text: '08:00');
    final jamTutupController = TextEditingController(text: '17:00');
    final hariController = TextEditingController(text: 'Senin,Selasa,Rabu,Kamis,Jumat');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Lokasi Baru'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: namaController, decoration: const InputDecoration(labelText: 'Nama Lokasi')),
              TextField(controller: alamatController, decoration: const InputDecoration(labelText: 'Alamat')),
              Row(
                children: [
                  Expanded(child: TextField(controller: latController, decoration: const InputDecoration(labelText: 'Latitude'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: lngController, decoration: const InputDecoration(labelText: 'Longitude'))),
                ],
              ),
              Row(
                children: [
                  Expanded(child: TextField(controller: jamBukaController, decoration: const InputDecoration(labelText: 'Jam Buka'))),
                  const SizedBox(width: 8),
                  Expanded(child: TextField(controller: jamTutupController, decoration: const InputDecoration(labelText: 'Jam Tutup'))),
                ],
              ),
              TextField(controller: hariController, decoration: const InputDecoration(labelText: 'Hari (pisah koma)')),
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
      'manajemen/lokasi',
      body: {
        'nama': namaController.text,
        'alamat': alamatController.text,
        'latitude': double.tryParse(latController.text) ?? 0,
        'longitude': double.tryParse(lngController.text) ?? 0,
        'jam_buka': jamBukaController.text,
        'jam_tutup': jamTutupController.text,
        'hari_operasional': hariController.text,
      },
      token: _token,
    );

    if (response.statusCode == 201) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lokasi berhasil ditambahkan')));
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal menambahkan lokasi, cek data yang diisi')));
      }
    }
  }

  Future<void> _assignPengelola(Map<String, dynamic> lokasi) async {
    int? selectedPengelolaId = lokasi['pengelola_id'];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Assign Pengelola — ${lokasi['nama']}'),
          content: DropdownButtonFormField<int>(
            value: selectedPengelolaId,
            decoration: const InputDecoration(labelText: 'Pilih Pengelola'),
            items: [
              const DropdownMenuItem(value: null, child: Text('— Tidak ada —')),
              ..._pengelolaList.map((p) => DropdownMenuItem<int>(
                    value: p['id'],
                    child: Text(p['name']),
                  )),
            ],
            onChanged: (value) => setDialogState(() => selectedPengelolaId = value),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Batal')),
            ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Simpan')),
          ],
        ),
      ),
    );

    if (confirmed != true || _token == null) return;

    final response = await ApiClient.put(
      'manajemen/lokasi/${lokasi['id']}',
      body: {'pengelola_id': selectedPengelolaId},
      token: _token,
    );

    if (response.statusCode == 200) {
      _loadData();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengelola berhasil ditetapkan')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Lokasi'),
        actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: _loadData)],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tambahLokasi,
        icon: const Icon(Icons.add),
        label: const Text('Tambah Lokasi'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _lokasiList.isEmpty
              ? const Center(child: Text('Belum ada lokasi'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _lokasiList.length,
                  itemBuilder: (context, index) {
                    final lokasi = _lokasiList[index];
                    final pengelola = lokasi['pengelola'];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Icon(
                          Icons.location_on,
                          color: lokasi['status_aktif'] == 1 || lokasi['status_aktif'] == true
                              ? Colors.green
                              : Colors.grey,
                        ),
                        title: Text(lokasi['nama'] ?? '-'),
                        subtitle: Text(
                          '${lokasi['alamat'] ?? '-'}\nPengelola: ${pengelola != null ? pengelola['name'] : 'Belum ditetapkan'}',
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.person_add_alt),
                          onPressed: () => _assignPengelola(lokasi),
                          tooltip: 'Assign Pengelola',
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}