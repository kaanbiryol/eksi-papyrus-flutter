import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'CommentsBloc.dart';
import 'CommentsListViewWidget.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({Key key, @required this.topic, this.isQuery})
      : super(key: key);

  final Topic topic;
  final bool isQuery;

  @override
  Widget build(BuildContext context) {
    print("CommentsWidget BUILT" + isQuery.toString());
    final topAppBar = AppBar(elevation: 0.1, title: Text(topic.title));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => CommentsBloc([], 1)),
        ],
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: topAppBar,
            body: CommentsListViewWidget(topic: topic, isQuery: isQuery)));
  }
}
