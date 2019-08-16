import 'package:eksi_papyrus/scenes/populartopics/networking/models/TopicsResponse.dart';

class CommentsWidgetRouteArguments {
  final Topic topic;
  CommentsWidgetRouteArguments(this.topic);
}

class CommentsWidgetRouting {
  static const routeToComments = "/routeToComments";
}
