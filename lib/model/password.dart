class UpdatePasswordResponse {
  String? requestSucceed;

  UpdatePasswordResponse({this.requestSucceed});

  UpdatePasswordResponse.fromJson(Map<String, dynamic> json)
      : requestSucceed = json['request_succeed'];

  Map<String, dynamic> toJson() => {'request_succeed': requestSucceed};
}
