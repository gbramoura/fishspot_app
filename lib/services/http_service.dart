import 'dart:convert';

import 'package:fishspot_app/constants/http_constants.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String baseUrl;

  HttpService({required this.baseUrl});

  Future<dynamic> get(
    String path, {
    String? token,
    Map<String, dynamic>? query,
  }) async {
    final url = Uri.http(baseUrl, '/$path', query);
    final response = await http.get(
      url,
      headers: _getDefaultHeader(token),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final url = Uri.http(baseUrl, '/$path');
    final response = await http.post(
      url,
      headers: _getDefaultHeader(token, jsonContentType: true),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> put(
    String path, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final url = Uri.http(baseUrl, '/$path');
    final response = await http.put(
      url,
      headers: _getDefaultHeader(token, jsonContentType: true),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Map<String, String> _getDefaultHeader(
    String? token, {
    bool? jsonContentType = false,
  }) {
    var header = <String, String>{
      'Accept-Language': 'pt-BR',
      'Authorization': 'Bearer $token',
    };

    if (jsonContentType != null && jsonContentType) {
      header.addAll({'Content-Type': 'application/json'});
    }

    return header;
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
