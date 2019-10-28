import 'package:eksi_papyrus/core/styles/AppThemes.dart';
import 'package:eksi_papyrus/core/utils/ThemeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'ChannelChipWidget.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(elevation: 0.6, title: Text("Settings"));
    final theme = Provider.of<ThemeBloc>(context);
    return MultiProvider(
        providers: [],
        child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: topAppBar,
            body: ListView(children: <Widget>[
              SwitchListTile(
                value: theme.isDarkTheme(),
                title: Text(
                  "Dark Theme",
                  style: Theme.of(context).textTheme.title,
                ),
                onChanged: (bool value) {
                  final theme = Provider.of<ThemeBloc>(context);
                  theme.setTheme(value ? ThemeType.DARK : ThemeType.LIGHT);
                  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
                    systemNavigationBarColor: theme.getTheme().primaryColor,
                    statusBarColor: theme.getTheme().primaryColor,
                  ));
                },
              ),
              Divider(
                height: 1,
              ),
              ChannelChipWidget()
            ])));
  }
}
