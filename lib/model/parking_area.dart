class ParkingAreaResponse {
  String? index;
  String? address;
  String? description;

  ParkingAreaResponse({this.index, this.address, this.description});

  ParkingAreaResponse.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    address = json['address'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['index'] = index;
    data['address'] = address;
    data['description'] = description;
    return data;
  }
}
