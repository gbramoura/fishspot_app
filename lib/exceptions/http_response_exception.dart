import 'package:fishspot_app/models/http_response.dart';

class HttpResponseException implements Exception {
  final HttpResponse data;

  HttpResponseException({required this.data});

  @override
  String toString() {
    return 'HttpResponseException: ${data.message}, StatusCode: ${data.code}';
  }
}
