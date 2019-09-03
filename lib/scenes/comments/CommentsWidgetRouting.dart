import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';

class CommentsWidgetRouteArguments {
  final Topic topic;
  bool isQuery = false;
  CommentsWidgetRouteArguments(this.topic, this.isQuery);
}

class CommentsWidgetRouting {
  static const routeToComments = "/routeToComments";
}
