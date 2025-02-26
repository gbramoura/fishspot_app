import 'dart:convert';

import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  Future<dynamic> get(String path) async {
    final response = await http.get(Uri.parse('$baseUrl/$path'));
    return _handleResponse(response);
  }

  Future<dynamic> post(String path,
      {required Map<String, dynamic> body}) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    const httpSuccessCodes = [200, 201];

    if (httpSuccessCodes.contains(response.statusCode)) {
      return jsonDecode(response.body);
    }

    throw Exception('Erro na requisição: ${response.statusCode}');
  }
}
