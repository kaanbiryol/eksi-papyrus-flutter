import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/core/AppStrings.dart';
import 'package:eksi_papyrus/core/ui/CenteredTitleAppBar.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsNotifier.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidget.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/main/ChannelsNotifier.dart';
import 'package:eksi_papyrus/scenes/populartopics/PopularTopicsNotifier.dart';
import 'package:eksi_papyrus/scenes/search/models/SearchResultNotifier.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  final theme = ThemeData(
      primaryColor: AppColors.primaryColor,
      accentColor: AppColors.accent,
      backgroundColor: AppColors.background);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            builder: (_) => PopularTopicsNotifier([]), key: UniqueKey()),
        ChangeNotifierProvider(builder: (_) => CommentsNotifier([], 1)),
        ChangeNotifierProvider(builder: (_) => ChannelsNotifier([])),
        ChangeNotifierProvider(builder: (_) => SearchResultNotifier([])),
      ],
      child: new MaterialApp(
        title: AppStrings.appName,
        theme: theme,
        home: CenteredTitleAppBar(),
        onGenerateRoute: (settings) {
          print(settings.name);
          // FIX ME: Extracting args frmo MOdalRoute causes Comments widget to redraw and resend request WHY?
          switch (settings.name) {
            case CommentsWidgetRouting.routeToComments:
              final CommentsWidgetRouteArguments args = settings.arguments;
              return MaterialPageRoute(
                builder: (context) {
                  return CommentsWidget(
                    topic: args.topic,
                  );
                },
              );
              break;
            default:
          }
        },
      ),
    );
  }
}
