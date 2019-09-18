import 'package:eksi_papyrus/core/Router.dart';
import 'package:eksi_papyrus/core/styles/AppColors.dart';
import 'package:eksi_papyrus/scenes/comments/CommentsWidgetRouting.dart';
import 'package:eksi_papyrus/scenes/topics/networking/models/TopicsResponse.dart';
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
            hintStyle: TextStyle(color: AppColors.secondaryTextColor)),
        primaryColor: theme.primaryColor,
        primaryIconTheme: theme.primaryIconTheme,
        primaryColorBrightness: theme.primaryColorBrightness,
        primaryTextTheme: theme.primaryTextTheme,
        textTheme: theme.textTheme.copyWith(
            title: theme.textTheme.title
                .copyWith(color: AppColors.primaryTextColor)));
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
    return query.length >= 2 ? makeFutureBuilder(context, query) : Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return query.length >= 2 ? makeFutureBuilder(context, query) : Container();
  }
}

Widget makeFutureBuilder(BuildContext context, String query) {
  print("FutureBuilder BUILT");
  final searchResultBloc =
      Provider.of<SearchResultBloc>(context, listen: false);
  return FutureBuilder(
    future: searchResultBloc.queryResults(query),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
          return Center(child: CircularProgressIndicator());
        case ConnectionState.waiting:
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
      color: Theme.of(context).dividerColor,
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
    title: Text(title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.title),
    onTap: () {
      var topic = Topic(title, "", null);
      Navigator.pushNamed(
        context,
        RoutingKeys.comments,
        arguments: CommentsWidgetRouteArguments(topic, true),
      );
    },
  );
}
