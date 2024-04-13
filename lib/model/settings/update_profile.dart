import 'package:parkio/model/settings/get_profile.dart';

class UpdateProfileResponse {
  String? requestSucceed;
  Profile? user;

  UpdateProfileResponse({this.requestSucceed, this.user});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    requestSucceed = json['request_succeed'];
    user = json['user'] != null ? Profile.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['request_succeed'] = requestSucceed;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}
