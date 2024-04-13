class PermitPreviewResponse {
  String? requestSucceed;
  String? card;
  bool? permitAvailable;
  Area? area;
  Vehicle? vehicle;
  List<PermitOption>? possiblePermits;

  PermitPreviewResponse(
      {this.requestSucceed,
      this.permitAvailable,
      this.area,
      this.vehicle,
      this.possiblePermits});

  PermitPreviewResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    card = json['card'];
    permitAvailable = json['permit_avalible'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    if (json['possible_permits'] != null) {
      possiblePermits = <PermitOption>[];
      json['possible_permits'].forEach((v) {
        possiblePermits!.add(PermitOption.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['card'] = card;
    data['permit_avalible'] = permitAvailable;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (possiblePermits != null) {
      data['possible_permits'] =
          possiblePermits!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Area {
  int? id;
  int? code;
  String? name;
  String? address;

  Area({this.id, this.code, this.name, this.address});

  Area.fromJson(Map<String, dynamic> json) {
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

class Vehicle {
  int? id;
  String? licensePlate;
  String? name;

  Vehicle({this.id, this.licensePlate, this.name});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    licensePlate = json['licence_plate'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['licence_plate'] = licensePlate;
    data['name'] = name;
    return data;
  }
}

class PermitOption {
  int? id;
  int? duration;
  int? price;

  PermitOption({this.id, this.duration, this.price});

  PermitOption.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    duration = json['duration'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['duration'] = duration;
    data['price'] = price;
    return data;
  }
}
