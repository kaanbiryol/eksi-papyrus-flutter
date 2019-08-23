import 'package:eksi_papyrus/scenes/comments/networking/models/CommentsRequest.dart';

class TopicsResponse {
  final List<Topic> topics;
  final String currentPage;
  final String pageCount;

  TopicsResponse(this.topics, this.currentPage, this.pageCount);

  factory TopicsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['topics'] as List;
    var currentPage = json['page'].toString();
    var pageCount = json['pageCount'].toString();
    List<Topic> topicList = list.map((i) => Topic.fromJson(i)).toList();
    return TopicsResponse(topicList, currentPage, pageCount);
  }

  Map<String, dynamic> toJson() => {
        'topics': topics,
      };
}

class Topic {
  final String title;
  final String numberOfComments;
  final String url;
  CommentType commentType = CommentType.all;

  Topic(this.title, this.numberOfComments, this.url,
      {this.commentType = CommentType.all});

  Topic.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        numberOfComments = json['numberOfComments'],
        url = json["url"];

  Map<String, dynamic> toJson() => {
        'title': title,
        'numberOfComments': numberOfComments,
        'url': url,
      };
}
