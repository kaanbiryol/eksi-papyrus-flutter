import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopicsRequest.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/PopularTopic.dart';

class TopicList {
  ValueKey key;
  String url;
  int page;
  List<PopularTopic> topicList;

  TopicList(this.key, this.url, this.page, this.topicList);

  Future<List<PopularTopic>> fetchTopics() {
    return TopicsRequest().getTopics(page, url);
  }
}

class PopularTopicsNotifier with ChangeNotifier {
  Map<String, TopicList> topicsMap = {};
  List<PopularTopic> _popularTopics = [];
  int _currentPage = 1;

  PopularTopicsNotifier(this._popularTopics);

  void setCurrentPageFor(String url, ValueKey key) {
    this._currentPage += 1;
    fetchTopics(url, key);
  }

  Future<List<PopularTopic>> fetchPopularTopics() {
    return PopularTopicsRequest()
        .getPopularTopics(_currentPage)
        .then((response) {
      _popularTopics.addAll(response);
      notifyListeners();
    });
  }

  List<PopularTopic> getPopularTopics2(ValueKey key) {
    return topicsMap[key.value].topicList;
  }

  List<PopularTopic> getPopularTopics(String key) {
    return _popularTopics;
  }

  bool hasTopicsInPage(ValueKey key) {
    return topicsMap[generatePageKey(key.value)] != null;
  }

  String generatePageKey(String pageIndex) {
    return pageIndex;
  }

  Future<List<PopularTopic>> fetchTopics(String url, ValueKey key) {
    return TopicsRequest().getTopics(_currentPage, url).then((response) {
      if (topicsMap.containsKey(key.value)) {
        var topicList = topicsMap[key.value];
        topicList.page += 1;
        topicList.topicList.addAll(response);
      } else {
        topicsMap[key.value] = TopicList(key, url, 0, response);
      }
      notifyListeners();
    });
  }
}

//TODO : an idea
class PopularTopicsNotifierInteractor {}
