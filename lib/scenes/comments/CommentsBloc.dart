import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/search/networking/models/QueryRequest.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/CommentsResponse.dart';

class Page {
  List<Comment> commentList = [];
  List<int> pageNumbers = [];
  int currentPage = 0;
  int pageCount = 1;

  Page(this.commentList, this.pageCount, this.currentPage);
}

class CommentsBloc with ChangeNotifier {
  List<Comment> _commentList = [];
  List<int> pageNumbers = [];
  int _currentPage = 0;
  int _pageCount = 1;
  //TODO: set topicurl
  String topicUrl;
  CommentType commentType;
  List<Page> pages = [];

  int listViewCurrentIndex = 1;

  void setCurrentIndex(int page) {
    listViewCurrentIndex = page;
    notifyListeners();
  }

  //TODO: move page to backend
  CommentsBloc(this._commentList, this._currentPage) {
    print("CREATED");
    pages.add(Page([], 1, 0));
  }

  int getPageCount() => _pageCount;

  void resetCommentList() {
    _commentList.clear();
    pageNumbers.clear();
  }

  bool canPaginate(int index) {
    return true;
  }

  List<Comment> getCommentList(int index) {
    return pages[index].commentList;
  }

  void increaseCurrentPage(int index) {
    if (pages[index].currentPage < pages[index].pageCount) {
      pages[index].currentPage++;
    }
  }

  void setCurrentPage(int page, int index) {
    pages[index].currentPage = page;
    notifyListeners();
  }

  Future<CommentsResponse> fetchComments(
      String url, CommentType type, int index, int page, bool isPagination) {
    //increaseCurrentPage(index);
    //TODO: why is _currentPage is set to 1?

    var commentPage = page + 1;
    if (isPagination) {
      commentPage = index + 1;
    }

    return CommentsRequest()
        .getComments(url, type, commentPage)
        .catchError((onError) {
      print(onError.toString());
    }).then((response) {
      _commentList.addAll(response.comments);
      _currentPage = int.parse(response.page);
      _pageCount = int.parse(response.pageCount);

      if (pages.length > page) {
        var existingPage = pages[page];
        existingPage.commentList.addAll(response.comments);
        existingPage.currentPage = int.parse(response.page);
        existingPage.pageCount = int.parse(response.pageCount);
        pages[page] = existingPage;
      } else {
        pages.add(Page(response.comments, _pageCount, _currentPage));
      }
      if (page == 0) {
        for (var i = 0; i < _pageCount; i++) {
          pages.add(Page([], _pageCount, i));
        }
      }
      pageNumbers.add(_currentPage);
      // print("PAGE NUMBERS" + pageNumbers.toString());
      if (isPagination) {
        notifyListeners();
      }
      return response;
    });
  }

  Future<CommentsResponse> fetchQueryResults(
      String query, CommentType type) async {
    var queryResponse = await QueryRequest().query(query);
    var queryUrl = queryResponse.topicUrl;
    return fetchComments(queryUrl, type, 0, 0, false);
  }
}
