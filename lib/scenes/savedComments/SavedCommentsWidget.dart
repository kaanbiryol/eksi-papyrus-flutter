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
    final topAppBar = AppBar(elevation: 0.1, title: Text("Favorites"));
    return MultiProvider(
        providers: [],
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: topAppBar,
            body: makeListView()));
  }

  Widget test(BuildContext context, List<Comment> commentList) {
    return ListView.separated(
      separatorBuilder: (context, index) => Divider(),
      itemCount: commentList.length,
      itemBuilder: (BuildContext context, int index) {
        return CommentsListTile(
          comment: commentList[index],
        );
      },
    );
  }

  Widget makeListView() {
    return FutureBuilder(
      future: HiveUtils.instance.readSavedComments(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            final searchResults = snapshot.data as List<Comment>;
            return test(context, searchResults);
          default:
            //TODO: is this the right way?
            return Column();
        }
      },
    );
  }
}
