import 'package:eksi_papyrus/scenes/populartopics/networking/models/PopularTopic.dart';

class CommentsWidgetRouteArguments {
  final PopularTopic topic;
  CommentsWidgetRouteArguments(this.topic);
}

class CommentsWidgetRouting {
  static const routeToComments = "/routeToComments";
}
