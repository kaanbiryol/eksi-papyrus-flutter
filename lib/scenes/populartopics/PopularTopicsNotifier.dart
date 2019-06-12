import 'package:eksi_papyrus/scenes/main/ChannelsNotifier.dart';
import 'package:eksi_papyrus/scenes/main/networking/ChannelRequest.dart';
import 'package:eksi_papyrus/scenes/main/networking/models/Channel.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopicsRequest.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/PopularTopic.dart';

class PopularTopicsNotifier with ChangeNotifier {
  Map<String, List<PopularTopic>> topicsMap = {};
  List<PopularTopic> _popularTopics = [];
  int _currentPage = 1;

  PopularTopicsNotifier(this._popularTopics);

  void setCurrentPage() {
    this._currentPage += 1;
    fetchPopularTopics();
  }

  Future<List<PopularTopic>> fetchPopularTopics() {
    return PopularTopicsRequest()
        .getPopularTopics(_currentPage)
        .then((response) {
      _popularTopics.addAll(response);
      notifyListeners();
    });
  }

  List<PopularTopic> getPopularTopics2(String key) {
    return topicsMap[key];
  }

  bool hasTopicsInPage(int key) {
    return topicsMap[generatePageKey(key)] != null;
  }

  String generatePageKey(int pageIndex) {
    return pageIndex.toString();
  }

  Future<List<PopularTopic>> fetchTopics(String url, String key) {
    return TopicsRequest().getTopics(_currentPage, url).then((response) {
      topicsMap[key] = response;
      notifyListeners();
    });
  }
}

//TODO : an idea
class PopularTopicsNotifierInteractor {}
