import 'package:eksi_papyrus/core/AppStrings.dart';
import 'package:eksi_papyrus/core/Router.dart';
import 'package:eksi_papyrus/scenes/channels/networking/ChannelsBloc.dart';
import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:eksi_papyrus/scenes/search/TopicSearchDelegate.dart';
import 'package:eksi_papyrus/scenes/topics/TopicsListWidget.dart';
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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("Built state");
    //TODO: might move this to init state?
    var channelsBloc = Provider.of<ChannelsBloc>(context, listen: true);
    var userChannels = channelsBloc.getUserChannels();
    _tabController = TabController(
        vsync: this, length: channelsBloc.getUserChannels().length);
    if (userChannels.isEmpty) {
      channelsBloc.fetchUserChannels();
    }
    return Scaffold(
        appBar: appBar(channelsBloc.getUserChannels()),
        body: TabBarView(
            controller: _tabController, children: createPageWidgets(context)));
  }

  List<Widget> createPageWidgets(BuildContext context) {
    print("REBUILT createPageWidgets");
    List<Widget> pageWidgets = [];
    final channelsBloc = Provider.of<ChannelsBloc>(context, listen: false);
    for (int i = 0; i < channelsBloc.getUserChannels().length; i++) {
      var item = channelsBloc.getUserChannels()[i];
      pageWidgets.add(TopicsListWidget(
        key: ValueKey(item.title),
        channelUrl: item.url,
      ));
    }
    return pageWidgets;
  }

  Widget appBar(List<Channel> list) {
    return AppBar(
      elevation: 0.6,
      leading: IconButton(
        color: Theme.of(context).primaryIconTheme.color,
        icon: Icon(Icons.search),
        onPressed: () {
          showSearch(context: context, delegate: TopicSearchDelegate());
        },
      ),
      title: Text(
        AppStrings.appBarTitle,
        style: Theme.of(context).textTheme.headline,
      ),
      centerTitle: true,
      bottom: tabsWidget(list),
      actions: <Widget>[
        IconButton(
          color: Theme.of(context).primaryIconTheme.color,
          icon: Icon(Icons.favorite),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutingKeys.favorites,
            );
          },
        ),
        IconButton(
          color: Theme.of(context).primaryIconTheme.color,
          icon: Icon(Icons.settings),
          onPressed: () {
            Navigator.pushNamed(
              context,
              RoutingKeys.settings,
            );
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
    return AnimatedContainer(
      duration: Duration(milliseconds: 240),
      height: channelList.isEmpty ? 4 : 40,
      child: channelList.isEmpty
          ? AppBarLinearProgressIndicator()
          : AnimatedCrossFade(
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
            ),
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

class AppBarLinearProgressIndicator extends StatelessWidget
    implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      child: LinearProgressIndicator(
        backgroundColor: Theme.of(context).backgroundColor,
        valueColor:
            AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor),
        value: null,
      ),
      duration: Duration(seconds: 2),
    );
  }

  @override
  Size get preferredSize => new Size.fromHeight(4);
}
