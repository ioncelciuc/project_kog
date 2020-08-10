import 'package:flutter/material.dart';
import 'file:///C:/Users/Ionut-Tiberiu/AndroidStudioProjects/FlutterApps/project_kog/lib/fragments/database/fragment_card_list.dart';

class FragmentDatabase extends StatefulWidget {
  @override
  _FragmentDatabaseState createState() => _FragmentDatabaseState();
}

class _FragmentDatabaseState extends State<FragmentDatabase> {
  //TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            //actions: <Widget>[], TODO: MAYBE UNCOMMENT?
            title: TabBar(
              onTap: (index) {
                //print('You tapped at $index');
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
      ),
    );
  }
}
