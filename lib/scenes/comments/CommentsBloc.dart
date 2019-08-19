import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/search/networking/models/QueryRequest.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/CommentsResponse.dart';

class CommentsBloc with ChangeNotifier {
  List<Comment> _commentList = [];
  int _currentPage = 1;

  //TODO: move page to backend
  CommentsBloc(this._commentList, this._currentPage) {
    print("CREATED");
  }

  List<Comment> getCommentList() => _commentList;
  int getCurrentPage() => _currentPage;

  void setCurrentPage(String url) {
    this._currentPage += 1;
    fetchComments(url);
  }

  Future<CommentsResponse> fetchComments(String url) {
    return CommentsRequest().getComments(url, _currentPage).then((response) {
      _commentList.addAll(response.comments);
      notifyListeners();
      return response;
    });
  }

  Future<CommentsResponse> fetchQueryResults(String query) {
    return QueryRequest().query(query).then((response) {
      _commentList.addAll(response.comments);
      notifyListeners();
      return response;
    });
  }
}
