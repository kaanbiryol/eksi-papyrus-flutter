import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/main/ChannelsNotifier.dart';
import 'package:eksi_papyrus/scenes/main/networking/models/Channel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class CenteredTitleAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  CenteredTitleAppBar({Key key, @required this.channelList}) : super(key: key);

  final List<Channel> channelList;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(icon: Icon(Icons.search)),
      title: Text("Papyrus"),
      centerTitle: true,
      backgroundColor: AppColors.accent,
      bottom: tabsWidget(),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.settings),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget tabsWidget() {
    return CustomCrossFade(channelList: channelList);
  }

  @override
  Size get preferredSize => new Size.fromHeight(100.0);
}

class CustomCrossFade extends StatelessWidget implements PreferredSizeWidget {
  CustomCrossFade({Key key, this.channelList}) : super(key: key);

  final List<Channel> channelList;

  @override
  Widget build(BuildContext context) {
    return AnimatedCrossFade(
      firstChild: new Container(
        child: new TabBar(
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
