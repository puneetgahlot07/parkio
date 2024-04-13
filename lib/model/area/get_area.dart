class GetAreaResponse {
  int? id;
  int? code;
  String? name;
  int? revenue;
  int? occupancy;
  int? defaultCapacity;
  int? publicPermitCapacity;
  int? businessPermitCapacity;
  String? address;
  bool? bonusAccumulation;
  int? bonusAccumulationCost;
  int? minimumPrice;
  int? maximumPrice;
  int? maximumTime;
  String? type;
  String? parkingCode;
  String? city;
  String? company;
  String? infoMessage;
  String? description;
  List<Coordinates>? coordinates;
  String? createdAt;
  TimeSplit? timeSplit;

  GetAreaResponse(
      {this.id,
      this.code,
      this.name,
      this.revenue,
      this.occupancy,
      this.defaultCapacity,
      this.publicPermitCapacity,
      this.businessPermitCapacity,
      this.address,
      this.bonusAccumulation,
      this.bonusAccumulationCost,
      this.minimumPrice,
      this.maximumPrice,
      this.maximumTime,
      this.type,
      this.parkingCode,
      this.city,
      this.company,
      this.infoMessage,
      this.description,
      this.coordinates,
      this.createdAt,
      this.timeSplit});

  GetAreaResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    name = json['name'];
    revenue = json['revenue'];
    occupancy = json['occupancy'];
    defaultCapacity = json['default_capacity'];
    publicPermitCapacity = json['public_permit_capacity'];
    businessPermitCapacity = json['business_permit_capacity'];
    address = json['address'];
    bonusAccumulation = json['bonus_accumulation'];
    bonusAccumulationCost = json['bonus_accumulation_cost'];
    minimumPrice = json['minimum_price'];
    maximumPrice = json['maximum_price'];
    maximumTime = json['maximum_time'];
    type = json['type'];
    parkingCode = json['parking_code'];
    city = json['city'];
    company = json['company'];
    infoMessage = json['info_message'];
    description = json['desctiption'];
    if (json['coordinates'] != null) {
      coordinates = <Coordinates>[];
      json['coordinates'].forEach((v) {
        coordinates!.add(Coordinates.fromJson(v));
      });
    }
    createdAt = json['created_at'];
    timeSplit = json['time_split'] != null
        ? TimeSplit.fromJson(json['time_split'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['name'] = name;
    data['revenue'] = revenue;
    data['occupancy'] = occupancy;
    data['default_capacity'] = defaultCapacity;
    data['public_permit_capacity'] = publicPermitCapacity;
    data['business_permit_capacity'] = businessPermitCapacity;
    data['address'] = address;
    data['bonus_accumulation'] = bonusAccumulation;
    data['bonus_accumulation_cost'] = bonusAccumulationCost;
    data['minimum_price'] = minimumPrice;
    data['maximum_price'] = maximumPrice;
    data['maximum_time'] = maximumTime;
    data['type'] = type;
    data['parking_code'] = parkingCode;
    data['city'] = city;
    data['company'] = company;
    data['info_message'] = infoMessage;
    data['desctiption'] = description;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;
    if (timeSplit != null) {
      data['time_split'] = timeSplit!.toJson();
    }
    return data;
  }
}

class Coordinates {
  String? latitude;
  String? longitude;

  Coordinates({this.latitude, this.longitude});

  Coordinates.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    return data;
  }
}

class TimeSplit {
  int? id;
  List<Splits>? splits;
  int? defaultPrice;

  TimeSplit({this.id, this.splits, this.defaultPrice});

  TimeSplit.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['splits'] != null) {
      splits = <Splits>[];
      json['splits'].forEach((v) {
        splits!.add(Splits.fromJson(v));
      });
    }
    defaultPrice = json['default_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    if (splits != null) {
      data['splits'] = splits!.map((v) => v.toJson()).toList();
    }
    data['default_price'] = defaultPrice;
    return data;
  }
}

class Splits {
  int? price;
  int? endHour;
  int? startHour;
  List<int>? daysOfWeek;

  Splits({this.price, this.endHour, this.startHour, this.daysOfWeek});

  Splits.fromJson(Map<String, dynamic> json) {
    price = json['price'];
    endHour = json['end_hour'];
    startHour = json['start_hour'];
    daysOfWeek = json['days_of_week'].cast<int>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['end_hour'] = endHour;
    data['start_hour'] = startHour;
    data['days_of_week'] = daysOfWeek;
    return data;
  }
}
