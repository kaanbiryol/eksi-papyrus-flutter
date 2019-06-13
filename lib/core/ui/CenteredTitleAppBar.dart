import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/main/ChannelsNotifier.dart';
import 'package:eksi_papyrus/scenes/main/networking/models/Channel.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsWidget.dart';
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
      leading: IconButton(icon: Icon(Icons.search)),
      title: Text("Papyrus"),
      centerTitle: true,
      backgroundColor: AppColors.background,
      bottom: tabsWidget(list),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
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
