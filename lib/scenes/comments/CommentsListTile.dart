import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/core/styles/TextStyles.dart';
import 'package:eksi_papyrus/core/utils/DateUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

import 'networking/models/CommentsResponse.dart';

class CommentsListTile extends StatelessWidget {
  const CommentsListTile({this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: listTile(context),
      onLongPress: () {
        Clipboard.setData(new ClipboardData(text: comment.comment));
      },
    );
  }

  Widget listTile(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: new Wrap(
        runSpacing: 8,
        children: <Widget>[
          new Text(
            comment.ownerUsername +
                " - " +
                DateUtils.timeAgoSinceDate(comment.date),
            style: TextStyles.commentDetails,
          ),
          new MarkdownBody(
              data: comment.comment,
              styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                  .copyWith(
                      p: TextStyles.commentContent,
                      a: TextStyles.commentAccent)),
        ],
      ),
    );
  }
}
