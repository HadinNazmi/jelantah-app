import 'dart:convert';
import 'package:jelantah_app/core/api/api_client.dart';

class LokasiApi {
  static Future<Map<String, dynamic>> getLokasiList(String token) async {
    final response = await ApiClient.get('lokasi', token: token);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return {'success': true, 'data': data};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['message']};
    }
  }

  static Future<Map<String, dynamic>> getLokasiDetail(String token, int id) async {
  final response = await ApiClient.get('lokasi/$id', token: token);
  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return {'success': true, 'data': data};
  } else {
    return {'success': false, 'message': data['message']};
  }
}
}