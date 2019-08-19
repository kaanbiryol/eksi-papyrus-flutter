import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsResponse.dart';

class QueryRequest {
  final Networking networkManager = Networking.instance;

  Future<CommentsResponse> query(String query) {
    return networkManager.sendRequest(APIConstants.API_SEARCH,
        params: {'q': query}).then((dynamic response) {
      return CommentsResponse.fromJson(json.decode(response));
    });
  }
}
