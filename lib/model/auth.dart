class AuthResponse {
  String? requestSucceed;
  String? verificationToken;

  AuthResponse({this.requestSucceed, this.verificationToken});

  AuthResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    verificationToken = json['verification_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['verification_token'] = verificationToken;
    return data;
  }
}
