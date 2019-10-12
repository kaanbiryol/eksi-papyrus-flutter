import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:flutter/foundation.dart';
import 'networking/models/TopicsRequest.dart';
import 'networking/models/TopicsResponse.dart';

class TopicList {
  ValueKey key;
  String url;
  int _currentPage;
  int _pageCount;
  List<Topic> topicList;

  TopicList(
      this.key, this.url, this._currentPage, this._pageCount, this.topicList);

  Future<TopicsResponse> fetchTopics() {
    return TopicsRequest().getTopics(_currentPage, url);
  }

  void reset() {
    _currentPage = 0;
    _pageCount = 1;
    topicList.clear();
  }
}

class TopicsBloc with ChangeNotifier {
  Map<String, TopicList> topicsMap = {};
  List<Topic> topics = [];

  TopicsBloc(this.topics);

  List<Topic> getPopularTopics2(ValueKey key) {
    return topicsMap[key.value].topicList;
  }

  bool hasTopicsInPage(ValueKey key) {
    return topicsMap[generatePageKey(key.value)] != null;
  }

  String generatePageKey(String pageIndex) {
    return pageIndex;
  }

  bool canPaginate(ValueKey key) {
    var topicList = topicsMap[key.value];
    return topicList._currentPage + 1 <= topicList._pageCount;
  }

  Future<TopicsResponse> fetchTopics(
      String url, ValueKey key, CommentType type) {
    return TopicsRequest()
        .getTopics(++topicsMap[key.value]?._currentPage ?? 1, url)
        .then((response) {
      var topics = response.topics.map((topic) {
        topic.commentType = type;
        return topic;
      }).toList();

      var pageCount = int.parse(response.pageCount);
      var currentPage = int.parse(response.currentPage);
      if (topicsMap.containsKey(key.value)) {
        var topicList = topicsMap[key.value];
        topicList._currentPage = currentPage;
        topicList._pageCount = pageCount;
        topicList.topicList.addAll(topics);
      } else {
        topicsMap[key.value] = TopicList(key, url, 1, pageCount, topics);
      }

      notifyListeners();
      return response;
    });
  }

  Future<TopicsResponse> refresh(ValueKey key) {
    var topic = topicsMap[key.value];
    topic.reset();
    return fetchTopics(topic.url, key, CommentType.all);
  }
}
