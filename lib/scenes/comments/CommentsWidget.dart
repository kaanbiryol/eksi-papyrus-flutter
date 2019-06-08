import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/Comment.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CommentsNotifier.dart';

//TODO: turn this into stateful?!?
class CommentsWidget extends StatelessWidget {
  CommentsWidget({Key key}) : super(key: key);

  PopularTopic _topic;

  @override
  Widget build(BuildContext context) {
    print("WIDGET BUILT");
    final CommentsWidgetRouteArguments args =
        ModalRoute.of(context).settings.arguments;
    var topic = args.topic;
    this._topic = topic;
    final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.accent,
        title: Text(topic.title));
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: topAppBar,
        body: futureBuilder(context));
  }

  Widget futureBuilder(BuildContext context) {
    print("FutureBuilder BUILT");
    return FutureBuilder(
      future: CommentsRequest().getComments(_topic.url, 1),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return makeListView(context, snapshot.data);
        }
      },
    );
  }

  Widget loadMoreProgress(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget makeListView(BuildContext context, List<Comment> data) {
    print("LISTVIEW BUILT");
    final commentsNotifier = Provider.of<CommentsNotifier>(context);
    commentsNotifier.setCommentsList(data);

    var itemList = commentsNotifier.getCommentList();
    var itemCount =
        (itemList != null) ? commentsNotifier.getCommentList().length + 1 : 0;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          loadMore(context);
        }
      },
      child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
              color: AppColors.listDivider,
            ),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return (index + 1 == itemCount)
              ? loadMoreProgress(context)
              : makeListTile(commentsNotifier.getCommentList()[index], context);
        },
      ),
    );
  }

  ListTile makeListTile(Comment comment, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      title: MarkdownBody(
        data: comment.comment,
        styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
            p: Theme.of(context)
                .textTheme
                .body1
                .copyWith(fontSize: 14.0, color: Colors.white)),
        onTapLink: (url) {
          launch(url);
        },
      ),
    );
  }

  void loadMore(BuildContext context) {
    print("Load More");
    final commentsNotifier = Provider.of<CommentsNotifier>(context);
    commentsNotifier.setCurrentPage(_topic.url);
  }
}
