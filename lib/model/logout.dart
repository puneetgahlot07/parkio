class LogOutResponse {
  String? requestSucceed;
  String? currentToken;

  LogOutResponse({this.requestSucceed, this.currentToken});

  LogOutResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    currentToken = json['current_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['current_token'] = currentToken;
    return data;
  }
}
