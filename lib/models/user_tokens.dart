class UserTokens {
  final String token;
  final String refreshToken;

  UserTokens({
    required this.token,
    required this.refreshToken,
  });

  factory UserTokens.fromJson(Map<String, dynamic> json) {
    return UserTokens(
      token: json['token'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
    };
  }
}
