import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/main/ChannelsNotifier.dart';
import 'package:eksi_papyrus/scenes/main/networking/models/Channels.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsWidget.dart';
import 'package:eksi_papyrus/scenes/search/models/SearchResult.dart';
import 'package:eksi_papyrus/scenes/search/models/SearchResultNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CenteredTitleAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  CenteredTitleAppBar({Key key}) : super(key: key);

  @override
  _CenteredTitleAppBarState createState() => _CenteredTitleAppBarState();

  @override
  Size get preferredSize => new Size.fromHeight(100.0);
}

class _CenteredTitleAppBarState extends State<CenteredTitleAppBar>
    with TickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    print("INİT STATE");
    final notifier = Provider.of<ChannelsNotifier>(context, listen: false);
    _tabController =
        TabController(vsync: this, length: notifier.getChannels().length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var notifier = Provider.of<ChannelsNotifier>(context);
    if (!notifier.test) {
      notifier.fetchChannels();
    }
    _tabController =
        TabController(vsync: this, length: notifier.getChannels().length);

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar(notifier.getChannels()),
        body: TabBarView(
            controller: _tabController, children: createPageWidgets(context)));
  }

  List<Widget> createPageWidgets(BuildContext context) {
    print("REBUILT createWidgets");
    List<Widget> pageWidgets = [];
    final notifier = Provider.of<ChannelsNotifier>(context, listen: false);

    for (int i = 0; i < notifier.getChannels().length; i++) {
      var item = notifier.getChannels()[i];
      pageWidgets.add(PopularTopicsListWidget(
        key: ValueKey(item.title),
        channelUrl: item.url,
      ));
    }
    return pageWidgets;
  }

  Widget appBar(List<Channel> list) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.settings),
        onPressed: () {
          //TODO: implement onpressed
        },
      ),
      title: Text("Papyrus"),
      centerTitle: true,
      backgroundColor: AppColors.background,
      bottom: tabsWidget(list),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: CustomSearchDelegate());
          },
        ),
      ],
    );
  }

  Widget tabsWidget(List<Channel> list) {
    return CustomCrossFade(channelList: list, tabController: _tabController);
  }
}

class CustomCrossFade extends StatelessWidget implements PreferredSizeWidget {
  CustomCrossFade({Key key, this.channelList, this.tabController})
      : super(key: key);

  final List<Channel> channelList;
  final TabController tabController;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: new Container(
        child: new TabBar(
          controller: tabController,
          isScrollable: true,
          tabs: buildTabs(),
        ),
      ),
      secondChild: new Container(),
      crossFadeState: CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 300),
    );
  }

  List<Widget> buildTabs() {
    List<Widget> tabs = [];
    channelList.forEach((item) {
      tabs.add(Tab(
        text: item.title,
      ));
    });

    return tabs;
  }

  @override
  Size get preferredSize => new Size.fromHeight(40);
}

class CustomSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        Text("test")
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    return makeFutureBuilder(context);
  }
}

Widget makeFutureBuilder(BuildContext context) {
  print("FutureBuilder BUILT");
  final notifier = Provider.of<SearchResultNotifier>(context, listen: false);
  return FutureBuilder(
    future: notifier.queryResults("d"),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
          return Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          final searchResults = snapshot.data as SearchQueryResponse;
          return makeListView(context, searchResults);
        default:
          //TODO: is this the right way?
          return Column();
      }
    },
  );
}

Widget makeListView(BuildContext context, SearchQueryResponse response) {
  var itemList = response.titles;
  var itemCount = (itemList != null) ? itemList.length : 0;
  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: AppColors.listDivider,
    ),
    itemCount: itemCount,
    itemBuilder: (BuildContext context, int index) {
      return makeListTile(itemList[index], context);
    },
  );
}

ListTile makeListTile(String title, BuildContext context) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
    title: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16.0),
    ),
    onTap: () {
      // Navigator.pushNamed(
      //   context,
      //   CommentsWidgetRouting.routeToComments,
      //   arguments: CommentsWidgetRouteArguments(topic),
      // );
    },
  );
}
