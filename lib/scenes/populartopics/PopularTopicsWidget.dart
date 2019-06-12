import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/core/ui/CenteredTitleAppBar.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/main/networking/models/Channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'PopularTopicsNotifier.dart';
import 'networking/models/PopularTopic.dart';

class PopularTopicsListWidget extends StatelessWidget {
  PopularTopicsListWidget({Key key, this.channels}) : super(key: key);

  final List<Channel> channels;

  @override
  Widget build(BuildContext context) {
    var length = channels.length;
    print("REBUILT DefaultTabController");
    return DefaultTabController(
      initialIndex: 0,
      length: length,
      child: Scaffold(
          backgroundColor: AppColors.background,
          appBar: CenteredTitleAppBar(channelList: channels),
          body: TabBarView(children: createPageWidgets(length, context))),
    );
  }

  List<Widget> createPageWidgets(int length, BuildContext context) {
    print("REBUILT createWidgets");
    List<Widget> pageWidgets = [];
    final notifier = Provider.of<PopularTopicsNotifier>(context, listen: false);

    for (int i = 0; i < length; i++) {
      if (notifier.hasTopicsInPage(i)) {
        pageWidgets.add(makeListView(context, i.toString()));
      } else {
        pageWidgets.add(
          makeFutureBuilder(context, channels[i].url, i.toString()),
        );
      }
    }
    return pageWidgets;
  }

  Widget makeFutureBuilder(BuildContext context, String url, String key) {
    print("REBUILT makeFutureBuilder");
    final notifier = Provider.of<PopularTopicsNotifier>(context, listen: false);
    return FutureBuilder(
      key: PageStorageKey<String>(key),
      future: notifier.fetchTopics(url, key),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return makeListView(context, key);
        }
      },
    );
  }

  Widget loadMoreProgress(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget makeListView(BuildContext context, String key) {
    final notifier = Provider.of<PopularTopicsNotifier>(context, listen: false);
    print("REBUILT makeListView");
    print(key);
    var itemList = notifier.getPopularTopics2(key);
    var itemCount = (itemList != null) ? itemList.length : 0;
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            print("SCROLL MAXED");
            loadMore(context);
          }
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
                color: AppColors.listDivider,
              ),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return (index + 1 == itemCount)
                ? loadMoreProgress(context)
                : makeListTile(notifier.getPopularTopics2(key)[index], context);
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

  void loadMore(BuildContext context) {
    print("Load More");
    final notifier = Provider.of<PopularTopicsNotifier>(context, listen: false);
    notifier.setCurrentPage();
  }
}
