import 'dart:convert';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:parkio/model/area/get_areas.dart';
import 'package:parkio/model/area/search_area.dart';
import 'package:parkio/model/error.dart';
import 'package:parkio/util/const.dart';

import '../model/area/get_area.dart';

class AreaService {
  final storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  var client = http.Client();
  var areaUrl = '$baseUrl/area';

  Future<GetAreaResponse> getArea(int id) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse("$areaUrl/$id"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // TODO: Remove artificial delay
      await Future.delayed(const Duration(milliseconds: 750));

      return GetAreaResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<List<Area>> getAreas() async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    final response = await http.get(
      Uri.parse(areaUrl),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      // TODO: Remove artificial delay
      await Future.delayed(const Duration(milliseconds: 750));

      return List<Area>.from(
        data.map((area) => Area.fromJson(area)),
      );
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }

  Future<SearchAreaResponse> searchAreas(String query) async {
    String? token = await storage.read(key: StorageKey.accessToken.value);

    // TODO: Remove artificial delay
    await Future.delayed(const Duration(milliseconds: 300));

    final response = await http.get(
      Uri.parse("$areaUrl?search=$query"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: 'Bearer $token'
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return SearchAreaResponse.fromJson(data);
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
