import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'CommentsBloc.dart';
import 'CommentsPagePickerWidget.dart';
import 'CommentsPageScrollNotifier.dart';

class CommentsListViewHeaderWidget extends StatefulWidget {
  CommentsListViewHeaderWidget({Key key, this.onPageChanged}) : super(key: key);
  final IntCallback onPageChanged;
  _CommentsListViewHeaderWidgetState createState() =>
      _CommentsListViewHeaderWidgetState();
}

class _CommentsListViewHeaderWidgetState
    extends State<CommentsListViewHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    print("buildListheaderView");
    final scrollPageNotifier = Provider.of<CommentsPageScrollNotifier>(context);
    final commentsBloc = Provider.of<CommentsBloc>(context, listen: false);
    return Container(
      color: Theme.of(context).backgroundColor,
      height: 40,
      child: AnimatedOpacity(
        curve: Curves.easeIn,
        duration: Duration(milliseconds: 200),
        opacity: scrollPageNotifier.totalPage() == -1 ? 0.0 : 1.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              IconButton(
                  color: Theme.of(context).primaryIconTheme.color,
                  icon: Icon(Icons.first_page),
                  onPressed: () {
                    widget.onPageChanged(0);
                  }),
              FlatButton(
                padding: EdgeInsets.all(3.0),
                color: Colors.transparent,
                textColor: Theme.of(context).textTheme.subtitle.color,
                child: Text(scrollPageNotifier.currentPageText()),
                onPressed: () {
                  showModalBottomSheet<void>(
                      context: context,
                      backgroundColor: Theme.of(context).backgroundColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0)),
                      ),
                      builder: (BuildContext context) {
                        return CommentsPagePickerWidget(
                          pageCount: commentsBloc.getPageCount(),
                          onPageSelected: (page) {
                            widget.onPageChanged(page);
                          },
                        );
                      });
                },
              ),
              // FlatButton(
              //   padding: EdgeInsets.all(3.0),
              //   color: Colors.transparent,
              //   textColor: Theme.of(context).textTheme.subtitle.color,
              //   child: Row(
              //     children: <Widget>[
              //       Padding(
              //         padding: const EdgeInsets.all(2.0),
              //         child: Icon(
              //           Icons.sort,
              //           color: Theme.of(context).accentIconTheme.color,
              //         ),
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.all(2.0),
              //         child: Text(
              //           "Bugün",
              //           style: Theme.of(context).textTheme.subtitle,
              //         ),
              //       ),
              //     ],
              //   ),
              //   onPressed: () {
              //     showModalBottomSheet<void>(
              //         context: context,
              //         builder: (BuildContext context) {
              //           return CommentsTypePickerWidget(
              //             commentType: CommentType.all,
              //           );
              //         });
              //   },
              // ),
              IconButton(
                  color: Theme.of(context).primaryIconTheme.color,
                  icon: Icon(Icons.last_page),
                  onPressed: () {
                    widget.onPageChanged(commentsBloc.getPageCount() - 1);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
