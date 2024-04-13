class OngoingSessionResponse {
  String? requestSucceed;
  List<Parkings>? parkings;

  OngoingSessionResponse({this.requestSucceed, this.parkings});

  OngoingSessionResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    if (json['parkings'] != null) {
      parkings = <Parkings>[];
      json['parkings'].forEach((v) {
        parkings!.add(Parkings.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    if (parkings != null) {
      data['parkings'] = parkings!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Parkings {
  int? id;
  int? time;
  int? cost;
  String? sourceSystem;
  String? status;
  String? type;
  String? endTime;
  String? startTime;
  Vehicle? vehicle;
  Area? area;

  Parkings(
      {this.id,
      this.time,
      this.cost,
      this.sourceSystem,
      this.status,
      this.type,
      this.endTime,
      this.startTime,
      this.vehicle,
      this.area});

  Parkings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    time = json['time'];
    cost = json['cost'];
    sourceSystem = json['source_system'];
    status = json['status'];
    type = json['type'];
    endTime = json['end_time'];
    startTime = json['start_time'];
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['time'] = time;
    data['cost'] = cost;
    data['source_system'] = sourceSystem;
    data['status'] = status;
    data['type'] = type;
    data['end_time'] = endTime;
    data['start_time'] = startTime;
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (area != null) {
      data['area'] = area!.toJson();
    }
    return data;
  }
}

class Vehicle {
  int? id;
  String? name;
  String? licencePlate;
  String? status;
  String? createdAt;

  Vehicle({this.id, this.name, this.licencePlate, this.status, this.createdAt});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    licencePlate = json['licence_plate'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['licence_plate'] = licencePlate;
    data['status'] = status;
    data['created_at'] = createdAt;
    return data;
  }
}

class Area {
  int? code;
  String? address;
  String? name;

  Area({this.code, this.address, this.name});

  Area.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    address = json['address'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    data['address'] = address;
    data['name'] = name;
    return data;
  }
}
