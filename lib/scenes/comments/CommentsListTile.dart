import 'package:eksi_papyrus/core/Router.dart';
import 'package:eksi_papyrus/core/styles/TextStyles.dart';
import 'package:eksi_papyrus/core/utils/DateUtils.dart';
import 'package:eksi_papyrus/core/utils/HiveUtils.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'CommentsWidgetRouting.dart';
import 'networking/models/CommentsResponse.dart';

class CommentsListTile extends StatelessWidget {
  const CommentsListTile({this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: listTile(context),
      onLongPress: () {
        //TODO: find the equivalent ux in ios
        Fluttertoast.showToast(
            msg: "Entry copied to clipboard.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            fontSize: 16.0);
        Clipboard.setData(new ClipboardData(text: comment.comment));
      },
    );
  }

  Widget listTile(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
      child: new Wrap(
        runSpacing: 0,
        children: <Widget>[
          new Text(
            comment.ownerUsername +
                " - " +
                DateUtils.timeAgoSinceDate(comment.date),
            style: Theme.of(context).textTheme.subtitle,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 3.0),
            child: new MarkdownBody(
                data: comment.comment,
                styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                    .copyWith(
                        p: Theme.of(context).textTheme.body1,
                        a: TextStyles.commentAccent),
                onTapLink: (url) {
                  print("mUrl" + url);
                  if (url.startsWith("/?q")) {
                    var title = url.replaceAll("/?q=", "").replaceAll("+", " ");
                    var topic = Topic(title, null, url);
                    Navigator.pushNamed(
                      context,
                      RoutingKeys.comments,
                      arguments: CommentsWidgetRouteArguments(topic, true),
                    );
                  } else {
                    launch(url);
                  }
                }),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Wrap(
                alignment: WrapAlignment.start,
                runSpacing: 16.0,
                spacing: 16.0,
                direction: Axis.horizontal,
                children: <Widget>[
                  SizedBox(
                    height: 16.0,
                    width: 16.0,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      color: Theme.of(context).accentIconTheme.color,
                      iconSize: 16,
                      icon: new Icon(Icons.share),
                      onPressed: () {
                        Share.share(comment.commentUrl);
                      },
                    ),
                  ),
                  new FavoriteButtonWidget(
                      comment: comment,
                      selected:
                          HiveUtils.instance.favoritesList.contains(comment))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}


class FavoriteButtonWidget extends StatefulWidget {
  FavoriteButtonWidget({
    Key key,
    @required this.comment,
    this.selected,
  }) : super(key: key);

  final Comment comment;
  bool selected;

  @override
  _FavoriteButtonWidgetState createState() => _FavoriteButtonWidgetState();
}

class _FavoriteButtonWidgetState extends State<FavoriteButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 16.0,
      width: 16.0,
      child: IconButton(
        padding: EdgeInsets.zero,
        iconSize: 16,
        icon: Icon(Icons.favorite),
        color: widget.selected
            ? Colors.red
            : Theme.of(context).accentIconTheme.color,
        onPressed: () {
          widget.selected
              ? HiveUtils.instance.removeComment(widget.comment)
              : HiveUtils.instance.saveComment(widget.comment);
          setState(() {
            widget.selected = !widget.selected;
          });
        },
      ),
    );
  }
}
