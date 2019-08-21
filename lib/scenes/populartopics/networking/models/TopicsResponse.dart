class TopicsResponse {
  final List<Topic> topics;

  TopicsResponse(this.topics);

  factory TopicsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['topics'] as List;
    List<Topic> topicList = list.map((i) => Topic.fromJson(i)).toList();
    return TopicsResponse(topicList);
  }

  Map<String, dynamic> toJson() => {
        'topics': topics,
      };
}

class Topic {
  final String title;
  final String numberOfComments;
  final String url;

  Topic(this.title, this.numberOfComments, this.url);

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
