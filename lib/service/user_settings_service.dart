import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/error.dart';
import 'package:parkio/model/settings/change_sensitive_data.dart';
import 'package:parkio/model/settings/get_profile.dart';
import 'package:parkio/model/settings/verify_update.dart';
import 'package:parkio/util/const.dart';

import '../model/settings/delete_profile.dart';
import '../model/settings/update_profile.dart';

class UserSettingsService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var profileUrl = '$baseUrl/get-profile';
  var settingsUrl = '$baseUrl/settings';

  Future<Profile> getProfile() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.get(
      Uri.parse(profileUrl),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return Profile.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<UpdateProfileResponse> updateProfile(
    String firstName,
    String lastName,
    String address,
    String postalCode,
    String city,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.patch(
      Uri.parse('$settingsUrl/update-profile'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "first_name": firstName,
        "second_name": lastName,
        'residence_place': {
          "street_address": address,
          "post_code": postalCode.isNotEmpty ? int.parse(postalCode) : null,
          "suburb": city,
        },
      }),
    );

    if (response.statusCode == 200) {
      UpdateProfileResponse updateProfileResponse =
          UpdateProfileResponse.fromJson(jsonDecode(response.body));
      return updateProfileResponse;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<UpdateProfileResponse> updateNotification(
    int activeSessionInterval,
    int endingSessionInterval,
    bool activeSessionNotification,
    bool endingSessionNotification,
    bool endOfSessionNotification,
    bool receiveReceipt,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.patch(
      Uri.parse('$settingsUrl/update-profile'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "active_session_interval": activeSessionInterval,
        "ending_session_interval": endingSessionInterval,
        "active_session_notification": activeSessionNotification,
        "ending_session_notification": endingSessionNotification,
        "end_of_session_notification": endOfSessionNotification,
        "receive_receipt": receiveReceipt,
      }),
    );

    if (response.statusCode == 200) {
      UpdateProfileResponse updateProfileResponse =
          UpdateProfileResponse.fromJson(jsonDecode(response.body));
      return updateProfileResponse;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<DeleteProfileResponse> deleteProfile() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.delete(
      Uri.parse('$settingsUrl/delete-profile'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      DeleteProfileResponse updateProfileResponse =
          DeleteProfileResponse.fromJson(jsonDecode(response.body));
      if (updateProfileResponse.requestSucceed == "true") {
        await storage.delete(key: StorageKey.accessToken.value);
      }
      return updateProfileResponse;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<ChangeProfileDataResponse> changePassword(String password) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.post(
      Uri.parse('$settingsUrl/change-password'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      return ChangeProfileDataResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<ChangeProfileDataResponse> changeEmail(String email) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.post(
      Uri.parse('$settingsUrl/change-email'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
      }),
    );

    if (response.statusCode == 201) {
      return ChangeProfileDataResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<ChangeProfileDataResponse> changePhoneNumber(
      String phoneNumber) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.post(
      Uri.parse('$settingsUrl/change-phone'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "phoneNumber": phoneNumber,
      }),
    );

    if (response.statusCode == 201) {
      return ChangeProfileDataResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<VerifyUpdateResponse> verifyUpdate(
    String token,
    String code,
    String type,
  ) async {
    final response = await http.patch(
      Uri.parse('$settingsUrl/verify-update'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        "code": code,
        "type": type,
      }),
    );

    if (response.statusCode == 200) {
      return VerifyUpdateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
