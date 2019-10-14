import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

//TODO: move this
typedef IntCallback = void Function(int);

class CommentsPagePickerWidget extends StatelessWidget {
  const CommentsPagePickerWidget({Key key, this.pageCount, this.onPageSelected})
      : super(key: key);
  final int pageCount;
  final IntCallback onPageSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Container(
        height: 300,
        color: Theme.of(context).backgroundColor,
        child: Padding(
            padding: const EdgeInsets.all(16.0), child: makeListView(context)),
      ),
    );
  }

  Widget makeListView(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) {
        return Divider(height: 1);
      },
      itemCount: pageCount,
      itemBuilder: (BuildContext context, int index) {
        return buildPageButton(context, index);
      },
    );
  }

  Widget buildPageButton(BuildContext context, int index) {
    return FlatButton(
      textColor: Theme.of(context).primaryTextTheme.title.color,
      child: Text("Page " + (index + 1).toString()),
      onPressed: () {
        onPageSelected(index);
        Navigator.of(context).pop();
      },
    );
  }
}
