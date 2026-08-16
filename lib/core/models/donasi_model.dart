class DonasiModel {
  final int id;
  final double jumlahInput;
  final double? jumlahTerverifikasi;
  final String fotoBukti;
  final String status;
  final int? poinDiperoleh;
  final String createdAt;

  DonasiModel({
    required this.id,
    required this.jumlahInput,
    this.jumlahTerverifikasi,
    required this.fotoBukti,
    required this.status,
    this.poinDiperoleh,
    required this.createdAt,
  });

  factory DonasiModel.fromJson(Map<String, dynamic> json) {
    return DonasiModel(
      id: json['id'],
      jumlahInput: double.parse(json['jumlah_input'].toString()),
      jumlahTerverifikasi: json['jumlah_terverifikasi'] != null
          ? double.parse(json['jumlah_terverifikasi'].toString())
          : null,
      fotoBukti: json['foto_bukti'],
      status: json['status'],
      poinDiperoleh: json['poin_diperoleh'],
      createdAt: json['created_at'],
    );
  }
}