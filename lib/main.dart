import 'package:eksi_papyrus/scenes/comments/CommentsNetworking.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsNotifier.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsWidget.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopic.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/Comment.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (_) => PopularTopicsNotifier(null)),
      ],
      child: new MaterialApp(
        title: 'Flutter Demo',
        theme: new ThemeData(primaryColor: Color.fromRGBO(58, 66, 86, 1.0)),
        home: new PopularTopicsListWidget(title: 'Papyrus'),
      ),
    );
  }
}

class TopicDetails extends StatelessWidget {
  PopularTopic popularTopic;

  TopicDetails({Key key, @required this.popularTopic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: new CommentListPage(topic: popularTopic),
    );
  }
}

class CommentListPage extends StatefulWidget {
  CommentListPage({Key key, this.topic}) : super(key: key);

  final PopularTopic topic;

  @override
  _CommentListPageState createState() => _CommentListPageState();
}

class _CommentListPageState extends State<CommentListPage> {
  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(49, 50, 54, 1.0),
        title: Text("TEST"));
    return Scaffold(
        backgroundColor: Color.fromRGBO(32, 33, 37, 1.0),
        appBar: topAppBar,
        body: FutureBuilder(
          future: CommentsNetworking().getComments(
              "http://eksisozluk.com/geceye-bir-sarki-birak--5086776", 1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                print(snapshot);
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeListTile(snapshot.data[index]);
                  },
                );
            }
          },
        ));
  }

  ListTile makeListTile(Comment comment) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(
        comment.comment,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}
