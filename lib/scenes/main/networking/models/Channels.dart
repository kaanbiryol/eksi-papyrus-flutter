import 'Channel.dart';

class Channels {
  final List<Channel> channels;

  Channels(this.channels);

  factory Channels.fromJson(Map<String, dynamic> json) {
    var list = json['channels'] as List;
    List<Channel> channelList = list.map((i) => Channel.fromJson(i)).toList();
    return Channels(channelList);
  }

  Map<String, dynamic> toJson() => {
        'channels': channels,
      };
}
