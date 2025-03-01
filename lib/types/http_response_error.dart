class HttpResponseError {
  final int code;
  final String message;
  final List<HttpResponseErrorFiled>? errors;

  HttpResponseError({
    required this.code,
    required this.message,
    this.errors,
  });
}

class HttpResponseErrorFiled {
  final String field;
  final String message;

  HttpResponseErrorFiled({
    required this.field,
    required this.message,
  });
}
