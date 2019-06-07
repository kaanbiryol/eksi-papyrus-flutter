import 'PopularTopic.dart';

class PopularTopics {
  final List<PopularTopic> popularTopics;

  PopularTopics(this.popularTopics);

  factory PopularTopics.fromJson(Map<String, dynamic> json) {
    var list = json['popularTopics'] as List;
    List<PopularTopic> popularTopicList =
        list.map((i) => PopularTopic.fromJson(i)).toList();
    return PopularTopics(popularTopicList);
  }

  Map<String, dynamic> toJson() => {
        'popularTopics': popularTopics,
      };
}
