import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'SearchResponse.dart';

class SearchQueryRequest {
  final Networking networkManager = Networking.instance;

  Future<SearchResponse> searchQuery(String query) {
    return networkManager.sendRequest(APIConstants.API_SEARCH,
        params: {'query': query}).then((dynamic response) {
      return SearchResponse.fromJson(json.decode(response));
    });
  }
}
