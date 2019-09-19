class ChannelsResponse {
  final List<Channel> channels;

  ChannelsResponse(this.channels);

  factory ChannelsResponse.fromJson(Map<String, dynamic> json) {
    var list = json['channels'] as List;
    print(list);
    List<Channel> channelList = list.map((i) => Channel.fromJson(i)).toList();
    return ChannelsResponse(channelList);
  }

  Map<String, dynamic> toJson() => {
        'channels': channels,
      };
}

class Channel {
  final String title;
  final String url;

  Channel(this.title, this.url);

  Channel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        url = json["url"];

  Map<String, dynamic> toJson() => {
        'title': title,
        'url': url,
      };

  bool operator ==(other) {
    return title == other.title;
  }

  @override
  int get hashCode => this.title.hashCode;
}
