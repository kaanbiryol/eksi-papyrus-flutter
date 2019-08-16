import 'package:eksi_papyrus/scenes/search/SearchRequest.dart';
import 'package:eksi_papyrus/scenes/search/models/SearchResult.dart';
import 'package:flutter/foundation.dart';

class SearchResultNotifier with ChangeNotifier {
  List<String> _resultList = [];

  SearchResultNotifier(this._resultList) {
    print("CREATED");
  }

  List<String> getResults() => _resultList;

  Future<SearchQueryResponse> queryResults(String query) {
    return SearchQueryRequest().searchQuery(query).then((response) {
      notifyListeners();
      return response;
    });
  }
}
