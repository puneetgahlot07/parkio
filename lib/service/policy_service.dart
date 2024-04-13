import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:parkio/model/error.dart';
import 'package:parkio/model/text.dart';
import 'package:parkio/util/const.dart';

class PolicyService {
  var client = http.Client();
  var policyUrl = '$baseUrl/policy';

  Future<String> getPolicyText(String address) async {
    final response = await http.get(
      Uri.parse("$policyUrl/$address"),
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);

      return TextResponse.fromJson(data).result ?? '';
    } else {
      throw Exception(
        ErrorResponse.fromJson(jsonDecode(response.body)).message?.first,
      );
    }
  }
}
