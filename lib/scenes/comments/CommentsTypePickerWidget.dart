import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//TODO: wants to make final
class CommentsTypePickerWidget extends StatefulWidget {
  CommentType commentType;
  CommentsTypePickerWidget({Key key, this.commentType}) : super(key: key);
  _CommentsTypePickerWidgetState createState() =>
      _CommentsTypePickerWidgetState();
}

class _CommentsTypePickerWidgetState extends State<CommentsTypePickerWidget> {
  CommentType commentType;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        color: AppColors.dark_primaryColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildCommentTypeButtons()));
  }

  List<Widget> buildCommentTypeButtons() {
    List<Widget> typeButtons = [];

    for (var commentType in CommentType.values) {
      var button = buildCommentTypeButton(commentType);
      typeButtons.add(button);
    }

    return typeButtons;
  }

  Widget buildCommentTypeButton(CommentType commentType) {
    return FlatButton(
      textColor: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              IconButton(
                icon: Icon(makeCommentTypeIcon(commentType)),
                onPressed: null,
              ),
              Text(makeCommentTypeTitle(commentType)),
            ],
          ),
          Visibility(
            visible: isTypeSelected(commentType),
            child: Checkbox(
              checkColor: Colors.red,
              activeColor: Colors.transparent,
              onChanged: (bool value) {},
              value: isTypeSelected(commentType),
            ),
          )
        ],
      ),
      onPressed: () {
        setState(() {
          widget.commentType = commentType;
          Navigator.of(context).pop();
        });
      },
    );
  }

  bool isTypeSelected(CommentType commentType) {
    return commentType == widget.commentType;
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

  String makeCommentTypeTitle(CommentType commentType) {
    switch (commentType) {
      case CommentType.all:
        return "Hepsi";
      case CommentType.popular:
        return "Popüler";
      case CommentType.today:
        return "Bugün";
      default:
        return "";
    }
  }
}
