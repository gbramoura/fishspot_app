import 'package:fishspot_app/models/http_response_error.dart';

class HttpResponseException implements Exception {
  final HttpResponseError data;

  HttpResponseException({required this.data});

  @override
  String toString() {
    return 'HttpResponseException: ${data.message}, StatusCode: ${data.code}';
  }
}
