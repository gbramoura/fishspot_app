import 'dart:convert';

import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_response_error.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  Future<dynamic> get(String path, {String? token}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/$path'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    const httpSuccessCodes = [200, 201];
    const httpUnauthorizedCodes = [401];

    if (httpUnauthorizedCodes.contains(response.statusCode)) {
      // TODO: User is unautorized, show reset preferencs and navigate to login page
    }

    if (httpSuccessCodes.contains(response.statusCode)) {
      return jsonDecode(response.body);
    }

    if (response.body != '') {
      var body = jsonDecode(response.body);
      throw HttpResponseException(data: HttpResponseError.fromJson(body));
    }

    throw HttpResponseException(
      data: HttpResponseError(
        code: response.statusCode,
        message: 'Error ao tentar entrar em contato com servidor',
      ),
    );
  }
}
