import 'package:eksi_papyrus/scenes/comments/CommentsNotifier.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidget.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsNotifier.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => PopularTopicsNotifier(null)),
        ChangeNotifierProvider(builder: (_) => CommentsNotifier([], 1)),
      ],
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        home: new PopularTopicsListWidget(title: 'Papyrus'),
        routes: {
          CommentsWidgetRouting.routeToComments: (context) => CommentsWidget(),
        },
      ),
    );
  }
}
