import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopicsRequest.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/PopularTopic.dart';

class PopularTopicsNotifier with ChangeNotifier {
  List<PopularTopic> _popularTopics = [];
  int _currentPage = 1;

  PopularTopicsNotifier(this._popularTopics);

  List<PopularTopic> getPopularTopics() => _popularTopics;

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
}

//TODO : an idea
class PopularTopicsNotifierInteractor {}
