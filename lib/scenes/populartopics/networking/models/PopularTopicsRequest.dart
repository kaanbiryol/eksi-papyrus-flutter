import 'dart:convert';

import 'package:eksi_papyrus/core/networking/APIConstants.dart';
import 'package:eksi_papyrus/core/networking/Networking.dart';

import 'PopularTopic.dart';
import 'PopularTopics.dart';

class PopularTopicsRequest {
  final Networking networkManager = Networking.instance;

  Future<List<PopularTopic>> getPopularTopics(int page) {
    return networkManager.sendRequest(APIConstants.API_POPULAR_TOPICS,
        params: {'page': page.toString()}).then((dynamic response) {
      return PopularTopics.fromJson(json.decode(response)).popularTopics;
    });
  }
}

class TopicsRequest {
  final Networking networkManager = Networking.instance;

  Future<List<PopularTopic>> getTopics(int page, String path) {
    return networkManager.sendRequest(APIConstants.API_TOPICS, params: {
      'path': path,
      'page': page.toString()
    }).then((dynamic response) {
      return PopularTopics.fromJson(json.decode(response)).popularTopics;
    });
  }
}
