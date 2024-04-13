class GetBonusCounterResponse {
  String? requestSucceed;
  int? bonusCounterCurrent;
  int? bonusCounterMax;
  int? bonusDiscount;
  bool? enabled;

  GetBonusCounterResponse(
      {this.requestSucceed,
      this.bonusCounterCurrent,
      this.bonusCounterMax,
      this.bonusDiscount,
      this.enabled});

  GetBonusCounterResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    bonusCounterCurrent = json['bonus_counter_current'];
    bonusCounterMax = json['bonus_counter_max'];
    bonusDiscount = json['bonus_discount'];
    enabled = json['enabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['bonus_counter_current'] = bonusCounterCurrent;
    data['bonus_counter_max'] = bonusCounterMax;
    data['bonus_discount'] = bonusDiscount;
    data['enabled'] = enabled;
    return data;
  }
}
