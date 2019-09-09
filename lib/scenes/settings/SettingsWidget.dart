import 'package:eksi_papyrus/core/styles/AppColors.dart';
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
  List<String> _currentFilters = <String>[];

  @override
  Widget build(BuildContext context) {
    final channelsBloc = Provider.of<ChannelsBloc>(context, listen: false);
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
                channelsBloc.getChannels().length,
                (index) {
                  Channel channel = channelsBloc.getChannels()[index];
                  return FilterChip(
                    label: Text(channel.title),
                    selected: _currentFilters.contains(channel.title),
                    onSelected: (bool value) {
                      setState(() {
                        if (value) {
                          _currentFilters.add(channel.title);
                        } else {
                          _currentFilters.removeWhere((String name) {
                            return name == channel.title;
                          });
                        }
                      });
                    },
                  );
                },
              )),
        ),
      ),
    );
  }
}
