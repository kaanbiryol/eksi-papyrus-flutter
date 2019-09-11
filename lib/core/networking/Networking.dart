import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

import 'APIConstants.dart';

enum TYPE { get, post }

class Networking {
  Networking._internal();

  Networking._privateConstructor();

  static final Networking _instance = Networking._privateConstructor();

  static Networking get instance {
    return _instance;
  }

  Future<String> sendRequest(String apiPath,
      {Map<String, String> params = const {}, TYPE type = TYPE.get}) async {
    var requestUri = Uri.https(APIConstants.API_BASE_URL, apiPath, params);
    print("-------------- REQUEST -----------");
    debugPrint(requestUri.toString());
    final response = await get(requestUri);
    // print(response.body);
    if (response.statusCode == 200) {
      print("-------------- RESPONSE -----------");
      debugPrint(response.body.toString());
      return response.body;
    } else {
      print("error");
      //TODO handle errors heres1
      return "";
    }
  }
}
