class SetMainVehicleResponse {
  String? requestSucceed;
  int? mainVehicle;

  SetMainVehicleResponse({this.requestSucceed, this.mainVehicle});

  SetMainVehicleResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    mainVehicle = json['main_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['main_vehicle'] = mainVehicle;
    return data;
  }
}
