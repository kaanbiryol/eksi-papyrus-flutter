import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';
import 'TopicsResponse.dart';

class PopularTopicsRequest {
  final Networking networkManager = Networking.instance;

  Future<TopicsResponse> getPopularTopics(int page) {
    return networkManager.sendRequest(APIConstants.API_POPULAR_TOPICS,
        params: {'page': page.toString()}).then((dynamic response) {
      return TopicsResponse.fromJson(json.decode(response));
    });
  }
}

class TopicsRequest {
  final Networking networkManager = Networking.instance;

  Future<TopicsResponse> getTopics(int page, String path) {
    return networkManager.sendRequest(APIConstants.API_TOPICS, params: {
      'path': path,
      'page': page.toString()
    }).then((dynamic response) {
      return TopicsResponse.fromJson(json.decode(response));
    });
  }
}
