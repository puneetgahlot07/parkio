class VerificationResponse {
  String? requestSucceed;
  bool? userVerified;
  AuthTokens? authTokens;

  VerificationResponse(
      {this.requestSucceed, this.userVerified, this.authTokens});

  VerificationResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    userVerified = json['user_verified'];
    authTokens = json['auth_tokens'] != null
        ? AuthTokens.fromJson(json['auth_tokens'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['user_verified'] = userVerified;
    if (authTokens != null) {
      data['auth_tokens'] = authTokens!.toJson();
    }
    return data;
  }
}

class AuthTokens {
  String? accessToken;
  String? refreshToken;

  AuthTokens({this.accessToken, this.refreshToken});

  AuthTokens.fromJson(Map<String, dynamic> json) {
    accessToken = json['access_token'];
    refreshToken = json['refresh_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['access_token'] = accessToken;
    data['refresh_token'] = refreshToken;
    return data;
  }
}
