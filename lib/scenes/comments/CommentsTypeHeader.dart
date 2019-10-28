import 'package:flutter/material.dart';

import 'CommentsTypePickerWidget.dart';
import 'networking/models/CommentsRequest.dart';

class CommentsTypeHeader extends StatelessWidget {
  const CommentsTypeHeader({Key key, this.onTypeChanged, this.commentType})
      : super(key: key);
  final CommentTypeCallback onTypeChanged;
  final CommentType commentType;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: Theme.of(context).dialogBackgroundColor,
      child: FlatButton(
        padding: EdgeInsets.fromLTRB(16, 8, 0, 8),
        color: Colors.transparent,
        textColor: Theme.of(context).textTheme.subtitle.color,
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Icon(
                Icons.sort,
                color: Theme.of(context).accentColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                makeCommentTypeTitle(commentType),
                style: Theme.of(context).textTheme.subtitle,
              ),
            ),
          ],
        ),
        onPressed: () {
          showModalBottomSheet<void>(
              context: context,
              backgroundColor: Theme.of(context).dialogBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8.0),
                    topRight: Radius.circular(8.0)),
              ),
              builder: (BuildContext context) {
                return CommentsTypePickerWidget(
                  commentType: commentType,
                  typeCallback: onTypeChanged,
                );
              });
        },
      ),
    );
  }
}
