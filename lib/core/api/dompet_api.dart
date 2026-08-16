import 'dart:convert';
import 'package:jelantah_app/core/api/api_client.dart';

class DompetApi {
  static Future<Map<String, dynamic>> getMyDompet(String token) async {
    final response = await ApiClient.get('dompet', token: token);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message']};
    }
  }
}