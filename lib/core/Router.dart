import 'package:eksi_papyrus/scenes/comments/CommentsWidget.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/savedComments/SavedCommentsWidget.dart';
import 'package:eksi_papyrus/scenes/settings/SettingsWidget.dart';
import 'package:flutter/material.dart';

class Router {
  static Route defineRoutes(RouteSettings settings) {
    print(settings.name);
    // FIX ME: Extracting args frmo MOdalRoute causes Comments widget to redraw and resend request WHY?
    switch (settings.name) {
      case RoutingKeys.comments:
        final CommentsWidgetRouteArguments args = settings.arguments;
        return MaterialPageRoute(
          builder: (context) {
            return CommentsWidget(topic: args.topic, isQuery: args.isQuery);
          },
        );
      case RoutingKeys.settings:
        return MaterialPageRoute(builder: (context) {
          return SettingsWidget();
        });
      case RoutingKeys.favorites:
        return MaterialPageRoute(builder: (context) {
          return SavedCommentsWidget();
        });
      default:
        //TODO remove this
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}

class RoutingKeys {
  static const settings = "/routeToSettings";
  static const comments = "/routeToComments";
  static const favorites = "/routeToFavorites";
}
