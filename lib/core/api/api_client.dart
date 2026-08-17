import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  // Base URL backend Laravel — masih localhost untuk development
  static const String baseUrl = 'http://192.168.1.6:8000/api';

  static Future<http.Response> post(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return http.post(url, headers: headers, body: jsonEncode(body));
  }

  static Future<http.Response> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return http.get(url, headers: headers);
  }

  static Future<http.Response> put(
    String endpoint, {
    Map<String, dynamic>? body,
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    return http.put(url, headers: headers, body: jsonEncode(body));
  }

  static String imageUrl(String path) {
    final base = baseUrl.replaceAll('/api', '');
    return '$base/foto/$path';
  }
}
