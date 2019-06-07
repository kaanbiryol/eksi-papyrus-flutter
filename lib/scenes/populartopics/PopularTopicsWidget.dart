import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
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
        backgroundColor: AppColors.accent,
        title: Text(this.title));
    return Scaffold(
        backgroundColor: AppColors.background,
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
                return ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        color: AppColors.listDivider,
                      ),
                  itemCount: popularTopicsList.getPopularTopics().length,
                  itemBuilder: (BuildContext context, int index) {
                    return makeListTile(
                        popularTopicsList.getPopularTopics()[index], context);
                  },
                );
            }
          },
        ));
  }

  ListTile makeListTile(PopularTopic topic, BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
      leading: Container(
        width: 50,
        padding: EdgeInsets.all(12.0),
        decoration: new BoxDecoration(
          color: AppColors.accent,
          borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
        ),
        child: Text(topic.numberOfComments,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13.0)),
      ),
      title: Text(
        topic.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16.0),
      ),
      onTap: () {
        Navigator.pushNamed(
          context,
          CommentsWidgetRouting.routeToComments,
          arguments: CommentsWidgetRouteArguments(topic),
        );
      },
    );
  }
}
