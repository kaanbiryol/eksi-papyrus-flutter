import 'package:eksi_papyrus/scenes/comments/CommentsWidget.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:flutter/material.dart';

class Router {
  static Route defineRoutes(RouteSettings settings) {
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
        //TODO remove this
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                      child: Text('No route defined for ${settings.name}')),
                ));
    }
  }
}
