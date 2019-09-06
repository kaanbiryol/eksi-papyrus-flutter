import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'networking/models/CommentsResponse.dart';

class TextStyles {
  static TextStyle commentContent() {
    return TextStyle(
        color: Colors.red, fontFamily: "Noto", fontWeight: FontWeight.bold);
  }
}

class CommentsListTile extends StatelessWidget {
  const CommentsListTile({this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text(
            comment.ownerUsername,
            style: TextStyles.commentContent(),
          ),
          new Text(comment.comment)
        ],
      ),
    );
  }
}
