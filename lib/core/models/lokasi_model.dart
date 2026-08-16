class LokasiModel {
  final int id;
  final String nama;
  final String alamat;
  final bool sedangBuka;
  final String? jamBuka;
  final String? jamTutup;
  final String? hariOperasional;
  final String? pengelolaNama;

  LokasiModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.sedangBuka,
    this.jamBuka,
    this.jamTutup,
    this.hariOperasional,
    this.pengelolaNama,
  });

  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      sedangBuka: json['sedang_buka'] ?? false,
      jamBuka: json['jam_buka'],
      jamTutup: json['jam_tutup'],
      hariOperasional: json['hari_operasional'],
      pengelolaNama: json['pengelola'] != null ? json['pengelola']['name'] : null,
    );
  }
}