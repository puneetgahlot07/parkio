class DeleteProfileResponse {
  String? requestSucceed;

  DeleteProfileResponse({this.requestSucceed});

  DeleteProfileResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    return data;
  }
}
