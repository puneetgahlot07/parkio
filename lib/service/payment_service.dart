import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/url.dart';
import 'package:parkio/util/const.dart';

import '../model/error.dart';
import '../model/payment/payment_card.dart';

class PaymentService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var paymentUrl = '$baseUrl/payment';

  Future<List<PaymentCard>> getPaymentMethods() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse('$paymentUrl/cards'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return List<PaymentCard>.from(
        data.map((vehicle) => PaymentCard.fromJson(vehicle)),
      );
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<String?> getVerificationPaymentUri() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.post(
      Uri.parse('$paymentUrl/verification'),
      headers: <String, String>{
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 201) {
      var data = json.decode(response.body);

      return UrlResponse.fromJson(data).url;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<bool> setMainPaymentMethod(String cardToken) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.patch(
      Uri.parse("$paymentUrl/cards/$cardToken/set-main"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<bool> deletePaymentMethod(String cardToken) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.delete(
      Uri.parse("$paymentUrl/cards/$cardToken"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
