class OngoingSessionPreviewResponse {
  String? requestSucceed;
  Area? area;
  Vehicle? vehicle;
  PaymentMethod? paymentMethod;
  int? duration;
  String? startTime;
  String? card;

  OngoingSessionPreviewResponse(
      {this.requestSucceed,
      this.area,
      this.vehicle,
      this.paymentMethod,
      this.duration,
      this.startTime});

  OngoingSessionPreviewResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
    duration = json['duration'];
    startTime = json['startTime'];
    card = json['card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod!.toJson();
    }
    data['duration'] = duration;
    data['startTime'] = startTime;
    data['card'] = card;
    return data;
  }
}

class Area {
  int? id;
  int? code;
  String? name;
  String? address;
  String? type;
  String? parkingCode;

  Area(
      {this.id,
      this.code,
      this.name,
      this.address,
      this.type,
      this.parkingCode});

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    address = json['address'];
    type = json['type'];
    parkingCode = json['parking_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['address'] = address;
    data['type'] = type;
    data['parking_code'] = parkingCode;
    return data;
  }
}

class Vehicle {
  int? id;
  String? licencePlate;
  String? name;

  Vehicle({this.id, this.licencePlate, this.name});

  Vehicle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    licencePlate = json['licence_plate'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['licence_plate'] = licencePlate;
    data['name'] = name;
    return data;
  }
}

class PaymentMethod {
  int? id;
  String? cardBrand;
  String? maskedPan;

  PaymentMethod({this.id, this.cardBrand, this.maskedPan});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardBrand = json['cardBrand'];
    maskedPan = json['maskedPan'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cardBrand'] = cardBrand;
    data['maskedPan'] = maskedPan;
    return data;
  }
}
