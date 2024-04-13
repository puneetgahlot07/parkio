class SessionCostResponse {
  String? requestSucceed;
  int? cost;

  SessionCostResponse({this.requestSucceed, this.cost});

  SessionCostResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    cost = json['cost'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['cost'] = cost;
    return data;
  }
}
