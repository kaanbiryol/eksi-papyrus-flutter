import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/core/styles/AppThemes.dart';
import 'package:eksi_papyrus/core/styles/TextStyles.dart';
import 'package:eksi_papyrus/core/utils/ThemeUtils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'ChannelChipWidget.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(elevation: 0.1, title: Text("Settings"));
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
                  style: TextStyles.commentContent,
                ),
                onChanged: (bool value) {
                  final theme = Provider.of<ThemeBloc>(context);
                  theme.setTheme(value ? ThemeType.DARK : ThemeType.LIGHT);
                },
              ),
              ChannelChipWidget()
            ])));
  }
}
