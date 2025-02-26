import 'http_service.dart';

class ApiService {
  final httpService = HttpService(baseUrl: 'http://10.0.2.2:5010');

  Future<dynamic> registerUser(Map<String, dynamic> payload) async {
    return await httpService.post('auth/register', body: payload);
  }
}
