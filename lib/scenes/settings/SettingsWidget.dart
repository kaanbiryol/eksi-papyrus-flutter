import 'dart:convert';

import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/core/styles/SharedPreferencesHelper.dart';
import 'package:eksi_papyrus/scenes/channels/networking/ChannelsBloc.dart';
import 'package:eksi_papyrus/scenes/channels/networking/models/ChannelsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final topAppBar = AppBar(elevation: 0.1, title: Text("Settings"));
    return MultiProvider(
        providers: [],
        child: Scaffold(
            backgroundColor: AppColors.background,
            appBar: topAppBar,
            body: ChannelChip()));
  }
}

class ChannelChip extends StatefulWidget {
  @override
  State createState() => ChannelChipState();
}

class ChannelChipState extends State<ChannelChip> {
  List<Channel> userChannels = <Channel>[];
  List<Channel> allChannels = <Channel>[];

  @override
  Widget build(BuildContext context) {
    final channelsBloc = Provider.of<ChannelsBloc>(context, listen: false);
    allChannels = channelsBloc.getChannels();
    return FutureBuilder(
        future: SharedPreferencesHelper.getUserChannels(),
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
                    selected: test(channel),
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          userChannels.add(channel);
                        } else {
                          userChannels.removeWhere((Channel selectedChannel) {
                            return selectedChannel.title == channel.title;
                          });
                        }
                        SharedPreferencesHelper.setUserChannels(userChannels);
                      });
                    },
                  );
                },
              )),
        ),
      ),
    );
  }

//TODO: rename and fix animation bug
  bool test(Channel channel) {
    for (var test in userChannels) {
      if (test.title == channel.title) {
        return true;
      }
    }
    return false;
  }
}
