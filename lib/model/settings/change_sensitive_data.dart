class ChangeProfileDataResponse {
  String? requestSucceed;
  String? verificationToken;
  String? target;

  ChangeProfileDataResponse(
      {this.requestSucceed, this.verificationToken, this.target});

  ChangeProfileDataResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    verificationToken = json['verification_token'];
    target = json['target'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['verification_token'] = verificationToken;
    data['target'] = target;
    return data;
  }
}
