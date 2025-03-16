import 'dart:io';

import 'http_service.dart';

class ApiService {
  final url = '10.0.2.2:5010';
  final _httpService = HttpService(baseUrl: '10.0.2.2:5010');

  Future<dynamic> register(Map<String, dynamic> payload) async {
    return await _httpService.post('auth/register', body: payload);
  }

  Future<dynamic> login(Map<String, dynamic> payload) async {
    return await _httpService.post('auth/login', body: payload);
  }

  Future<dynamic> refreshToken(Map<String, dynamic> payload) async {
    return await _httpService.post('auth/refresh-token', body: payload);
  }

  Future<dynamic> isAuth(String token) async {
    return await _httpService.post('auth/is-auth', body: {}, token: token);
  }

  Future<dynamic> getUser(String token) async {
    return await _httpService.get('user', token: token);
  }

  Future<dynamic> updateUser(Map<String, dynamic> payload, String token) async {
    return await _httpService.put('user', body: payload, token: token);
  }

  Future<dynamic> getImage(String id, String token) async {
    return await _httpService.get('resources/$id', token: token);
  }

  Future<dynamic> getLocations(String token) async {
    return await _httpService.get('spot', token: token);
  }

  Future<dynamic> getUserLocations(
    Map<String, String> query,
    String token,
  ) async {
    return await _httpService.get('spot/by-user', token: token, query: query);
  }

  Future<dynamic> attachUserImage(Map<String, File> files, String token) async {
    return await _httpService.uploadMultipart(
      'resources/attach-to-user',
      files: files,
    );
  }

  String getResource(String id, String token) {
    return Uri.http(url, '/resources/$id', {'token': token}).toString();
  }
}
