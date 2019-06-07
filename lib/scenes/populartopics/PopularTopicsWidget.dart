import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'PopularTopicsNotifier.dart';
import 'networking/models/PopularTopic.dart';
import 'networking/models/PopularTopicsRequest.dart';

class PopularTopicsListWidget extends StatelessWidget {
  PopularTopicsListWidget({Key key, this.title}) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    final popularTopicsList = Provider.of<PopularTopicsNotifier>(context);
    final topAppBar = AppBar(
        elevation: 0.1,
        backgroundColor: Color.fromRGBO(49, 50, 54, 1.0),
        title: Text(this.title));
    return Scaffold(
        backgroundColor: Color.fromRGBO(32, 33, 37, 1.0),
        appBar: topAppBar,
        body: FutureBuilder(
          future: PopularTopicsRequest().getPopularTopics(1),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
              case ConnectionState.active:
                return Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                popularTopicsList.setPopularTopics(snapshot.data);
                return ListView.builder(
                  itemCount: popularTopicsList.getPopularTopics().length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeListTile(
                        popularTopicsList.getPopularTopics()[index]);
                  },
                );
            }
          },
        ));
  }

  ListTile makeListTile(PopularTopic topic) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      leading: Container(
        padding: EdgeInsets.only(right: 12.0),
        decoration: new BoxDecoration(
            border: new Border(
                right: new BorderSide(width: 1.0, color: Colors.white24))),
        child: Text(topic.numberOfComments,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      title: Text(
        topic.title,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      // onTap: () {
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //           builder: (context) => TopicDetails(popularTopic: topic)));
      // },
    );
  }
}
