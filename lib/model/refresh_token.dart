class RefreshTokenResponse {
  String? requestSucceed;
  Tokens? tokens;

  RefreshTokenResponse({this.requestSucceed, this.tokens});

  RefreshTokenResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    tokens = json['tokens'] != null ? Tokens.fromJson(json['tokens']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    if (tokens != null) {
      data['tokens'] = tokens!.toJson();
    }
    return data;
  }
}

class Tokens {
  String? accessToken;
  String? refreshToken;

  Tokens({this.accessToken, this.refreshToken});

  Tokens.fromJson(Map<String, dynamic> json) {
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
