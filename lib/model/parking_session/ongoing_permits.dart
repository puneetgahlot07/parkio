class OngoingPermitResponse {
  int? id;
  String? from;
  String? endDate;
  int? monthlyRate;
  bool? renewal;

  OngoingPermitResponse(
      {this.id, this.from, this.endDate, this.monthlyRate, this.renewal});

  OngoingPermitResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    from = json['from'];
    endDate = json['end_date'];
    monthlyRate = json['monthly_rate'];
    renewal = json['renewal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['from'] = from;
    data['end_date'] = endDate;
    data['monthly_rate'] = monthlyRate;
    data['renewal'] = renewal;
    return data;
  }
}
