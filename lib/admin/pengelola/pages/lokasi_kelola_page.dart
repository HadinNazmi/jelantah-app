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
          const SnackBar(content: Text('Jadwal operasional TPS berhasil disimpan')),
        );
        Navigator.pop(context);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan jadwal, coba lagi')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(widget.lokasi.nama),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF0F172A),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Location Name & Address Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF047857).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.location_on_rounded, color: Color(0xFF047857), size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lokasi.nama,
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.lokasi.alamat,
                              style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Divider(color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 24),

                  // Section 1: Jam Operasional
                  const Text(
                    'JAM OPERASIONAL',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _jamBukaController,
                          decoration: InputDecoration(
                            labelText: 'Jam Buka (HH:mm)',
                            prefixIcon: const Icon(Icons.access_time_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: TextField(
                          controller: _jamTutupController,
                          decoration: InputDecoration(
                            labelText: 'Jam Tutup (HH:mm)',
                            prefixIcon: const Icon(Icons.access_time_filled_rounded),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // Section 2: Hari Operasional
                  const Text(
                    'HARI OPERASIONAL TPS',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _semuaHari.map((hari) {
                      final aktif = _hariAktif.contains(hari);
                      return FilterChip(
                        label: Text(hari),
                        selected: aktif,
                        selectedColor: const Color(0xFF047857),
                        labelStyle: TextStyle(
                          color: aktif ? Colors.white : const Color(0xFF334155),
                          fontWeight: aktif ? FontWeight.bold : FontWeight.normal,
                        ),
                        checkmarkColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: aktif ? const Color(0xFF047857) : const Color(0xFFCBD5E1)),
                        ),
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
                  const SizedBox(height: 28),
                  const Divider(color: Color(0xFFF1F5F9)),
                  const SizedBox(height: 16),

                  // Section 3: Switch Status
                  SwitchListTile(
                    title: const Text('Status Operasional Lokasi Aktif', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    subtitle: const Text('Nonaktifkan jika TPS sedang tutup sementara/renovasi', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                    value: _statusAktif,
                    activeColor: const Color(0xFF047857),
                    onChanged: (value) => setState(() => _statusAktif = value),
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSaving ? null : _simpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF047857),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: _isSaving
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : const Text('Simpan Perubahan Jadwal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}