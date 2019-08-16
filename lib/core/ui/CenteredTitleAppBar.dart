import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/core/AppStrings.dart';
import 'package:eksi_papyrus/scenes/channels/networking/ChannelsBloc.dart';
import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsWidget.dart';
import 'package:eksi_papyrus/scenes/search/TopicSearchDelegate.dart';
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
    final channelsBloc = Provider.of<ChannelsBloc>(context, listen: false);
    _tabController =
        TabController(vsync: this, length: channelsBloc.getChannels().length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var channelsBloc = Provider.of<ChannelsBloc>(context);
    if (channelsBloc.getChannels().isEmpty) {
      channelsBloc.fetchChannels();
    }
    _tabController =
        TabController(vsync: this, length: channelsBloc.getChannels().length);

    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: appBar(channelsBloc.getChannels()),
        body: TabBarView(
            controller: _tabController, children: createPageWidgets(context)));
  }

  List<Widget> createPageWidgets(BuildContext context) {
    print("REBUILT createWidgets");
    List<Widget> pageWidgets = [];
    final channelsBloc = Provider.of<ChannelsBloc>(context, listen: false);

    for (int i = 0; i < channelsBloc.getChannels().length; i++) {
      var item = channelsBloc.getChannels()[i];
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
      title: Text(AppStrings.appBarTitle),
      centerTitle: true,
      backgroundColor: AppColors.background,
      bottom: tabsWidget(list),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {
            showSearch(context: context, delegate: TopicSearchDelegate());
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
