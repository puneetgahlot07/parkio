class DeleteVehicleResponse {
  String? requestSucceed;

  DeleteVehicleResponse({this.requestSucceed});

  DeleteVehicleResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    return data;
  }
}
