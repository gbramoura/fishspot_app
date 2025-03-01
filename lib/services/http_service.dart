import 'dart:convert';

import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/types/http_response_error.dart';
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

    if (response.body != '') {
      var body = jsonDecode(response.body);
      throw HttpResponseException(
        data: HttpResponseError(
          code: response.statusCode,
          message: body['message'] ?? '',
          errors: body['errors'] ?? [],
        ),
      );
    }

    throw HttpResponseException(
      data: HttpResponseError(
        code: response.statusCode,
        message: 'Error ao tentar entrar em contato com servidor',
      ),
    );
  }
}
