import 'package:flutter/foundation.dart';
import 'models/ChannelRequest.dart';
import 'models/ChannelsResponse.dart';

class ChannelsBloc with ChangeNotifier {
  List<Channel> _channels = [];

  ChannelsBloc(this._channels);

  List<Channel> getChannels() {
    return _channels;
  }

  Future<ChannelsResponse> fetchChannels() {
    return ChannelsRequest().getChannels().then((response) {
      _channels = response.channels;
      notifyListeners();
      return response;
    });
  }
}
