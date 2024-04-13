class StartParkingResponse {
  String? requestSucceed;
  Session? session;

  StartParkingResponse({this.requestSucceed, this.session});

  StartParkingResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    session =
        json['session'] != null ? Session.fromJson(json['session']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    if (session != null) {
      data['session'] = session!.toJson();
    }
    return data;
  }
}

class Session {
  Vehicle? vehicle;
  PaymentMethod? paymentMethod;
  int? areaCode;
  int? time;
  int? cost;
  String? endTime;
  String? startTime;
  int? id;
  String? sourceSystem;
  String? status;
  String? type;

  Session(
      {this.vehicle,
      this.paymentMethod,
      this.areaCode,
      this.time,
      this.cost,
      this.endTime,
      this.startTime,
      this.id,
      this.sourceSystem,
      this.status,
      this.type});

  Session.fromJson(Map<String, dynamic> json) {
    vehicle =
        json['vehicle'] != null ? Vehicle.fromJson(json['vehicle']) : null;
    paymentMethod = json['payment_method'] != null
        ? PaymentMethod.fromJson(json['payment_method'])
        : null;
    areaCode = json['area_code'];
    time = json['time'];
    cost = json['cost'];
    endTime = json['end_time'];
    startTime = json['start_time'];
    id = json['id'];
    sourceSystem = json['source_system'];
    status = json['status'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (vehicle != null) {
      data['vehicle'] = vehicle!.toJson();
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod!.toJson();
    }
    data['area_code'] = areaCode;
    data['time'] = time;
    data['cost'] = cost;
    data['end_time'] = endTime;
    data['start_time'] = startTime;
    data['id'] = id;
    data['source_system'] = sourceSystem;
    data['status'] = status;
    data['type'] = type;
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

class PaymentMethod {
  int? id;
  String? cardBrand;
  String? maskedPan;
  String? expiryDate;
  String? status;
  String? tokenId;
  String? createdAt;
  String? updatedAt;

  PaymentMethod(
      {this.id,
      this.cardBrand,
      this.maskedPan,
      this.expiryDate,
      this.status,
      this.tokenId,
      this.createdAt,
      this.updatedAt});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cardBrand = json['cardBrand'];
    maskedPan = json['maskedPan'];
    expiryDate = json['expiryDate'];
    status = json['status'];
    tokenId = json['tokenId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['cardBrand'] = cardBrand;
    data['maskedPan'] = maskedPan;
    data['expiryDate'] = expiryDate;
    data['status'] = status;
    data['tokenId'] = tokenId;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
