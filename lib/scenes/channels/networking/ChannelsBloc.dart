import 'package:eksi_papyrus/core/utils/SharedPreferencesUtils.dart';
import 'package:flutter/foundation.dart';
import 'models/ChannelRequest.dart';
import 'models/ChannelsResponse.dart';

class ChannelsBloc with ChangeNotifier {
  List<Channel> _channels = [];
  List<Channel> _userChannels = [];

  ChannelsBloc(this._userChannels);

  List<Channel> getChannels() => _channels.where((channel) {
        return channel.title != "gündem";
      }).toList();
  List<Channel> getUserChannels() => _userChannels;

  void updateUserChannels(List<Channel> channels) {
    SharedPreferencesUtils.setUserChannels(channels);
    _userChannels = channels;
    notifyListeners();
  }

  Future<List<Channel>> fetchUserChannels() async {
    return ChannelsRequest().getChannels().then((response) {
      _channels = response.channels;
      if (_userChannels.isEmpty) {
        _userChannels = _channels;
        setUserChannels();
        notifyListeners();
      }
      return _userChannels;
    });
  }

  Future<void> setUserChannels() async {
    List<Channel> savedChannels =
        await SharedPreferencesUtils.getUserChannels();
    if (savedChannels.isEmpty) {
      savedChannels = _channels;
      _userChannels = savedChannels;
      SharedPreferencesUtils.setUserChannels(savedChannels);
    } else {
      //TODO: Case 1: User selected all of them but a channel has been deleted
      _userChannels = savedChannels;
    }
  }
}
