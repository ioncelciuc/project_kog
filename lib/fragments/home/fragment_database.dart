import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';

class FragmentDatabase extends StatefulWidget {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  FragmentDatabase({this.homeScaffoldState});

  @override
  _FragmentDatabaseState createState() =>
      _FragmentDatabaseState(homeScaffoldState: this.homeScaffoldState);
}

class _FragmentDatabaseState extends State<FragmentDatabase> {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  _FragmentDatabaseState({this.homeScaffoldState});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 10,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              homeScaffoldState.currentState.openDrawer();
            },
          ),
          title: Text('Database'),
          bottom: TabBar(
            onTap: (index) {
              print(index);
            },
            tabs: [
              Tab(text: 'ALL CARDS'),
              Tab(text: 'BANLIST'),
              Tab(text: 'ARCHETYPES'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            FragmentCardList(listType: 'all_cards'),
            FragmentCardList(listType: 'banlist'),
            FragmentCardList(), // TODO: ADD ARCHETYPES
          ],
        ),
      ),
    );
  }
}
