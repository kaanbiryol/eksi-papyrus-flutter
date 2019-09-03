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
}

class TopicsBloc with ChangeNotifier {
  Map<String, TopicList> topicsMap = {};
  List<Topic> topics = [];

  TopicsBloc(this.topics);

  // Future<TopicsResponse> fetchPopularTopics() {
  //   return PopularTopicsRequest()
  //       .getPopularTopics(topics)
  //       .then((response) {
  //     topics.addAll(response.topics);
  //     notifyListeners();
  //     return response;
  //   });
  // }

  List<Topic> getPopularTopics2(ValueKey key) {
    return topicsMap[key.value].topicList;
  }

  List<Topic> getPopularTopics(String key) {
    return topics;
  }

  bool hasTopicsInPage(ValueKey key) {
    return topicsMap[generatePageKey(key.value)] != null;
  }

  String generatePageKey(String pageIndex) {
    return pageIndex;
  }

  Future<TopicsResponse> fetchTopics(
      String url, ValueKey key, CommentType type) {
    return TopicsRequest()
        .getTopics(topicsMap[key.value]?._currentPage ?? 1, url)
        .then((response) {
      var topics = response.topics.map((topic) {
        topic.commentType = type;
        return topic;
      }).toList();

      if (topicsMap.containsKey(key.value)) {
        var topicList = topicsMap[key.value];
        topicList._currentPage = int.parse(response.currentPage);
        topicList._pageCount = int.parse(response.pageCount);
        topicList.topicList.addAll(topics);
      } else {
        topicsMap[key.value] = TopicList(key, url, 1, 1, topics);
      }

      notifyListeners();
      return response;
    });
  }
}

//TODO : an idea
class PopularTopicsNotifierInteractor {}
