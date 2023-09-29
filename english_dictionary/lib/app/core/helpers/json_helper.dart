import 'dart:convert';

import 'package:flutter/services.dart';

class JsonHelper {
  JsonHelper._();

  static final instance = JsonHelper._();

  dynamic getData(String path) async {
    var data = await rootBundle.loadString(path);
    return json.decode(data);
  }

  // Future<List<T>> getListFromJson<T>(
  //     {required String assetPath,
  //     required T Function(Map<String, dynamic>) fromMap}) async {
  //   final data = await _getData(assetPath);
  //   List<T> response = [];
  //   for (var data in data['data']) {
  //     response.add(data);
  //   }
  //   return response;
  // }
}
