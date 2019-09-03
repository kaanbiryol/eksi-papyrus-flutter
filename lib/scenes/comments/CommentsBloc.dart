import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/search/networking/models/QueryRequest.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/CommentsResponse.dart';

class CommentsBloc with ChangeNotifier {
  List<Comment> _commentList = [];
  int _currentPage = 0;
  int _pageCount = 1;
  //TODO: set topicurl
  String topicUrl;

  //TODO: move page to backend
  CommentsBloc(this._commentList, this._currentPage) {
    print("CREATED");
  }

  List<Comment> getCommentList() => _commentList;
  int getCurrentPage() => _currentPage;

  bool canPaginate() {
    return _currentPage + 1 <= _pageCount;
  }

  void increaseCurrentPage() {
    if (_currentPage < _pageCount) {
      _currentPage++;
    }
  }

  Future<CommentsResponse> fetchComments(String url, CommentType type) {
    increaseCurrentPage();
    print("Trying to parse" +
        (_currentPage).toString() +
        "totalPages" +
        _pageCount.toString());
    //TODO: why is _currentPage is set to 1?
    return CommentsRequest()
        .getComments(url, type, _currentPage)
        .catchError((onError) {
      print(onError.toString());
    }).then((response) {
      _commentList.addAll(response.comments);
      _currentPage = int.parse(response.page);
      _pageCount = int.parse(response.pageCount);
      notifyListeners();
      return response;
    });
  }

  Future<CommentsResponse> fetchQueryResults(
      String query, CommentType type) async {
    var queryResponse = await QueryRequest().query(query);
    var queryUrl = queryResponse.topicUrl;
    return fetchComments(queryUrl, type);
  }
}
