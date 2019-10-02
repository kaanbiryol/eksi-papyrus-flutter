import 'package:eksi_papyrus/core/utils/HiveUtils.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsListTile.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SavedCommentsWidget extends StatelessWidget {
  const SavedCommentsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(elevation: 0.6, title: Text("Favorites"));
    return MultiProvider(
        providers: [],
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: topAppBar,
            body: buildFutureBuilder()));
  }

  Widget buildFutureBuilder() {
    return FutureBuilder(
      future: HiveUtils.instance.readSavedComments(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final savedComments = snapshot.data as List<Comment>;
            return savedComments.isNotEmpty
                ? SavedCommentsListWidget(
                    commentList: savedComments,
                  )
                : Center(child: Text("Save some comments to see them here."));
          default:
            //TODO: is this the right way?
            return Column();
        }
      },
    );
  }
}

class SavedCommentsListWidget extends StatefulWidget {
  SavedCommentsListWidget({Key key, this.commentList}) : super(key: key);

  final List<Comment> commentList;

  _SavedCommentsListWidgetState createState() =>
      _SavedCommentsListWidgetState();
}

class _SavedCommentsListWidgetState extends State<SavedCommentsListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      key: _listKey,
      initialItemCount: widget.commentList.length,
      itemBuilder: (BuildContext context, int index, Animation animation) {
        return FadeTransition(
          opacity: animation,
          child: _buildItem(index),
        );
      },
    );
  }

  Widget _buildItem(int index) {
    return CommentsListTile(
        comment: widget.commentList[index],
        likeHandler: () {
          deleteItem(index);
        });
  }

  void deleteItem(int index) {
    _listKey.currentState.removeItem(
      index,
      (BuildContext context, Animation<double> animation) {
        return FadeTransition(
          opacity:
              CurvedAnimation(parent: animation, curve: Interval(0.5, 1.0)),
          child: SizeTransition(
            sizeFactor:
                CurvedAnimation(parent: animation, curve: Interval(0.0, 1.0)),
            axisAlignment: 0.0,
            child: _buildItem(index),
          ),
        );
      },
      duration: Duration(milliseconds: 400),
    );
  }
}
