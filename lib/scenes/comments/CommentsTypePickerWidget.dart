import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

typedef CommentTypeCallback = void Function(CommentType);

class CommentsTypePickerWidget extends StatelessWidget {
  const CommentsTypePickerWidget({Key key, this.commentType, this.typeCallback})
      : super(key: key);
  final CommentType commentType;
  final CommentTypeCallback typeCallback;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
            height: 180,
            color: Theme.of(context).backgroundColor,
            child: buildCommentTypeButtons(context)));
  }

  Widget buildCommentTypeButtons(BuildContext context) {
    List<CommentType> commentTypes = CommentType.values;
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(height: 1);
      },
      itemCount: commentTypes.length,
      itemBuilder: (BuildContext context, int index) {
        return buildCommentTypeButton(context, commentTypes[index]);
      },
    );
  }

  Widget buildCommentTypeButton(BuildContext context, CommentType commentType) {
    var selected = isTypeSelected(commentType);
    return FlatButton(
      textColor: selected
          ? Theme.of(context).primaryIconTheme.color
          : Theme.of(context).accentColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                disabledColor: selected
                    ? Theme.of(context).primaryIconTheme.color
                    : Theme.of(context).accentColor,
                icon: Icon(makeCommentTypeIcon(commentType)),
                onPressed: null,
              ),
              Text(makeCommentTypeTitle(commentType)),
            ],
          ),
          Visibility(
            visible: selected,
            child: Checkbox(
              checkColor: Theme.of(context).accentIconTheme.color,
              activeColor: Colors.transparent,
              onChanged: (bool value) {},
              value: selected,
            ),
          )
        ],
      ),
      onPressed: () {
        typeCallback(commentType);
        Navigator.of(context).pop();
      },
    );
  }

  bool isTypeSelected(CommentType commentType) {
    return commentType == this.commentType;
  }

  IconData makeCommentTypeIcon(CommentType commentType) {
    switch (commentType) {
      case CommentType.all:
        return Icons.all_inclusive;
      case CommentType.popular:
        return Icons.people_outline;
      case CommentType.today:
        return Icons.today;
      default:
        return Icons.error;
    }
  }
}
