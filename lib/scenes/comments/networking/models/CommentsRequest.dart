import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';

import 'CommentsResponse.dart';

enum CommentType { today, popular, all }

String makeCommentTypeTitle(CommentType commentType) {
  switch (commentType) {
    case CommentType.all:
      return "Hepsi";
    case CommentType.popular:
      return "Popüler";
    case CommentType.today:
      return "Bugün";
    default:
      return "";
  }
}

class CommentsRequest {
  final Networking networkManager = Networking.instance;

  Future<CommentsResponse> getComments(String url, CommentType type, int page) {
    return networkManager.sendRequest(APIConstants.API_COMMENTS, params: {
      'url': url,
      'type': type.index.toString(),
      'page': page.toString()
    }).then((dynamic response) {
      return CommentsResponse.fromJson(json.decode(response));
    });
  }
}
