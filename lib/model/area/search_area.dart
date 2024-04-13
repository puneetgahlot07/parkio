class SearchAreaResponse {
  List<ParkingArea>? parkingAreas;
  List<ParkingArea>? addresses;

  SearchAreaResponse({this.parkingAreas, this.addresses});

  SearchAreaResponse.fromJson(Map<String, dynamic> json) {
    if (json['parking_areas'] != null) {
      parkingAreas = <ParkingArea>[];
      json['parking_areas'].forEach((v) {
        parkingAreas!.add(ParkingArea.fromJson(v));
      });
    }
    if (json['addresses'] != null) {
      addresses = <ParkingArea>[];
      json['addresses'].forEach((v) {
        addresses!.add(ParkingArea.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (parkingAreas != null) {
      data['parking_areas'] = parkingAreas!.map((v) => v.toJson()).toList();
    }
    if (addresses != null) {
      data['addresses'] = addresses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ParkingArea {
  int? id;
  int? code;
  String? name;
  String? address;

  ParkingArea({this.id, this.code, this.name, this.address});

  ParkingArea.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['address'] = address;
    return data;
  }
}
