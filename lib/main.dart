import 'package:eksi_papyrus/core/AppStrings.dart';
import 'package:eksi_papyrus/core/ui/CenteredTitleAppBar.dart';
import 'package:eksi_papyrus/scenes/channels/networking/ChannelsBloc.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsBloc.dart';
import 'package:eksi_papyrus/scenes/search/networking/SearchResultBloc.dart';
import 'package:eksi_papyrus/scenes/topics/TopicsBloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/Router.dart';
import 'core/styles/AppColors.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final theme = ThemeData(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accent,
      backgroundColor: AppColors.background,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(color: AppColors.background),
      dividerColor: AppColors.listDivider);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            builder: (_) => TopicsBloc([]), key: UniqueKey()),
        ChangeNotifierProvider(builder: (_) => CommentsBloc([], 1)),
        ChangeNotifierProvider(builder: (_) => ChannelsBloc([])),
        ChangeNotifierProvider(builder: (_) => SearchResultBloc([])),
      ],
      child: new MaterialApp(
        title: AppStrings.appName,
        theme: theme,
        home: CenteredTitleAppBar(),
        onGenerateRoute: Router.defineRoutes,
      ),
    );
  }
}
