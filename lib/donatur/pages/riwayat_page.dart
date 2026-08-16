import 'package:flutter/material.dart';
import 'package:jelantah_app/core/api/donasi_api.dart';
import 'package:jelantah_app/core/models/donasi_model.dart';
import 'package:jelantah_app/core/services/auth_service.dart';
import 'package:jelantah_app/core/theme/app_theme.dart';

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<DonasiModel> _allRiwayat = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _selectedFilter = 'Semua';

  final List<String> _filterOptions = ['Semua', 'Pending', 'Verifikasi', 'Selesai'];

  @override
  void initState() {
    super.initState();
    _fetchRiwayat();
  }

  Future<void> _fetchRiwayat() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final token = await AuthService.getToken();
    if (token == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Sesi telah berakhir, silakan login kembali.';
        });
      }
      return;
    }

    final result = await DonasiApi.getMyDonasi(token);

    if (mounted) {
      if (result['success'] == true) {
        final List<dynamic> data = result['data'];
        setState(() {
          _allRiwayat = data.map((e) => DonasiModel.fromJson(e)).toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = result['message'] ?? 'Gagal memuat riwayat donasi';
          _isLoading = false;
        });
      }
    }
  }

  List<DonasiModel> get _filteredRiwayat {
    if (_selectedFilter == 'Semua') return _allRiwayat;
    return _allRiwayat.where((item) {
      return item.status.toLowerCase() == _selectedFilter.toLowerCase();
    }).toList();
  }

  Widget _buildStatusChip(String status) {
    Color bg;
    Color text;
    String label;

    switch (status.toLowerCase()) {
      case 'pending':
        bg = AppColors.statusPendingBg;
        text = AppColors.statusPendingText;
        label = 'Pending';
        break;
      case 'verifikasi':
        bg = AppColors.statusVerifikasiBg;
        text = AppColors.statusVerifikasiText;
        label = 'Diverifikasi';
        break;
      case 'selesai':
        bg = AppColors.statusSelesaiBg;
        text = AppColors.statusSelesaiText;
        label = 'Selesai';
        break;
      default:
        bg = const Color(0xFFF1F5F9);
        text = AppColors.textSecondary;
        label = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: text,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String _formatTanggal(String rawDate) {
    try {
      final dt = DateTime.parse(rawDate).toLocal();
      return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} WIB';
    } catch (_) {
      return rawDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final list = _filteredRiwayat;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Donasi'),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchRiwayat,
        child: Column(
          children: [
            // Filter Bar
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _filterOptions.length,
                itemBuilder: (context, index) {
                  final filter = _filterOptions[index];
                  final isSelected = _selectedFilter == filter;

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          setState(() => _selectedFilter = filter);
                        }
                      },
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.surface,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primary : AppColors.border,
                        ),
                      ),
                      showCheckmark: false,
                    ),
                  );
                },
              ),
            ),

            // Main Content Area
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(_errorMessage!, textAlign: TextAlign.center),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: _fetchRiwayat,
                                  child: const Text('Coba Lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : list.isEmpty
                          ? ListView(
                              children: const [
                                SizedBox(height: 100),
                                Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.history_rounded, size: 64, color: AppColors.textSecondary),
                                      SizedBox(height: 12),
                                      Text(
                                        'Belum ada riwayat donasi',
                                        style: TextStyle(fontSize: 15, color: AppColors.textSecondary),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                final item = list[index];
                                final lokasiNama = item.lokasi?.nama ?? 'TPS Donasi Jelantah';

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    side: const BorderSide(color: AppColors.border),
                                  ),
                                  elevation: 2,
                                  shadowColor: Colors.black.withValues(alpha: 0.04),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(10),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFECFDF5),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.water_drop_rounded,
                                                color: AppColors.primary,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    lokasiNama,
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: AppColors.textPrimary,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    _formatTanggal(item.createdAt),
                                                    style: const TextStyle(
                                                      color: AppColors.textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            _buildStatusChip(item.status),
                                          ],
                                        ),
                                        const Divider(height: 24),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                const Text(
                                                  'Input Donatur',
                                                  style: TextStyle(
                                                    color: AppColors.textSecondary,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '${item.jumlahInput} Liter',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (item.jumlahTerverifikasi != null)
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Hasil Timbangan',
                                                    style: TextStyle(
                                                      color: AppColors.textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '${item.jumlahTerverifikasi} Liter',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: AppColors.statusVerifikasiText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            if (item.poinDiperoleh != null && item.status == 'selesai')
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  const Text(
                                                    'Poin',
                                                    style: TextStyle(
                                                      color: AppColors.textSecondary,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '+${item.poinDiperoleh} Pts',
                                                    style: const TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15,
                                                      color: AppColors.secondaryGold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
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