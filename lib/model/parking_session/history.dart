class ParkingHistoryResponse {
  String? requestSucceed;
  List<Session>? sessions;
  int? pageSize;
  int? totalEntries;

  ParkingHistoryResponse(
      {this.requestSucceed, this.sessions, this.pageSize, this.totalEntries});

  ParkingHistoryResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    if (json['sessions'] != null) {
      sessions = <Session>[];
      json['sessions'].forEach((v) {
        sessions!.add(Session.fromJson(v));
      });
    }
    pageSize = json['total'];
    totalEntries = json['total_withou_pagination'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    if (sessions != null) {
      data['sessions'] = sessions!.map((v) => v.toJson()).toList();
    }
    data['total'] = pageSize;
    data['total_withou_pagination'] = totalEntries;
    return data;
  }
}

class Session {
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

  Session(
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

  Session.fromJson(Map<String, dynamic> json) {
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
  String? licencePlate;
  String? name;

  Vehicle({this.licencePlate, this.name});

  Vehicle.fromJson(Map<String, dynamic> json) {
    licencePlate = json['licence_plate'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['licence_plate'] = licencePlate;
    data['name'] = name;
    return data;
  }
}

class Area {
  String? address;
  int? code;
  String? name;
  String? type;

  Area({this.address, this.code, this.name, this.type});

  Area.fromJson(Map<String, dynamic> json) {
    address = json['address'];
    code = json['code'];
    name = json['name'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['address'] = address;
    data['code'] = code;
    data['name'] = name;
    data['type'] = type;
    return data;
  }
}
