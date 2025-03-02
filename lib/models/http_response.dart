class HttpResponse {
  final int code;
  final String message;
  final dynamic response;
  final List<HttpResponseErrorFiled>? errors;

  HttpResponse({
    required this.code,
    required this.message,
    this.errors,
    this.response,
  });

  factory HttpResponse.fromJson(Map<String, dynamic> json) {
    return HttpResponse(
      code: json['code'],
      message: json['message'],
      response: json['response'],
      errors: json['erros']
          ?.map((error) => HttpResponseErrorFiled.fromJson(error))
          ?.toList(),
    );
  }
}

class HttpResponseErrorFiled {
  final String field;
  final String message;

  HttpResponseErrorFiled({
    required this.field,
    required this.message,
  });

  factory HttpResponseErrorFiled.fromJson(Map<String, dynamic> json) {
    return HttpResponseErrorFiled(
      field: json['field'],
      message: json['message'],
    );
  }
}
