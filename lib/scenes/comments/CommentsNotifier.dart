import 'package:eksi_papyrus/scenes/comments/networking/models/Comment.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:flutter/foundation.dart';

class CommentsNotifier with ChangeNotifier {
  List<Comment> _commentList = [];
  int _currentPage = 1;

  CommentsNotifier(this._commentList, this._currentPage) {
    print("CREATED");
  }

  List<Comment> getCommentList() => _commentList;
  int getCurrentPage() => _currentPage;

  void setCurrentPage(String url) {
    this._currentPage += 1;
    fetchComments(url);
  }

  Future<List<Comment>> fetchComments(String url) {
    return CommentsRequest().getComments(url, _currentPage).then((response) {
      _commentList.addAll(response);
      notifyListeners();
    });
  }
}
