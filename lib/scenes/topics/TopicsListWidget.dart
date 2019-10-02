import 'package:eksi_papyrus/core/Router.dart';
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 16.0, 0, 0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget makeListView(BuildContext context) {
    final notifier = Provider.of<TopicsBloc>(context);
    print("REBUILT makeListView");
    var key = widget.key;
    var itemList = notifier.getPopularTopics2(key);
    var canPaginate = notifier.canPaginate(key);
    var itemCount = calculateItemlistCount(itemList, canPaginate);
    return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo is ScrollEndNotification &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              canPaginate) {
            print("SCROLL MAXED");
            loadMore(context);
          }
        },
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(height: 1),
          itemCount: itemCount,
          itemBuilder: (BuildContext context, int index) {
            return (index + 1 == itemCount && canPaginate)
                ? loadMoreProgress(context)
                : makeListTile(notifier.getPopularTopics2(key)[index], context);
          },
        ));
  }

  int calculateItemlistCount(List<Topic> topicList, bool canPaginate) {
    if (topicList != null) {
      if (canPaginate) {
        return topicList.length + 1;
      } else {
        return topicList.length;
      }
    } else {
      return 0;
    }
  }

  Widget makeListTile(Topic topic, BuildContext context) {
    return AnimatedContainer(
      padding: EdgeInsets.all(4.0),
      duration: Duration(),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(
            context,
            RoutingKeys.comments,
            arguments: CommentsWidgetRouteArguments(topic, false),
          );
        },
        child: Padding(
          padding: EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 4.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 52,
                padding: EdgeInsets.fromLTRB(12, 10, 12, 10),
                decoration: new BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: new BorderRadius.all(new Radius.circular(4.0)),
                ),
                child: Text(topic.numberOfComments,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.0)),
              ),
              Container(
                width: 16.0,
              ),
              Flexible(
                flex: 1,
                child: Text(topic.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.title),
              ),
            ],
          ),
        ),
      ),
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
