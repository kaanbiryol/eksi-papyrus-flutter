import 'package:async/async.dart';
import 'package:eksi_papyrus/core/utils/SharedPreferencesUtils.dart';
import 'package:eksi_papyrus/scenes/channels/networking/ChannelsBloc.dart';
import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class ChannelChipWidget extends StatefulWidget {
  @override
  State createState() => ChannelChipWidgetState();
}

class ChannelChipWidgetState extends State<ChannelChipWidget> {
  List<Channel> userChannels = <Channel>[];
  List<Channel> allChannels = <Channel>[];
  final userChannelsMemoizer = new AsyncMemoizer();
  @override
  Widget build(BuildContext context) {
    final channelsBloc = Provider.of<ChannelsBloc>(context, listen: false);
    allChannels = channelsBloc.getChannels();
    return FutureBuilder(
        future: _fetchData(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              userChannels = snapshot.data;
              print("USER Channels " + userChannels.toString());
              return chipWidget(context);
            default:
              return Text("KAAN");
          }
        });
  }

  _fetchData() {
    return userChannelsMemoizer.runOnce(() async {
      return SharedPreferencesUtils.getUserChannels();
    });
  }

  Widget chipWidget(BuildContext context) {
    return Container(
      height: 200,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Wrap(
              spacing: 8,
              verticalDirection: VerticalDirection.down,
              direction: Axis.horizontal,
              runAlignment: WrapAlignment.center,
              children: List.generate(
                allChannels.length,
                (index) {
                  Channel channel = allChannels[index];
                  return FilterChip(
                    label: Text(channel.title),
                    selected: isUserChannel(channel),
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          userChannels.add(channel);
                        } else {
                          userChannels.removeWhere((Channel selectedChannel) {
                            return selectedChannel.title == channel.title;
                          });
                        }
                        final channelsBloc =
                            Provider.of<ChannelsBloc>(context, listen: false);
                        channelsBloc.updateUserChannels(userChannels);
                      });
                    },
                  );
                },
              )),
        ),
      ),
    );
  }

  bool isUserChannel(Channel channel) {
    for (var userChannel in userChannels) {
      if (userChannel.title == channel.title) {
        return true;
      }
    }
    return false;
  }
}
