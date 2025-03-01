class HttpResponseError {
  final int code;
  final String message;
  final List<HttpResponseErrorFiled>? errors;

  HttpResponseError({
    required this.code,
    required this.message,
    this.errors,
  });

  factory HttpResponseError.fromJson(Map<String, dynamic> json) {
    return HttpResponseError(
      code: json['code'],
      message: json['message'],
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
