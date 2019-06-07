import 'package:flutter/foundation.dart';

import 'networking/models/PopularTopic.dart';

class PopularTopicsNotifier with ChangeNotifier {
  List<PopularTopic> _popularTopics;

  PopularTopicsNotifier(this._popularTopics);

  List<PopularTopic> getPopularTopics() => _popularTopics;

  void setPopularTopics(List<PopularTopic> popularTopicsList) {
    this._popularTopics = popularTopicsList;
    notifyListeners();
  }
}

//TODO : an idea
class PopularTopicsNotifierInteractor {}
