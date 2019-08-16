import 'package:flutter/foundation.dart';
import 'networking/models/TopicsRequest.dart';
import 'networking/models/TopicsResponse.dart';

class TopicList {
  ValueKey key;
  String url;
  int page;
  List<Topic> topicList;

  TopicList(this.key, this.url, this.page, this.topicList);

  Future<TopicsResponse> fetchTopics() {
    return TopicsRequest().getTopics(page, url);
  }
}

class PopularTopicsNotifier with ChangeNotifier {
  Map<String, TopicList> topicsMap = {};
  List<Topic> _popularTopics = [];
  int _currentPage = 1;

  PopularTopicsNotifier(this._popularTopics);

  void setCurrentPageFor(String url, ValueKey key) {
    this._currentPage += 1;
    fetchTopics(url, key);
  }

  Future<TopicsResponse> fetchPopularTopics() {
    return PopularTopicsRequest()
        .getPopularTopics(_currentPage)
        .then((response) {
      _popularTopics.addAll(response.popularTopics);
      notifyListeners();
    });
  }

  List<Topic> getPopularTopics2(ValueKey key) {
    return topicsMap[key.value].topicList;
  }

  List<Topic> getPopularTopics(String key) {
    return _popularTopics;
  }

  bool hasTopicsInPage(ValueKey key) {
    return topicsMap[generatePageKey(key.value)] != null;
  }

  String generatePageKey(String pageIndex) {
    return pageIndex;
  }

  Future<TopicsResponse> fetchTopics(String url, ValueKey key) {
    return TopicsRequest().getTopics(_currentPage, url).then((response) {
      if (topicsMap.containsKey(key.value)) {
        var topicList = topicsMap[key.value];
        topicList.page += 1;
        topicList.topicList.addAll(response.popularTopics);
      } else {
        topicsMap[key.value] = TopicList(key, url, 0, response.popularTopics);
      }
      notifyListeners();
      return response;
    });
  }
}

//TODO : an idea
class PopularTopicsNotifierInteractor {}
