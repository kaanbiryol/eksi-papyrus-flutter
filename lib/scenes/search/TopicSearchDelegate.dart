import 'package:eksi_papyrus/core/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/populartopics/networking/models/TopicsResponse.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'networking/SearchResultBloc.dart';
import 'networking/models/SearchResponse.dart';

class TopicSearchDelegate extends SearchDelegate {
  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
        inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: theme.primaryTextTheme.title.color)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            title: theme.textTheme.title
                .copyWith(color: theme.primaryTextTheme.title.color)));
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.length < 3) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(
            child: Text(
              "Search term must be longer than two letters.",
            ),
          )
        ],
      );
    }

    return Column(
      children: <Widget>[
        //Build the results based on the searchResults stream in the searchBloc
        Text("test")
      ],
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // This method is called everytime the search term changes.
    // If you want to add search suggestions as the user enters their search term, this is the place to do that.

    return makeFutureBuilder(context);
  }
}

Widget makeFutureBuilder(BuildContext context) {
  print("FutureBuilder BUILT");
  final searchResultBloc =
      Provider.of<SearchResultBloc>(context, listen: false);
  return FutureBuilder(
    future: searchResultBloc.queryResults("d"),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
          return Center(child: CircularProgressIndicator());
        case ConnectionState.done:
          final searchResults = snapshot.data as SearchResponse;
          return makeListView(context, searchResults);
        default:
          //TODO: is this the right way?
          return Column();
      }
    },
  );
}

Widget makeListView(BuildContext context, SearchResponse response) {
  var itemList = response.titles;
  var itemCount = (itemList != null) ? itemList.length : 0;
  return ListView.separated(
    separatorBuilder: (context, index) => Divider(
      color: AppColors.listDivider,
    ),
    itemCount: itemCount,
    itemBuilder: (BuildContext context, int index) {
      return makeListTile(itemList[index], context);
    },
  );
}

ListTile makeListTile(String title, BuildContext context) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
    title: Text(
      title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          color: Colors.white, fontWeight: FontWeight.normal, fontSize: 16.0),
    ),
    onTap: () {
      var topic = Topic(title, "", null);
      Navigator.pushNamed(
        context,
        CommentsWidgetRouting.routeToComments,
        arguments: CommentsWidgetRouteArguments(topic),
      );
    },
  );
}
