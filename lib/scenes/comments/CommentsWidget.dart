import 'dart:math';

import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'CommentsBloc.dart';
import 'CommentsListViewWidget.dart';
import 'CommentsPagePickerWidget.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({Key key, @required this.topic, this.isQuery})
      : super(key: key);

  final Topic topic;
  final bool isQuery;

  @override
  Widget build(BuildContext context) {
    print("CommentsWidget BUILT" + isQuery.toString());
    final topAppBar = AppBar(
      elevation: 0.6,
      title: Text(topic.title),
      bottom: CommentsWidgetHeader(),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryIconTheme.color,
          icon: Icon(Icons.share),
          onPressed: () {
            Share.share(topic.url);
          },
        )
      ],
    );
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => CommentsBloc(1)),
        ],
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: topAppBar,
            body: CommentsListViewWidget(topic: topic, isQuery: isQuery)));
  }
}

class CommentsWidgetHeader extends StatelessWidget
    implements PreferredSizeWidget {
  CommentsWidgetHeader({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return buildListHeaderView(context);
  }

  Widget buildListHeaderView(BuildContext context) {
    print("buildListheaderView");
    final scrollPageNotifier = Provider.of<ScrollPageNotifier>(context);
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
                color: Theme.of(context).primaryIconTheme.color,
                icon: Icon(Icons.first_page),
                onPressed: () {
                  // _pageController.jumpToPage(0);
                }),
            FlatButton(
              padding: EdgeInsets.all(3.0),
              color: Colors.transparent,
              textColor: Theme.of(context).textTheme.subtitle.color,
              child: Text(scrollPageNotifier.currentPageText()),
              onPressed: () {
                showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      return CommentsPagePickerWidget(
                          pageCount: commentsBloc.getPageCount());
                    });
              },
            ),
            // FlatButton(
            //   padding: EdgeInsets.all(3.0),
            //   color: Colors.transparent,
            //   textColor: Theme.of(context).textTheme.subtitle.color,
            //   child: Row(
            //     children: <Widget>[
            //       Padding(
            //         padding: const EdgeInsets.all(2.0),
            //         child: Icon(
            //           Icons.sort,
            //           color: Theme.of(context).accentIconTheme.color,
            //         ),
            //       ),
            //       Padding(
            //         padding: const EdgeInsets.all(2.0),
            //         child: Text(
            //           "Bugün",
            //           style: Theme.of(context).textTheme.subtitle,
            //         ),
            //       ),
            //     ],
            //   ),
            //   onPressed: () {
            //     showModalBottomSheet<void>(
            //         context: context,
            //         builder: (BuildContext context) {
            //           return CommentsTypePickerWidget(
            //             commentType: widget.topic.commentType,
            //           );
            //         });
            //   },
            // ),
            IconButton(
                color: Theme.of(context).primaryIconTheme.color,
                icon: Icon(Icons.last_page),
                onPressed: () {
                  // _pageController.jumpToPage(commentsBloc.getPageCount() - 1);
                }),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(40);
}
