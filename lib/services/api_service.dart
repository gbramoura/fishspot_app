import 'http_service.dart';

class ApiService {
  final httpService = HttpService(baseUrl: 'http://10.0.2.2:5010');

  Future<dynamic> register(Map<String, dynamic> payload) async {
    return await httpService.post('auth/register', body: payload);
  }

  Future<dynamic> login(Map<String, dynamic> payload) async {
    return await httpService.post('auth/login', body: payload);
  }

  Future<dynamic> refreshToken(Map<String, dynamic> payload) async {
    return await httpService.post('auth/refresh-token', body: payload);
  }

  Future<dynamic> isAuth(String token) async {
    return await httpService.post('auth/is-auth', body: {}, token: token);
  }

  Future<dynamic> getUser(String token) async {
    return await httpService.get('user', token: token);
  }

  Future<dynamic> updateUser(Map<String, dynamic> payload, String token) async {
    return await httpService.put('user', body: payload, token: token);
  }

  Future<dynamic> getImage(String id, String token) async {
    return await httpService.get('resources/$id', token: token);
  }
}
