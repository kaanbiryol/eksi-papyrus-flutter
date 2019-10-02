import 'package:eksi_papyrus/scenes/comments/CommentsListTile.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsPagePickerWidget.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsBloc.dart';
import 'CommentsTypePickerWidget.dart';
import 'networking/models/CommentsResponse.dart';

class CommentsListViewWidget extends StatelessWidget {
  const CommentsListViewWidget({Key key, this.topic, this.isQuery})
      : super(key: key);

  final Topic topic;
  final bool isQuery;

  @override
  Widget build(BuildContext context) {
    print("CommentsListViewWidget BUILT");
    final typePickerBloc =
        Provider.of<CommentsFilterBloc>(context, listen: false);
    typePickerBloc.setCommentType(topic.commentType);
    return makeFutureBuilder(context);
  }

  Widget makeFutureBuilder(BuildContext context) {
    print("FutureBuilder BUILT");
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    return Consumer<CommentsFilterBloc>(builder: (context, bloc, child) {
      topic.commentType = bloc.commentType;
      commentsBloc.setCurrentPage(bloc.filteredPage);
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
              return makeListViewHandler(context);
            default:
              return Column();
          }
        },
      );
    });
  }

  Future buildCommentsFuture(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    if (isQuery) {
      print("isQuery");
      return commentsBloc.fetchQueryResults(topic.title, topic.commentType);
    } else {
      print("isNotQuery");
      return commentsBloc.fetchComments(topic.url, topic.commentType);
    }
  }

  Widget loadMoreProgress(BuildContext context) {
    return Center(child: CircularProgressIndicator());
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

  Widget makeListViewHandler(BuildContext context) {
    print("NotificationListener BUILT");
    final commentsBloc = Provider.of<CommentsBloc>(context);
    var itemList = commentsBloc.getCommentList();
    var canPaginate = commentsBloc.canPaginate();
    var itemCount = calculateItemlistCount(itemList, canPaginate);
    print("itemCount" + itemCount.toString());
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo is ScrollEndNotification &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
            canPaginate) {
          print("SCROLL MAXED");
          loadMore(context);
          return true;
        }
        return false;
      },
      child:
          Column(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        buildListHeaderView(context),
        Expanded(
          child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                print("Index -> " +
                    index.toString() +
                    " itemLength: -> " +
                    itemList.length.toString() +
                    " maxIndex: " +
                    itemCount.toString());
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
      return buildPageMark(context, (index / 10 + 1).round());
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
                        commentType: topic.commentType,
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
          ],
        ),
      ),
    );
  }

  Widget buildPageMark(BuildContext context, int pageNumber) {
    print("PAHE NUMBER" + pageNumber.toString());
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    return Container(
      height: 50,
      color: Theme.of(context).backgroundColor,
      child: Center(
          child: Text(
              "Page " + commentsBloc.pageNumbers[pageNumber - 1].toString())),
    );
  }

  CommentsListTile makeListTile(Comment comment, BuildContext context) {
    return CommentsListTile(comment: comment);
  }

  void loadMore(BuildContext context) {
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    print("Load More" + commentsBloc.getPageCount().toString());
    commentsBloc.fetchComments(topic.url, topic.commentType);
  }
}
