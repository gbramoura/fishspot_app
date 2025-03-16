import 'dart:convert';
import 'dart:io';

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

  Future<HttpResponse> uploadMultipart(
    String path, {
    Map<String, String>? fields,
    Map<String, File>? files,
    String? token,
  }) async {
    final url = Uri.http(baseUrl, '/$path');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(_getDefaultHeader(token));
    fields?.forEach((key, value) {
      request.fields[key] = value;
    });

    if (files != null) {
      for (var entry in files.entries) {
        request.files.add(
          await http.MultipartFile.fromPath(entry.key, entry.value.path),
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

  Future<HttpResponse> _handleStreamResponse(
      http.StreamedResponse response) async {
    var httpSuccessCodes = [HTTP.Ok, HTTP.Created];

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
}
