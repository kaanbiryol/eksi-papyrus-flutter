import 'package:flutter/widgets.dart';

class CommentsPageScrollNotifier extends ChangeNotifier {
  int _currentPage = 0;
  int _totalPage = 1;
  CommentsPageScrollNotifier(this._currentPage, this._totalPage);

  void setCurrentPage(int page) {
    _currentPage = page;
    notifyListeners();
  }

  void setTotalPage(int page) {
    _totalPage = page;
    notifyListeners();
  }

  int currentPage() => _currentPage;
  int totalPage() => _totalPage;

  String currentPageText() =>
      _currentPage.toString() + "/" + _totalPage.toString();
}
