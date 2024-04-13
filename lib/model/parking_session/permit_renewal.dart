class SetRenewalResponse {
  String? requestSucceed;
  bool? renewal;

  SetRenewalResponse({this.requestSucceed, this.renewal});

  SetRenewalResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    renewal = json['renewal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['renewal'] = renewal;
    return data;
  }
}
