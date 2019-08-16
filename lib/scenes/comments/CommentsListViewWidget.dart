import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CommentsNotifier.dart';
import 'networking/models/CommentsResponse.dart';

class CommentsListViewWidget extends StatelessWidget {
  const CommentsListViewWidget({Key key, this.topic}) : super(key: key);

  final PopularTopic topic;

  @override
  Widget build(BuildContext context) {
    print("CommentsListViewWidget BUILT");
    return Container(
      child: makeFutureBuilder(context),
    );
  }

  Widget makeFutureBuilder(BuildContext context) {
    print("FutureBuilder BUILT");
    final notifier = Provider.of<CommentsNotifier>(context, listen: false);
    return FutureBuilder(
      future: notifier.fetchComments(topic.url),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return makeListViewHandler(context);
        }
      },
    );
  }

  Widget loadMoreProgress(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget makeListViewHandler(BuildContext context) {
    print("NotificationListener BUILT");
    final notifier = Provider.of<CommentsNotifier>(context);
    var itemList = notifier.getCommentList();
    var itemCount =
        (itemList != null) ? notifier.getCommentList().length + 1 : 0;
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            print("SCROLL MAXED");
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
                : makeListTile(notifier.getCommentList()[index], context);
          },
        ));
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
    final commentsNotifier =
        Provider.of<CommentsNotifier>(context, listen: false);
    commentsNotifier.setCurrentPage(topic.url);
  }
}
