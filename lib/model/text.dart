class TextResponse {
  String? requestSucceed;
  String? result;

  TextResponse({this.requestSucceed, this.result});

  TextResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    result = json['result'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['result'] = result;
    return data;
  }
}
