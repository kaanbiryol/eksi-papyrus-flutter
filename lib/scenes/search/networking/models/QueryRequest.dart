import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'package:eksi_papyrus/scenes/search/networking/models/QueryResponse.dart';

class QueryRequest {
  final Networking networkManager = Networking.instance;

  Future<QueryResponse> query(String query) {
    return networkManager.sendRequest(APIConstants.API_QUERY,
        params: {'q': query}).then((dynamic response) {
      return QueryResponse.fromJson(json.decode(response));
    });
  }
}
