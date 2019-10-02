import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsTypePickerWidget.dart';

class CommentsPagePickerWidget extends StatelessWidget {
  const CommentsPagePickerWidget({Key key, this.pageCount}) : super(key: key);
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      color: Theme.of(context).backgroundColor,
      child: Padding(
          padding: const EdgeInsets.all(16.0), child: makeListView(context)),
    );
  }

  Widget makeListView(BuildContext context) {
    return ListView.builder(
      itemCount: pageCount,
      itemBuilder: (BuildContext context, int index) {
        return buildPageButton(context, index);
      },
    );
  }

  Widget buildPageButton(BuildContext context, int index) {
    return FlatButton(
      textColor: Colors.white,
      child: Text("Page " + (index + 1).toString()),
      onPressed: () {
        final typePickerBloc =
            Provider.of<CommentsFilterBloc>(context, listen: false);
        typePickerBloc.setFilteredPage(index);
        Navigator.of(context).pop();
      },
    );
  }
}
