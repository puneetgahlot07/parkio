class SetReminderResponse {
  String? requestSucceed;
  bool? receiveReminder;

  SetReminderResponse({this.requestSucceed, this.receiveReminder});

  SetReminderResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    receiveReminder = json['recieve_reminder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    data['recieve_reminder'] = receiveReminder;
    return data;
  }
}
