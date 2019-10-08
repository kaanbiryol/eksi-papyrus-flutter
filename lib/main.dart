import 'package:eksi_papyrus/core/AppStrings.dart';
import 'package:eksi_papyrus/core/styles/AppThemes.dart';
import 'package:eksi_papyrus/core/ui/CenteredTitleAppBar.dart';
import 'package:eksi_papyrus/core/utils/HiveUtils.dart';
import 'package:eksi_papyrus/scenes/channels/networking/ChannelsBloc.dart';
import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsBloc.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsListViewWidget.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsTypePickerWidget.dart';
import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';
import 'package:eksi_papyrus/scenes/search/networking/SearchResultBloc.dart';
import 'package:eksi_papyrus/scenes/topics/TopicsBloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'core/Router.dart';
import 'core/utils/SharedPreferencesUtils.dart';
import 'core/utils/ThemeUtils.dart';

void main() async {
  ThemeType themeType = await SharedPreferencesUtils.getCurrentTheme();
  List<Channel> userChannels = await SharedPreferencesUtils.getUserChannels();
  HiveUtils.instance.registerAdapters();
  runApp(new MyApp(themeType, userChannels));
}

class MyApp extends StatefulWidget {
  MyApp(this.themeType, this.userChannels);

  final ThemeType themeType;
  final List<Channel> userChannels;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        //TODO: put notifiers to corresponding widgets
        ChangeNotifierProvider(
            builder: (_) => TopicsBloc([]), key: UniqueKey()),
        ChangeNotifierProvider(builder: (_) => CommentsBloc([], 1)),
        ChangeNotifierProvider(
            builder: (_) => ChannelsBloc(widget.userChannels)),
        ChangeNotifierProvider(builder: (_) => SearchResultBloc([])),
        ChangeNotifierProvider(builder: (_) => ThemeBloc(widget.themeType)),
        ChangeNotifierProvider(
            builder: (_) => CommentsFilterBloc(CommentType.all)),
        ChangeNotifierProvider(builder: (_) => ScrollPageNotifier(1)),
      ],
      child: ThemedMaterialApp(),
    );
  }
}

class ThemedMaterialApp extends StatelessWidget {
  const ThemedMaterialApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Provider.of<ThemeBloc>(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: theme.getTheme().primaryColor,
      statusBarColor: theme.getTheme().primaryColor,
    ));
    return new MaterialApp(
      title: AppStrings.appName,
      theme: theme.getTheme(),
      home: CenteredTitleAppBar(),
      onGenerateRoute: Router.defineRoutes,
    );
  }
}
