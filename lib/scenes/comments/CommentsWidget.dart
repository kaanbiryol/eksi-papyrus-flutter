import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsBloc.dart';
import 'CommentsListViewWidget.dart';

class CommentsWidget extends StatelessWidget {
  const CommentsWidget({Key key, @required this.topic}) : super(key: key);

  final Topic topic;

  @override
  Widget build(BuildContext context) {
    print("CommentsWidget BUILT");
    final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.accent,
        title: Text(topic.title));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => CommentsBloc([], 1)),
        ],
        child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: topAppBar,
            body: CommentsListViewWidget(topic: topic)));
  }
}
