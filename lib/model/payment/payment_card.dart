class PaymentCard {
  String? card;
  String? token;
  bool? main;

  PaymentCard({this.card, this.token, this.main});

  PaymentCard.fromJson(Map<String, dynamic> json) {
    card = json['card'];
    token = json['token'];
    main = json['main'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['card'] = card;
    data['token'] = token;
    data['main'] = main;
    return data;
  }
}
