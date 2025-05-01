class ValidateToken {
  final bool isValid;

  ValidateToken({
    required this.isValid,
  });

  factory ValidateToken.fromJson(Map<String, dynamic> json) {
    return ValidateToken(
      isValid: json['isValid'],
    );
  }
}
