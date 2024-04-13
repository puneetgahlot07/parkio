import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/error.dart';
import 'package:parkio/model/parking_session/bonus_counter.dart';
import 'package:parkio/model/parking_session/ongoing_permits.dart';
import 'package:parkio/model/parking_session/ongoing_session_preview.dart';
import 'package:parkio/model/parking_session/session_cost.dart';
import 'package:parkio/model/parking_session/set_reminder.dart';
import 'package:parkio/model/parking_session/start_parking.dart';
import 'package:parkio/util/const.dart';

import '../model/parking_session/history.dart';
import '../model/parking_session/ongoing.dart';
import '../model/parking_session/permit_preview.dart';
import '../model/parking_session/permit_renewal.dart';
import '../model/parking_session/session_preview.dart';

class ParkingService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var parkingSessionUrl = '$baseUrl/parking-session';

  Future<StartParkingResponse> startParkingSession(
    int duration,
    int vehicleId,
    int areaId,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.post(
      Uri.parse(parkingSessionUrl),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, int>{
        'time': duration,
        'vehicleId': vehicleId,
        'areaId': areaId,
      }),
    );

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      await Future.delayed(const Duration(milliseconds: 1000)); // TODO: Remove

      return StartParkingResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<bool> buyPermit(
    int paymentId,
    int vehicleId,
    int permitId,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.post(
      Uri.parse("$parkingSessionUrl/create-permit"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, int>{
        'permit_id': permitId,
        'payment_id': paymentId,
        'vehicle_id': vehicleId,
      }),
    );

    if (response.statusCode == 201) {
      await Future.delayed(const Duration(milliseconds: 1000)); // TODO: Remove

      return true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<bool> stopParkingSession(int sessionId) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.patch(
      Uri.parse("$parkingSessionUrl/$sessionId/stop"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500)); // TODO: Remove

      return true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<bool> extendParkingSession(int sessionId, int seconds) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.patch(
      Uri.parse("$parkingSessionUrl/update-time"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, int>{
        'sessionId': sessionId,
        'time': seconds,
      }),
    );

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 500)); // TODO: Remove

      return true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<GetBonusCounterResponse> getBonusCounter() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/bonus-counter"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return GetBonusCounterResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<SetReminderResponse> setBonusReminder(bool isEnabled) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.patch(
      Uri.parse("$parkingSessionUrl/bonus-reminder"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, bool>{
        "recieve_reminder": isEnabled,
      }),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      await Future.delayed(const Duration(milliseconds: 650)); // TODO: Remove

      return SetReminderResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<SessionPreviewResponse> getSessionPreview(int areaId) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/session-preview?seconds=0&areaId=$areaId"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return SessionPreviewResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<OngoingSessionPreviewResponse> getOngoingSessionPreview(
    int sessionId,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/$sessionId/ongoing-session-preview"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return OngoingSessionPreviewResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<PermitPreviewResponse> getPermitPreview(int areaId) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/permit-preview?&areaId=$areaId"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return PermitPreviewResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<bool> setPermitRenewal(int permitId) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.patch(
      Uri.parse("$parkingSessionUrl/$permitId/update-renewal"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // Return the new renewal status
      return SetRenewalResponse.fromJson(data).renewal == true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<SessionCostResponse> getSessionCost(
    int areaId,
    int duration,
    int vehicleId,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse(
          "$parkingSessionUrl/session-cost?seconds=$duration&areaId=$areaId&vehicleId=$vehicleId"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      await Future.delayed(const Duration(milliseconds: 150)); // TODO: Remove

      return SessionCostResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<OngoingSessionResponse> getOngoingSessions() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/ongoing"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return OngoingSessionResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<List<OngoingPermitResponse>> getOngoingPermits() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/ongoing-permits"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return List<OngoingPermitResponse>.from(
        data.map((vehicle) => OngoingPermitResponse.fromJson(vehicle)),
      );
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<ParkingHistoryResponse> getParkingHistoryPage(int page) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$parkingSessionUrl/history?page=$page&limit=5"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return ParkingHistoryResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
