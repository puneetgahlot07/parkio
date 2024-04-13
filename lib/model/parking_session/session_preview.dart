class SessionPreviewResponse {
  String? requestSucceed;
  bool? permitAvailable;
  Area? area;
  Vehicle? vehicle;
  PaymentMethod? paymentMethod;
  String? card;

  SessionPreviewResponse({
    this.requestSucceed,
    this.area,
    this.vehicle,
    this.paymentMethod,
    this.card,
  });

  SessionPreviewResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    permitAvailable = json['permit_avalible'];
    area = json['area'] != null ? Area.fromJson(json['area']) : null;
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
    card = json['card'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['permit_avalible'] = permitAvailable;
    if (area != null) {
      data['area'] = area!.toJson();
    }
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod!.toJson();
    }
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
  int? maxTime;
  int? minPrice;

  Area({
    this.id,
    this.code,
    this.name,
    this.address,
    this.type,
    this.parkingCode,
    this.maxTime,
    this.minPrice,
  });

  Area.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    address = json['address'];
    type = json['type'];
    parkingCode = json['parking_code'];
    maxTime = json['maximum_time'];
    minPrice = json['minimum_price'];
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
