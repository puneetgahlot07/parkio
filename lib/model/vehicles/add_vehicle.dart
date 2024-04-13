class AddVehicleResponse {
  String? name;
  String? numberPlate;
  int? id;

  AddVehicleResponse({this.name, this.numberPlate, this.id});

  AddVehicleResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    numberPlate = json['licence_plate'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['licence_plate'] = numberPlate;
    data['id'] = id;
    return data;
  }
}
