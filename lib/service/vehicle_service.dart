import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/error.dart';
import 'package:parkio/model/vehicles/delete_vehicle.dart';
import 'package:parkio/model/vehicles/get_vehicle.dart';
import 'package:parkio/model/vehicles/set_main_vehicle.dart';
import 'package:parkio/util/const.dart';

import '../model/vehicles/add_vehicle.dart';

class VehicleService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var vehicleUrl = '$baseUrl/vehicle';

  Future<AddVehicleResponse> addVehicle(
    String name,
    String numberPlate,
    bool isMainVehicle,
  ) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.post(
      Uri.parse(vehicleUrl),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'licence_plate': numberPlate,
        'set_main': isMainVehicle,
      }),
    );

    if (response.statusCode == 201) {
      return AddVehicleResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<List<GetVehicleResponse>> getVehicles() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.get(
      Uri.parse('$vehicleUrl/user-list'),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      await Future.delayed(const Duration(seconds: 1)); // TODO: Remove

      return List<GetVehicleResponse>.from(
        data.map((vehicle) => GetVehicleResponse.fromJson(vehicle)),
      );
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<GetVehicleResponse> getVehicle(int id) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.get(
      Uri.parse("$vehicleUrl/$id"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return GetVehicleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<SetMainVehicleResponse> setMainVehicle(int id) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.patch(
      Uri.parse("$vehicleUrl/set-main-vehicle/$id"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      await Future.delayed(const Duration(milliseconds: 300)); // TODO: Remove

      return SetMainVehicleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<DeleteVehicleResponse> removeVehicle(int id) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);
    final response = await http.patch(
      Uri.parse("$vehicleUrl/$id/disable"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      return DeleteVehicleResponse.fromJson(json.decode(response.body));
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
