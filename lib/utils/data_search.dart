import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/utils/database_helper.dart';

class DataSearch extends SearchDelegate<String> {
  int tabIndex = -1;

  DataSearch({this.tabIndex});

  @override
  List<Widget> buildActions(BuildContext context) {
    //actions for the app bar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //leading icon on the left of the app bar
    return IconButton(
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_arrow,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  final recentSearches = [
    'Search for cards!',
  ];

  // TODO: SHOW LAST SEARCHES
  @override
  Widget buildSuggestions(BuildContext context) {
    //show last 5 searches
    return Text(
      'Show cards'
    );
  }

  @override
  Widget buildResults(BuildContext context){
    //show result based on the selection
    return FragmentCardList(
      listType: tabIndex,
      searchParams: query,
    );
  }
}
