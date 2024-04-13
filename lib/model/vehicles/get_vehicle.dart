class GetVehicleResponse {
  int? id;
  String? name;
  String? licencePlate;
  bool? mainVehicle;

  GetVehicleResponse({this.id, this.name, this.licencePlate});

  GetVehicleResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licencePlate = json['licence_plate'];
    mainVehicle = json['main_vehicle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['licence_plate'] = licencePlate;
    data['main_vehicle'] = mainVehicle;
    return data;
  }
}
