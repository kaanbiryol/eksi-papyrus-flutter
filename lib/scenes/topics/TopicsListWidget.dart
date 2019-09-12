import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/core/styles/TextStyles.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'TopicsBloc.dart';
import 'networking/models/TopicsResponse.dart';

class TopicsListWidget extends StatefulWidget {
  TopicsListWidget({Key key, this.channelUrl}) : super(key: key);

  final String channelUrl;

  @override
  _TopicsListWidgetState createState() => _TopicsListWidgetState();
}

class _TopicsListWidgetState extends State<TopicsListWidget>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    print("REBUILT DefaultTabController");
    return decideWidget(context);
  }

  Widget decideWidget(BuildContext context) {
    print("REBUILT createWidgets");
    final notifier = Provider.of<TopicsBloc>(context, listen: false);
    if (notifier.hasTopicsInPage(widget.key)) {
      return makeListView(context);
    } else {
      return makeFutureBuilder(context);
    }
  }

  Widget makeFutureBuilder(BuildContext context) {
    print("REBUILT makeFutureBuilder");
    ValueKey key = widget.key;
    final notifier = Provider.of<TopicsBloc>(context, listen: false);
    return FutureBuilder(
      key: PageStorageKey<String>(key.value),
      future: notifier.fetchTopics(widget.channelUrl, key, CommentType.today),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
          case ConnectionState.done:
            return makeListView(context);
        }
      },
    );
  }

  Widget loadMoreProgress(BuildContext context) {
    return Center(child: CircularProgressIndicator());
  }

  Widget makeListView(BuildContext context) {
    final notifier = Provider.of<TopicsBloc>(context, listen: false);
    print("REBUILT makeListView");
    var key = widget.key;
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
          separatorBuilder: (context, index) => Divider(),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return (index + 1 == itemCount)
                ? loadMoreProgress(context)
                : makeListTile(notifier.getPopularTopics2(key)[index], context);
          },
        ));
  }

  ListTile makeListTile(Topic topic, BuildContext context) {
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
      title: Text(topic.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.title),
      onTap: () {
        Navigator.pushNamed(
          context,
          CommentsWidgetRouting.routeToComments,
          arguments: CommentsWidgetRouteArguments(topic, false),
        );
      },
    );
  }

  void loadMore(BuildContext context) {
    print("Load More");
    final notifier = Provider.of<TopicsBloc>(context, listen: false);
    notifier.fetchTopics(widget.channelUrl, widget.key, CommentType.today);
  }

  @override
  bool get wantKeepAlive => true;
}
