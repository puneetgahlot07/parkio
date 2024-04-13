class Profile {
  int? id;
  String? firstName;
  String? secondName;
  String? fullName;
  String? email;
  String? phone;
  ResidencePlace? residencePlace;
  NotificationsSettings? notificationsSettings;

  Profile({
    this.id,
    this.firstName,
    this.secondName,
    this.fullName,
    this.email,
    this.phone,
    this.residencePlace,
    this.notificationsSettings,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    secondName = json['second_name'];
    fullName = json['full_name'];
    email = json['email'];
    phone = json['phone'];
    residencePlace = json['residence_place'] != null
        ? ResidencePlace.fromJson(json['residence_place'])
        : null;
    notificationsSettings = json['notifications_settings'] != null
        ? NotificationsSettings.fromJson(json['notifications_settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['second_name'] = secondName;
    data['full_name'] = fullName;
    data['email'] = email;
    data['phone'] = phone;
    if (residencePlace != null) {
      data['residence_place'] = residencePlace!.toJson();
    }
    if (notificationsSettings != null) {
      data['notifications_settings'] = notificationsSettings!.toJson();
    }
    return data;
  }
}

class ResidencePlace {
  String? suburb;
  int? postCode;
  String? streetAddress;

  ResidencePlace({this.suburb, this.postCode, this.streetAddress});

  ResidencePlace.fromJson(Map<String, dynamic> json) {
    suburb = json['suburb'];
    postCode = json['post_code'];
    streetAddress = json['street_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['suburb'] = suburb;
    data['post_code'] = postCode;
    data['street_address'] = streetAddress;
    return data;
  }
}

class NotificationsSettings {
  bool? receiveReceipt;
  bool? receiveReminder;
  int? activeSessionInterval;
  int? endingSessionInterval;
  bool? activeSessionNotification;
  bool? endOfSessionNotification;
  bool? endingSessionNotification;

  NotificationsSettings(
      {this.receiveReceipt,
      this.receiveReminder,
      this.activeSessionInterval,
      this.endingSessionInterval,
      this.activeSessionNotification,
      this.endOfSessionNotification,
      this.endingSessionNotification});

  NotificationsSettings.fromJson(Map<String, dynamic> json) {
    receiveReceipt = json['receive_receipt'];
    receiveReminder = json['recieve_reminder'];
    activeSessionInterval = json['active_session_interval'];
    endingSessionInterval = json['ending_session_interval'];
    activeSessionNotification = json['active_session_notification'];
    endOfSessionNotification = json['end_of_session_notification'];
    endingSessionNotification = json['ending_session_notification'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['receive_receipt'] = receiveReceipt;
    data['recieve_reminder'] = receiveReminder;
    data['active_session_interval'] = activeSessionInterval;
    data['ending_session_interval'] = endingSessionInterval;
    data['active_session_notification'] = activeSessionNotification;
    data['end_of_session_notification'] = endOfSessionNotification;
    data['ending_session_notification'] = endingSessionNotification;
    return data;
  }
}
