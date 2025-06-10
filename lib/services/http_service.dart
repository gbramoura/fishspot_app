import 'dart:convert';

import 'package:fishspot_app/constants/http_constants.dart';
import 'package:fishspot_app/exceptions/http_response_exception.dart';
import 'package:fishspot_app/models/http_multipart_file.dart';
import 'package:fishspot_app/models/http_response.dart';
import 'package:http/http.dart' as http;

class HttpService {
  final String host;
  final int port;
  final String scheme;

  HttpService({
    required this.host,
    required this.port,
    required this.scheme,
  });

  Future<dynamic> get(
    String path, {
    String? token,
    Map<String, dynamic>? query,
  }) async {
    final stringQuery = query != null ? mapToQueryString(query) : '';
    final url = Uri(
      host: host,
      port: port,
      path: '/$path',
      scheme: scheme,
      query: stringQuery,
    );
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
    final url = Uri(host: host, port: port, path: '/$path', scheme: scheme);
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
    final url = Uri(host: host, port: port, path: '/$path', scheme: scheme);
    final response = await http.put(
      url,
      headers: _getDefaultHeader(token, jsonContentType: true),
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String path, {
    String? token,
  }) async {
    final url = Uri(host: host, port: port, path: '/$path', scheme: scheme);
    final response = await http.delete(
      url,
      headers: _getDefaultHeader(token, jsonContentType: true),
    );
    return _handleResponse(response);
  }

  Future<HttpResponse> uploadMultipart(
    String path, {
    Map<String, String>? fields,
    List<HttpMultipartFile>? files,
    String? token,
  }) async {
    final url = Uri(host: host, port: port, path: '/$path', scheme: scheme);
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(_getDefaultHeader(token));
    fields?.forEach((key, value) {
      request.fields[key] = value;
    });

    if (files != null) {
      for (var entry in files) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.path, entry.file.path),
        );
      }
    }

    final response = await request.send();

    return _handleStreamResponse(response);
  }

  Map<String, String> _getDefaultHeader(
    String? token, {
    bool? jsonContentType = false,
    bool? multiPartFormData = false,
  }) {
    var header = <String, String>{
      'Accept-Language': 'pt-BR',
      'Authorization': 'Bearer $token',
    };

    if (jsonContentType != null && jsonContentType) {
      header.addAll({'Content-Type': 'application/json'});
    }

    if (multiPartFormData != null && multiPartFormData) {
      header.addAll({'Content-Type': 'multipart/form-data'});
    }

    return header;
  }

  HttpResponse _handleResponse(http.Response response) {
    var httpSuccessCodes = [HTTP.ok, HTTP.created];

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

  Future<HttpResponse> _handleStreamResponse(
      http.StreamedResponse response) async {
    var httpSuccessCodes = [HTTP.ok, HTTP.created];

    if (httpSuccessCodes.contains(response.statusCode)) {
      var responseBody = await response.stream.bytesToString();
      var body = jsonDecode(responseBody);
      return HttpResponse.fromJson(body);
    }

    final responseBody = await response.stream.bytesToString();

    if (responseBody != '') {
      var body = jsonDecode(responseBody);
      throw HttpResponseException(data: HttpResponse.fromJson(body));
    }

    throw HttpResponseException(
      data: HttpResponse(
        code: response.statusCode,
        message: 'Error ao tentar entrar em contato com servidor',
      ),
    );
  }

  String mapToQueryString(Map<String, dynamic> params) {
    if (params.isEmpty) {
      return '';
    }

    List<String> queryParts = params.entries.map((entry) {
      String key = Uri.encodeQueryComponent(entry.key.toString());
      String value = Uri.encodeQueryComponent(entry.value.toString());
      return '$key=$value';
    }).toList();

    return queryParts.join('&');
  }
}
