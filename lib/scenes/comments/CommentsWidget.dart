import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/Comment.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CommentsNotifier.dart';

class CommentsWidget extends StatelessWidget {
  CommentsWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final commentsList = Provider.of<CommentsNotifier>(context);
    final topAppBar = AppBar(
        elevation: 0.1, backgroundColor: AppColors.accent, title: Text("TEST"));
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: topAppBar,
        body: FutureBuilder(
          future: CommentsRequest().getComments(
              "http://eksisozluk.com/geceye-bir-sarki-birak--5086776", 1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                commentsList.setCommentList(snapshot.data);
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: AppColors.listDivider,
                      ),
                  itemCount: commentsList.getCommentList().length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeListTile(
                        commentsList.getCommentList()[index], context);
                  },
                );
            }
          },
        ));
  }

  ListTile makeListTile(Comment comment, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      title: MarkdownBody(
        data: comment.comment,
        onTapLink: (url) {
          launch(url);
        },
      ),
    );
  }
}
