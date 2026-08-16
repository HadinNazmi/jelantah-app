class LokasiModel {
  final int id;
  final String nama;
  final String alamat;
  final bool sedangBuka;

  LokasiModel({
    required this.id,
    required this.nama,
    required this.alamat,
    required this.sedangBuka,
  });

  factory LokasiModel.fromJson(Map<String, dynamic> json) {
    return LokasiModel(
      id: json['id'],
      nama: json['nama'],
      alamat: json['alamat'],
      sedangBuka: json['sedang_buka'] ?? false,
    );
  }
}