import 'package:eksi_papyrus/scenes/comments/CommentsListTile.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsBloc.dart';
import 'networking/models/CommentsResponse.dart';

class CommentsListViewWidget extends StatelessWidget {
  const CommentsListViewWidget({Key key, this.topic, this.isQuery})
      : super(key: key);

  final Topic topic;
  final bool isQuery;

  @override
  Widget build(BuildContext context) {
    print("CommentsListViewWidget BUILT");
    return Container(
      child: makeFutureBuilder(context),
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
            return makeListViewHandler(context);
          default:
            return Column();
        }
      },
    );
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
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return (index + 1 == itemCount && canPaginate)
                ? loadMoreProgress(context)
                : makeListTile(commentsBloc.getCommentList()[index], context);
          },
        ));
  }

  CommentsListTile makeListTile(Comment comment, BuildContext context) {
    return CommentsListTile(comment: comment);
  }

  void loadMore(BuildContext context) {
    print("Load More");
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    commentsBloc.fetchComments(topic.url, topic.commentType);
  }
}
