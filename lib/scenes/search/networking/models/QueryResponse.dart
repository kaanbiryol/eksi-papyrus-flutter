class QueryResponse {
  final String topicUrl;

  QueryResponse(this.topicUrl);

  QueryResponse.fromJson(Map<String, dynamic> json)
      : topicUrl = json['topicUrl'];

  Map<String, dynamic> toJson() => {
        'topicUrl': topicUrl,
      };
}
