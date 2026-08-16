class DompetModel {
  final double totalKontribusi;
  final int totalPoin;

  DompetModel({required this.totalKontribusi, required this.totalPoin});

  factory DompetModel.fromJson(Map<String, dynamic> json) {
    return DompetModel(
      totalKontribusi: double.parse(json['total_kontribusi'].toString()),
      totalPoin: json['total_poin'],
    );
  }
}