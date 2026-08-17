import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/models/lokasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';

class LokasiKelolaPage extends StatefulWidget {
  final LokasiModel lokasi;

  const LokasiKelolaPage({super.key, required this.lokasi});

  @override
  State<LokasiKelolaPage> createState() => _LokasiKelolaPageState();
}

class _LokasiKelolaPageState extends State<LokasiKelolaPage> {
  late final TextEditingController _jamBukaController;
  late final TextEditingController _jamTutupController;
  final Set<String> _hariAktif = {};
  late bool _statusAktif;
  bool _isSaving = false;

  final List<String> _semuaHari = [
    'Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat', 'Sabtu', 'Minggu'
  ];

  @override
  void initState() {
    super.initState();
    _jamBukaController = TextEditingController(text: widget.lokasi.jamBuka?.substring(0, 5) ?? '08:00');
    _jamTutupController = TextEditingController(text: widget.lokasi.jamTutup?.substring(0, 5) ?? '17:00');
    _statusAktif = widget.lokasi.statusAktif;
    if (widget.lokasi.hariOperasional != null) {
      _hariAktif.addAll(widget.lokasi.hariOperasional!.split(','));
    }
  }

  Future<void> _simpan() async {
    setState(() => _isSaving = true);
    final token = await AuthService.getToken();

    final response = await ApiClient.put(
      'pengelola/lokasi/${widget.lokasi.id}',
      body: {
        'jam_buka': _jamBukaController.text,
        'jam_tutup': _jamTutupController.text,
        'hari_operasional': _hariAktif.join(','),
        'status_aktif': _statusAktif,
      },
      token: token,
    );

    setState(() => _isSaving = false);

    if (response.statusCode == 200) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Jadwal berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan, coba lagi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lokasi.nama)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.lokasi.alamat, style: TextStyle(color: Colors.grey.shade600)),
              const SizedBox(height: 24),

              const Text('Jam Operasional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _jamBukaController,
                      decoration: const InputDecoration(labelText: 'Jam Buka (HH:mm)', border: OutlineInputBorder()),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _jamTutupController,
                      decoration: const InputDecoration(labelText: 'Jam Tutup (HH:mm)', border: OutlineInputBorder()),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              const Text('Hari Operasional', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: _semuaHari.map((hari) {
                  final aktif = _hariAktif.contains(hari);
                  return FilterChip(
                    label: Text(hari),
                    selected: aktif,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _hariAktif.add(hari);
                        } else {
                          _hariAktif.remove(hari);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 24),

              SwitchListTile(
                title: const Text('Lokasi Aktif'),
                subtitle: const Text('Nonaktifkan jika lokasi sedang tidak beroperasi sama sekali'),
                value: _statusAktif,
                onChanged: (value) => setState(() => _statusAktif = value),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _isSaving ? null : _simpan,
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 14)),
                child: _isSaving ? const CircularProgressIndicator() : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}