import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_archetypes.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/utils/card_list_type.dart';

class DataSearch extends SearchDelegate<String> {
  CardListType listType;

  DataSearch({this.listType});

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

  // TODO: SHOW LAST SEARCHES
  @override
  Widget buildSuggestions(BuildContext context) {
    //show last 5 searches
    return ListView(
      children: [],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //show result based on the selection
    return listType == null
        ? FragmentArchetypes(searchParams: query)
        : FragmentCardList(
            listType: listType,
            searchParams: query,
          );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }
}
