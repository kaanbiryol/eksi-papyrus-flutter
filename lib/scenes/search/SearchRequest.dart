import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'package:eksi_papyrus/scenes/search/models/SearchResult.dart';

class SearchQueryRequest {
  final Networking networkManager = Networking.instance;

  Future<SearchQueryResponse> searchQuery(String query) {
    return networkManager.sendRequest(APIConstants.API_SEARCH,
        params: {'query': query}).then((dynamic response) {
      return SearchQueryResponse.fromJson(json.decode(response));
    });
  }
}
