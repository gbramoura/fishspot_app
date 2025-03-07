import 'dart:convert';

import 'package:fishspot_app/constants/http_constants.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_response.dart';
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

  HttpResponse _handleResponse(http.Response response) {
    var httpSuccessCodes = [HTTP.Ok, HTTP.Created];

    if (httpSuccessCodes.contains(response.statusCode)) {
      var body = jsonDecode(response.body);
      return HttpResponse.fromJson(body);
    }

    if (response.body != '') {
      var body = jsonDecode(response.body);
      throw HttpResponseException(data: HttpResponse.fromJson(body));
    }

    throw HttpResponseException(
      data: HttpResponse(
        code: response.statusCode,
        message: 'Error ao tentar entrar em contato com servidor',
      ),
    );
  }
}
