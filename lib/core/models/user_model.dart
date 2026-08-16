class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? phone;
  final String? alamat;
  final String? nik;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.phone,
    this.alamat,
    this.nik,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final dataMasy = json['data_masyarakat'] as Map<String, dynamic>?;
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      phone: json['phone'],
      alamat: dataMasy != null ? dataMasy['alamat'] : json['alamat'],
      nik: dataMasy != null ? dataMasy['nomor_ktp'] : (json['nomor_ktp'] ?? json['nik']),
    );
  }
}