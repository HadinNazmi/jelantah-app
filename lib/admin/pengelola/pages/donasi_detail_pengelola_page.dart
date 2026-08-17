import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/api_client.dart';
import 'package:jelantah_app/core/models/donasi_model.dart';

class DonasiDetailPengelolaPage extends StatelessWidget {
  final DonasiModel donasi;

  const DonasiDetailPengelolaPage({super.key, required this.donasi});

  Color _statusColor() {
    switch (donasi.status) {
      case 'selesai':
        return Colors.green;
      case 'verifikasi':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  void _tampilkanGambar(BuildContext context, String imageUrl) {
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
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Donasi #${donasi.id}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                children: [
                  Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: _statusColor().withOpacity(0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Chip(
                  label: Text(donasi.status.toUpperCase()),
                  backgroundColor: _statusColor().withOpacity(0.2),
                ),
                const SizedBox(height: 8),
                if (donasi.donaturNama != null)
                  Text('Donatur: ${donasi.donaturNama}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Foto Timbangan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () => _tampilkanGambar(context, ApiClient.imageUrl(donasi.fotoBukti)),
                    borderRadius: BorderRadius.circular(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        ApiClient.imageUrl(donasi.fotoBukti),
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          height: 220,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _DataRow(icon: Icons.oil_barrel, label: 'INPUT DONATUR', value: '${donasi.jumlahInput} Liter'),
                  const Divider(),
                  _DataRow(
                    icon: Icons.fact_check,
                    label: 'HASIL VERIFIKASI',
                    value: donasi.jumlahTerverifikasi != null ? '${donasi.jumlahTerverifikasi} Liter' : '-',
                  ),
                  const Divider(),
                  _DataRow(
                    icon: Icons.stars,
                    label: 'POIN DITERIMA',
                    value: donasi.poinDiperoleh != null ? '${donasi.poinDiperoleh} Poin' : '-',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Riwayat Proses', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 12),
                  _TimelineItem(title: 'Diajukan oleh Donatur', time: donasi.createdAt, done: true),
                  if (donasi.verifiedAt != null)
                    _TimelineItem(
                      title: 'Diverifikasi',
                      time: donasi.verifiedAt!,
                      subtitle: donasi.verifikatorNama != null ? 'Oleh: ${donasi.verifikatorNama}' : null,
                      done: true,
                    ),
                  if (donasi.status == 'selesai')
                    _TimelineItem(title: 'Selesai & Poin Ditambahkan', time: donasi.verifiedAt ?? '', done: true),
                ],
              ),
            ),
          ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DataRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: Colors.green.shade50, child: Icon(icon, color: Colors.green)),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
              Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final String title;
  final String time;
  final String? subtitle;
  final bool done;

  const _TimelineItem({required this.title, required this.time, this.subtitle, this.done = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: done ? Colors.green : Colors.grey.shade300,
            child: const Icon(Icons.check, size: 14, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                if (subtitle != null)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(8)),
                    child: Text(subtitle!, style: const TextStyle(fontSize: 12)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}