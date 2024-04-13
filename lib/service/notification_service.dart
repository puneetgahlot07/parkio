import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/error.dart';
import 'package:parkio/util/const.dart';

class NotificationService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var notificationUri = '$baseUrl/notification';

  Future<bool> sendToken(String fcmToken) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.post(
      Uri.parse("$notificationUri/token"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(
        <String, String>{
          'device_type': Platform.isAndroid ? 'android' : 'ios',
          'token': fcmToken,
        },
      ),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
