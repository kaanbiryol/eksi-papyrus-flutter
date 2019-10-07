import 'package:async/async.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsListTile.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsPagePickerWidget.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsBloc.dart';
import 'CommentsTypePickerWidget.dart';
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
  var currentPageViewIndex = 0;

  @override
  void initState() {
    _pageController = PageController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("CommentsListViewWidget BUILT");
    final typePickerBloc =
        Provider.of<CommentsFilterBloc>(context, listen: false);
    typePickerBloc.setCommentType(widget.topic.commentType);
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          buildListHeaderView(context),
          Expanded(child: makeFutureBuilder(context))
        ]);
  }

  Widget makeFutureBuilder(BuildContext context) {
    print("FutureBuilder BUILT");
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    return Consumer<CommentsFilterBloc>(builder: (context, bloc, child) {
      widget.topic.commentType = bloc.commentType;
      commentsBloc.setCurrentPage(bloc.filteredPage, 0);
      commentsBloc.resetCommentList();
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
    });
  }

  Future buildCommentsFuture(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    if (widget.isQuery) {
      print("isQuery");
      return commentsBloc.fetchQueryResults(
          widget.topic.title, widget.topic.commentType);
    } else {
      print("isNotQuery");
      return commentsBloc.fetchComments(
          widget.topic.url, widget.topic.commentType, 0, 0, false);
    }
  }

  Widget loadMoreProgress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
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

  var userChannelsMemoizer = new AsyncMemoizer();
  Widget makePageView(BuildContext context) {
    print("makePageView");
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        if (index != currentPageViewIndex) {
          userChannelsMemoizer = new AsyncMemoizer();
        }
        print("PAGE VIEW INDEX CHANGED  " + index.toString());
        if (index == 0) {
          return makeListViewHandler(context, index);
        }
        currentPageViewIndex = index;
        return FutureBuilder(
          key: PageStorageKey(index),
          future: loadMore(context, false),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                return makeListViewHandler(context, index);
              default:
                return Column();
            }
          },
        );
      },
      itemCount: commentsBloc.getPageCount(),
      scrollDirection: Axis.horizontal,
    );
  }

  Widget makeListViewHandler(BuildContext context, int page) {
    print("NotificationListener BUILT");
    final commentsBloc = Provider.of<CommentsBloc>(context);
    var itemList = commentsBloc.getCommentList(page);
    var canPaginate = commentsBloc.canPaginate(page);
    var itemCount = calculateItemlistCount(itemList, canPaginate);
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            canPaginate) {
          print("SCROLL MAXED");
          loadMore(context, true);
          return true;
        }
        return false;
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(height: 1.0),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                // print("Index -> " +
                //     index.toString() +
                //     " itemLength: -> " +
                //     itemList.length.toString() +
                //     " maxIndex: " +
                //     itemCount.toString());
                return decideListItem(
                    context,
                    itemCount,
                    index,
                    canPaginate,
                    index >= itemList.length
                        ? Comment.empty()
                        : itemList[index]);
              }),
        )
      ]),
    );
  }

  Widget decideListItem(BuildContext context, int itemCount, int index,
      bool canPaginate, Comment comment) {
    if (index + 1 == itemCount && canPaginate) {
      return loadMoreProgress(context);
    } else if (index > 0 && index % 10 == 0) {
      return buildPageMark(context);
    } else {
      return makeListTile(comment, context);
    }
  }

  Widget buildListHeaderView(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    return Container(
      height: 40,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
                icon: Icon(Icons.first_page),
                onPressed: () {
                  _pageController.animateToPage(1,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                }),
            FlatButton(
              padding: EdgeInsets.all(3.0),
              color: Colors.transparent,
              textColor: Theme.of(context).textTheme.subtitle.color,
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Icon(
                      Icons.sort,
                      color: Theme.of(context).accentIconTheme.color,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      "Bugün",
                      style: Theme.of(context).textTheme.subtitle,
                    ),
                  ),
                ],
              ),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return CommentsTypePickerWidget(
                        commentType: widget.topic.commentType,
                      );
                    });
              },
            ),
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: SizedBox(
                  height: 24,
                  width: 24,
                  child: IconButton(
                    color: Theme.of(context).accentIconTheme.color,
                    padding: EdgeInsets.zero,
                    icon: Icon(Icons.find_in_page),
                    iconSize: 24,
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return CommentsPagePickerWidget(
                                pageCount: commentsBloc.getPageCount());
                          });
                    },
                  )),
            ),
            IconButton(
                icon: Icon(Icons.last_page),
                onPressed: () {
                  _pageController.animateToPage(3,
                      duration: Duration(milliseconds: 200),
                      curve: Curves.ease);
                }),
          ],
        ),
      ),
    );
  }

  Widget buildPageMark(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    var page = commentsBloc.pages[currentPageViewIndex].currentPage;
    return Container(
      height: 50,
      color: Theme.of(context).accentColor,
      child: Center(child: Text("Page " + page.toString())),
    );
  }

  CommentsListTile makeListTile(Comment comment, BuildContext context) {
    return CommentsListTile(comment: comment);
  }

  Future loadMore(BuildContext context, bool willPaginate) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    print("loadMore" + currentPageViewIndex.toString());
    var pageCount = commentsBloc.pages[currentPageViewIndex].currentPage;
    if (willPaginate) {
      return commentsBloc.fetchComments(widget.topic.url,
          widget.topic.commentType, pageCount, currentPageViewIndex, true);
    } else {
      return userChannelsMemoizer.runOnce(() async {
        return commentsBloc.fetchComments(widget.topic.url,
            widget.topic.commentType, pageCount, currentPageViewIndex, false);
      });
    }
  }
}
