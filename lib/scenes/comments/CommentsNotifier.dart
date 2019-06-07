import 'package:eksi_papyrus/scenes/comments/networking/models/Comment.dart';
import 'package:flutter/foundation.dart';

class CommentsNotifier with ChangeNotifier {
  List<Comment> _commentList;

  CommentsNotifier(this._commentList);

  List<Comment> getCommentList() => _commentList;

  void setCommentList(List<Comment> commentList) {
    this._commentList = commentList;
    notifyListeners();
  }
}
