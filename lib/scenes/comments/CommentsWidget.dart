import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsListViewWidget.dart';
import 'CommentsNotifier.dart';

class CommentsWidget extends StatelessWidget {
  CommentsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("CommentsWidget BUILT");
    final CommentsWidgetRouteArguments args =
        ModalRoute.of(context).settings.arguments;
    var topic = args.topic;
    final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: AppColors.accent,
        title: Text(topic.title));
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(builder: (_) => CommentsNotifier([], 1)),
        ],
        child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: topAppBar,
            body: CommentsListViewWidget(topic: topic)));
  }
}
