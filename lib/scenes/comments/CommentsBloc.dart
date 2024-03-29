import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/search/networking/models/QueryRequest.dart';
import 'package:eksi_papyrus/scenes/search/networking/models/QueryResponse.dart';
import 'package:flutter/foundation.dart';

import 'networking/models/CommentsResponse.dart';

class Page {
  List<Comment> commentList = [];
  int currentPage = 0;
  int pageCount = 1;
  Page(this.commentList, this.pageCount, this.currentPage);
}

class CommentsBloc with ChangeNotifier {
  int _pageCount = 1;
  String topicUrl;
  CommentType commentType;
  List<Page> pages = [];
  var _isLoading = false;

  CommentsBloc({String url}) {
    this.topicUrl = url;
    pages.add(Page([], 1, 0));
  }

  Future<CommentsResponse> fetchComments(
      CommentType type, int index, int page, bool isPagination) {
    var commentPage = page + 1;
    if (isPagination) {
      commentPage = index + 1;
    }
    _isLoading = true;
    return CommentsRequest()
        .getComments(this.topicUrl, type, commentPage)
        .catchError((onError) {
      print(onError.toString());
    }).then((response) {
      var currentPage = int.parse(response.page);
      _pageCount = int.parse(response.pageCount);

      if (pages.length > page) {
        var existingPage = pages[page];
        existingPage.commentList.addAll(response.comments);
        existingPage.currentPage = int.parse(response.page);
        existingPage.pageCount = int.parse(response.pageCount);
        pages[page] = existingPage;
      } else {
        pages.add(Page(response.comments, _pageCount, currentPage));
      }
      if (page == 0) {
        for (var i = 0; i < _pageCount; i++) {
          pages.add(Page([], _pageCount, i));
        }
      }
      if (isPagination) {
        notifyListeners();
      }
      _isLoading = false;
      return response;
    });
  }

  Future<CommentsResponse> fetchQueryResults(
      String query, CommentType type) async {
    QueryResponse queryResponse = await QueryRequest().query(query);
    String queryUrl = queryResponse.topicUrl;
    this.topicUrl = queryUrl;
    return fetchComments(type, 0, 0, false);
  }

  List<Comment> getCommentList(int index) {
    return pages[index].commentList;
  }

  int getPageCount() => _pageCount;

  bool canPaginate(int index) {
    Page currentPageViewPage = pages[index];
    return !_isLoading &&
        currentPageViewPage.currentPage < currentPageViewPage.pageCount;
  }

  void setCurrentPage(int page, int index) {
    pages[index].currentPage = page;
    notifyListeners();
  }

  void clearPages() {
    pages.clear();
  }
}
