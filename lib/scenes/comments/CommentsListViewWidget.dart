import 'package:async/async.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsListTile.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsTypeHeader.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'CommentsBloc.dart';
import 'CommentsListViewHeaderWidget.dart';
import 'CommentsPageScrollNotifier.dart';
import 'networking/models/CommentsRequest.dart';
import 'networking/models/CommentsResponse.dart';

class CommentsListViewWidget extends StatefulWidget {
  const CommentsListViewWidget({Key key, this.topic, this.isQuery})
      : super(key: key);

  final Topic topic;
  final bool isQuery;

  @override
  _CommentsListViewWidgetState createState() => _CommentsListViewWidgetState();
}

class _CommentsListViewWidgetState extends State<CommentsListViewWidget> {
  PageController _pageController;
  ScrollController _scrollController;
  List<AsyncMemoizer> _memoizer;

  @override
  void initState() {
    print("initState");
    _pageController = PageController();
    _scrollController = ScrollController()..addListener(onScroll);
    _memoizer = [];
    super.initState();
  }

  void onScroll() {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    int currentPage = _pageController.page.toInt();
    if (_scrollController.offset + 600 >=
            _scrollController.position.maxScrollExtent &&
        commentsBloc.canPaginate(currentPage)) {
      loadMorePagination(context, currentPage);
    }
  }

  void onTypeChanged(CommentType type) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    commentsBloc.clearPages();
    widget.topic.commentType = type;
    setState(() {});
  }

  @override
  void dispose() {
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    _pageController.jumpToPage(page);
  }

  void setTotalPages(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    final scrollPageNotifier =
        Provider.of<CommentsPageScrollNotifier>(context, listen: false);
    scrollPageNotifier.setTotalPage(commentsBloc.getPageCount());
  }

  @override
  Widget build(BuildContext context) {
    print("CommentsListViewWidget BUILT");

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Card(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          elevation: 0.6,
          child: CommentsListViewHeaderWidget(
            onPageChanged: onPageChanged,
          ),
        ),
        Expanded(child: makeFutureBuilder(context))
      ],
    );
  }

  Widget makeFutureBuilder(BuildContext context) {
    print("FutureBuilder BUILT");
    return FutureBuilder(
      future: buildCommentsFuture(context),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return makePageView(context);
          default:
            return Column();
        }
      },
    );
  }

  Future buildCommentsFuture(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    if (widget.isQuery) {
      print("isQuery");
      return commentsBloc.fetchQueryResults(
          widget.topic.title, widget.topic.commentType);
    } else {
      print("isNotQuery");
      return commentsBloc.fetchComments(widget.topic.commentType, 0, 0, false);
    }
  }

  Widget loadMoreProgress(BuildContext context) {
    return Container(
      height: 50,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(child: CircularProgressIndicator()),
      ),
    );
  }

  int calculateItemlistCount(List<Comment> commentList, bool canPaginate) {
    if (commentList != null) {
      if (canPaginate) {
        return commentList.length + 1;
      } else {
        return commentList.length;
      }
    } else {
      return 0;
    }
  }

  Widget makePageView(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => setTotalPages(context));
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    resetMemoizers(commentsBloc.getPageCount());
    final scrollPageNotifier =
        Provider.of<CommentsPageScrollNotifier>(context, listen: false);
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        if (index == 0) {
          return makeListViewHandler(context, index, true);
        }
        return FutureBuilder(
          key: PageStorageKey(index),
          future: loadMore(context, index),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return makeListViewHandler(context, index, false);
              default:
                return Column();
            }
          },
        );
      },
      itemCount: commentsBloc.getPageCount(),
      scrollDirection: Axis.horizontal,
      onPageChanged: (index) {
        scrollPageNotifier.setCurrentPage(index + 1);
      },
    );
  }

  Widget makeListViewHandler(
      BuildContext context, int page, bool hasTypePicker) {
    print("makeListVieHandler" + page.toString());
    final scrollPageNotifier =
        Provider.of<CommentsPageScrollNotifier>(context, listen: false);
    final commentsBloc = Provider.of<CommentsBloc>(context);
    var itemList = commentsBloc.getCommentList(page);
    var canPaginate = commentsBloc.canPaginate(page);
    var itemCount = calculateItemlistCount(itemList, canPaginate);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification) {
          Future.microtask(() {
            int currentItemIndex = getMeta(0, 50) ?? 0;
            int currentPage = currentItemIndex ~/ 10;
            print(scrollPageNotifier.currentPage().toString() +
                " - " +
                currentPage.toString());
            if (scrollPageNotifier.currentPage() - 1 != currentPage) {
              scrollPageNotifier.setCurrentPage((page + 1) + currentPage);
            }
          });
          return true;
        }
        return false;
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(
          child: ListView.separated(
              controller: _scrollController,
              separatorBuilder: (context, index) => Divider(height: 1.0),
              itemCount: hasTypePicker ? itemCount + 1 : itemCount,
              itemBuilder: (BuildContext context, int index) {
                // print("Index -> " +
                //     index.toString() +
                //     " itemLength: -> " +
                //     itemList.length.toString() +
                //     " maxIndex: " +
                //     itemCount.toString() +
                //     "page" +
                //     (index ~/ 10).toString());

                if (hasTypePicker) {
                  if (index == 0) {
                    return CommentsTypeHeader(
                        onTypeChanged: onTypeChanged,
                        commentType: widget.topic.commentType);
                  }
                  index -= 1;
                }
                return MetaData(
                    behavior: HitTestBehavior.translucent,
                    metaData: index,
                    child: decideListItem(
                        context,
                        itemCount,
                        index,
                        canPaginate,
                        index >= itemList.length
                            ? Comment.empty()
                            : itemList[index],
                        hasTypePicker));
              }),
        )
      ]),
    );
  }

  Widget decideListItem(BuildContext context, int itemCount, int index,
      bool canPaginate, Comment comment, bool hasTypePicker) {
    if (index + 1 == itemCount && canPaginate) {
      return loadMoreProgress(context);
    } else if (index > 0 && index % 10 == 0) {
      return buildPageMark(context, index);
    } else {
      return CommentsListTile(comment: comment);
    }
  }

  Widget buildPageMark(BuildContext context, int index) {
    return Container(
      height: 50,
      color: Color.fromRGBO(18, 18, 18, 0.2),
      child: Center(child: Text("Page " + (index ~/ 10 + 1).toString())),
    );
  }

  Future loadMore(BuildContext context, int page) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    var pageCount = commentsBloc.pages[page].currentPage;
    return _memoizer[page].runOnce(() async {
      return commentsBloc.fetchComments(
          widget.topic.commentType, pageCount, page, false);
    });
  }

  Future loadMorePagination(BuildContext context, int page) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    var pageCount = commentsBloc.pages[page].currentPage;
    return commentsBloc.fetchComments(
        widget.topic.commentType, pageCount, page, true);
  }

  void resetMemoizers(int numberOfPages) {
    for (var i = 0; i < numberOfPages; i++) {
      _memoizer.add(new AsyncMemoizer());
    }
  }

  T getMeta<T>(double x, double y) {
    var renderBox = context.findRenderObject() as RenderBox;
    var offset = renderBox.localToGlobal(Offset(x, y));

    final HitTestResult result = new HitTestResult();
    WidgetsBinding.instance.hitTest(result, offset);
    for (HitTestEntry entry in result.path) {
      if (entry.target is RenderMetaData) {
        final renderMetaData = entry.target as RenderMetaData;
        if (renderMetaData.metaData is T) return renderMetaData.metaData as T;
      }
    }
    return null;
  }
}
