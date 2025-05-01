import 'package:fishspot_app/models/http_multipart_file.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'http_service.dart';

class ApiService {
  final _url = dotenv.get('API_BASE_URL');
  final _httpService = HttpService(baseUrl: dotenv.get('API_BASE_URL'));

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

  Future<dynamic> recoverPassword(Map<String, String> payload) async {
    return await _httpService.post('auth/recover-password', body: payload);
  }

  Future<dynamic> validateRecoverToken(Map<String, String> payload) async {
    return await _httpService.post(
      'auth/validate-recover-token',
      body: payload,
    );
  }

  Future<dynamic> changePassword(Map<String, String> payload) async {
    return await _httpService.post('auth/change-password', body: payload);
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

  Future<dynamic> getSpot(String id, String token) async {
    return await _httpService.get('spot/$id', token: token);
  }

  Future<dynamic> createSpot(
    Map<String, dynamic> payload,
    String token,
  ) async {
    return await _httpService.post('spot', body: payload, token: token);
  }

  Future<dynamic> deleteSpot(String id, String token) async {
    return await _httpService.delete('spot/$id', token: token);
  }

  Future<dynamic> getUserLocations(
    Map<String, String> query,
    String token,
  ) async {
    return await _httpService.get('spot/by-user', token: token, query: query);
  }

  Future<dynamic> attachUserImage(
    List<HttpMultipartFile> files,
    String token,
  ) async {
    return await _httpService.uploadMultipart(
      'resources/attach-to-user',
      files: files,
      token: token,
    );
  }

  Future<dynamic> attachspotImage(
    List<HttpMultipartFile> files,
    Map<String, String> fields,
    String token,
  ) async {
    return await _httpService.uploadMultipart(
      'resources/attach-to-spot',
      files: files,
      token: token,
      fields: fields,
    );
  }

  String getResource(String id, String token) {
    return Uri.https(_url, '/resources/$id', {'token': token}).toString();
  }
}
