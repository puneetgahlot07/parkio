class VerifyUpdateResponse {
  String? requestSucceed;

  VerifyUpdateResponse({this.requestSucceed});

  VerifyUpdateResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    return data;
  }
}
