import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:jelantah_app/core/api/api_client.dart';

class DonasiApi {
  static Future<Map<String, dynamic>> ajukanDonasi({
    required String token,
    required int lokasiId,
    required double jumlahInput,
    required File fotoBukti,
  }) async {
    final uri = Uri.parse('${ApiClient.baseUrl}/donasi');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['lokasi_id'] = lokasiId.toString();
    request.fields['jumlah_input'] = jumlahInput.toString();

    request.files.add(
      await http.MultipartFile.fromPath('foto_bukti', fotoBukti.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'errors': data['errors'] ?? data['message']};
    }
  }

  static Future<Map<String, dynamic>> getMyDonasi(String token) async {
    final response = await ApiClient.get('donasi', token: token);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return {'success': true, 'data': data};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['message']};
    }
  }

  static Future<Map<String, dynamic>> getDonasiDetail(String token, int id) async {
  final response = await ApiClient.get('donasi/$id', token: token);
  final data = jsonDecode(response.body);

  if (response.statusCode == 200) {
    return {'success': true, 'data': data};
  } else {
    return {'success': false, 'message': data['message']};
  }
}
}