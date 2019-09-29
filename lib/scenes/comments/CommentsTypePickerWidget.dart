import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CommentsFilterBloc extends ChangeNotifier {
  CommentType _commentType;
  int _filteredPage = 0;
  CommentsFilterBloc(this._commentType);

  get commentType => _commentType;
  get filteredPage => _filteredPage;

  void setCommentType(CommentType commentType) {
    if (this._commentType == commentType) {
      return;
    }
    this._commentType = commentType;
    notifyListeners();
  }

  void setFilteredPage(int page) {
    if (page == _filteredPage) {
      return;
    }
    this._filteredPage = page;
    notifyListeners();
  }
}

class CommentsTypePickerWidget extends StatelessWidget {
  const CommentsTypePickerWidget({Key key, this.commentType}) : super(key: key);
  final CommentType commentType;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 180,
        color: AppColors.dark_primaryColor,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: buildCommentTypeButtons(context)));
  }

  List<Widget> buildCommentTypeButtons(BuildContext context) {
    List<Widget> typeButtons = [];

    for (var commentType in CommentType.values) {
      var button = buildCommentTypeButton(context, commentType);
      typeButtons.add(button);
    }

    return typeButtons;
  }

  Widget buildCommentTypeButton(BuildContext context, CommentType commentType) {
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
        final typePickerBloc =
            Provider.of<CommentsFilterBloc>(context, listen: false);
        typePickerBloc.setCommentType(commentType);
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
