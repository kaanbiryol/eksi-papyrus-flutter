import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'package:eksi_papyrus/models/Comment.dart';
import 'package:eksi_papyrus/models/Comments.dart';

class CommentsNetworking {
  final Networking networkManager = Networking.instance;

  Future<List<Comment>> getComments(String url, int page) {
    return networkManager.sendRequest(APIConstants.API_COMMENTS,
        {'url': url, 'page': page.toString()}).then((dynamic response) {
      return Comments.fromJson(json.decode(response)).comments;
    });
  }
}

 