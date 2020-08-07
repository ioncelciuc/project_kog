import 'package:flutter/material.dart';
import 'package:project_kog/fragments/fragment_card_list.dart';

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
          appBar: new AppBar(
            actions: <Widget>[],
            title: TabBar(
              onTap: (index) {
                print('You tapped at $index');
              },
              tabs: [
                Tab(
                  text: 'ALL CARDS',
                ),
                Tab(
                  text: 'BANLIST',
                ),
                Tab(
                  text: 'ARCHETYPES',
                ),
              ],
              indicatorColor: Theme.of(context).accentColor,
            ),
          ),
          body: new TabBarView(
            children: [
              FragmentCardList(),
              FragmentCardList(),
              FragmentCardList(),
            ],
          ),
        ),
      ),
    );
  }
}
