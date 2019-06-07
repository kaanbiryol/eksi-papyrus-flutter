class PopularTopic {
  final String title;
  final String numberOfComments;
  final String url;

  PopularTopic(this.title, this.numberOfComments, this.url);

  PopularTopic.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        numberOfComments = json['numberOfComments'],
        url = json["url"];

  Map<String, dynamic> toJson() => {
        'title': title,
        'numberOfComments': numberOfComments,
        'url': url,
      };
}
