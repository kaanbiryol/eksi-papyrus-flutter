import 'dart:convert';

import 'package:eksi_papyrus/networking/APIConstants.dart';
import 'package:eksi_papyrus/networking/Networking.dart';

import 'models/PopularTopic.dart';
import 'models/PopularTopics.dart';

class PopularTopicsNetworking {
  final Networking networkManager = Networking.instance;

  Future<List<PopularTopic>> getPopularTopics(int page) {
    return networkManager.sendRequest(APIConstants.API_POPULAR_TOPICS,
        {'page': page.toString()}).then((dynamic response) {
      return PopularTopics.fromJson(json.decode(response)).popularTopics;
    });
  }
}
