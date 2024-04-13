import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/auth.dart';
import 'package:parkio/model/error.dart';
import 'package:parkio/model/logout.dart';
import 'package:parkio/model/refresh_token.dart';
import 'package:parkio/model/verification.dart';
import 'package:parkio/util/const.dart';

import '../model/password.dart';

class AuthService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var authUrl = '$baseUrl/auth';

  Future<AuthResponse> registerWithEmail(String email, String password) async {
    final response = await http.post(
      Uri.parse('$authUrl/register'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<AuthResponse> registerWithPhone(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$authUrl/register'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<AuthResponse> logInWithEmail(String email, String password) async {
    final response = await http.post(
      Uri.parse('$authUrl/login'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      final e = Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?[0],
      );
      throw e;
    }
  }

  Future<AuthResponse> logInWithPhone(String phone, String password) async {
    final response = await http.post(
      Uri.parse('$authUrl/login'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone': phone,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<LogOutResponse> logOut() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.patch(
      Uri.parse('$authUrl/logout'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      await storage.delete(key: StorageKey.accessToken.value);
      return LogOutResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<AuthResponse> resetPasswordWithEmail(String email) async {
    final response = await http.post(
      Uri.parse('$authUrl/forget-password'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<AuthResponse> resetPasswordWithPhone(String phone) async {
    final response = await http.post(
      Uri.parse('$authUrl/forget-password'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'phone': phone}),
    );

    if (response.statusCode == 201) {
      return AuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<UpdatePasswordResponse> updatePassword(String password) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.patch(
      Uri.parse('$authUrl/settings/update-password'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, String>{'password': password}),
    );

    if (response.statusCode == 200) {
      return UpdatePasswordResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<VerificationResponse> verify(
      String token, String code, String sessionType) async {
    final response = await http.patch(
      Uri.parse('$authUrl/verification'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
      body: jsonEncode(<String, String>{
        'code': code,
        'type': sessionType,
      }),
    );

    if (response.statusCode == 200) {
      return VerificationResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<RefreshTokenResponse> refreshToken() async {
    String? token = await storage.read(key: StorageKey.refreshToken.value);

    final response = await http.patch(
      Uri.parse('$authUrl/refresh'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return RefreshTokenResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
