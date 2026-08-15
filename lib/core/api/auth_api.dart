import 'dart:convert';
import 'package:jelantah_app/core/api/api_client.dart';

class AuthApi {
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    required String platform, // "mobile" atau "web"
  }) async {
    final response = await ApiClient.post('login', body: {
      'email': email,
      'password': password,
      'platform': platform,
    });

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'message': data['message'] ?? 'Login gagal'};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    String? phone,
  }) async {
    final response = await ApiClient.post('register', body: {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
    });

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return {'success': true, 'data': data};
    } else {
      return {'success': false, 'errors': data['errors'] ?? data['message']};
    }
  }
}