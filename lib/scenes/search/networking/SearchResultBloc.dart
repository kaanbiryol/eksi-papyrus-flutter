import 'package:flutter/foundation.dart';
import 'models/SearchRequest.dart';
import 'models/SearchResponse.dart';

class SearchResultBloc with ChangeNotifier {
  List<String> _resultList = [];

  SearchResultBloc(this._resultList) {
    print("CREATED");
  }

  List<String> getResults() => _resultList;

  Future<SearchResponse> queryResults(String query) {
    return SearchQueryRequest().searchQuery(query).then((response) {
      notifyListeners();
      return response;
    });
  }
}
