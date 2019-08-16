import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';

import 'CommentsResponse.dart';

class CommentsRequest {
  final Networking networkManager = Networking.instance;

  Future<List<Comment>> getComments(String url, int page) {
    return networkManager.sendRequest(APIConstants.API_COMMENTS,
        params: {'url': url, 'page': page.toString()}).then((dynamic response) {
      return CommentsResponse.fromJson(json.decode(response)).comments;
    });
  }
}
