import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/utils/data_search.dart';

class FragmentDatabase extends StatefulWidget {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  FragmentDatabase({this.homeScaffoldState});

  @override
  _FragmentDatabaseState createState() =>
      _FragmentDatabaseState(homeScaffoldState: this.homeScaffoldState);
}

class _FragmentDatabaseState extends State<FragmentDatabase> with SingleTickerProviderStateMixin{
  final GlobalKey<ScaffoldState> homeScaffoldState;

  _FragmentDatabaseState({this.homeScaffoldState});

  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 3);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            homeScaffoldState.currentState.openDrawer();
          },
        ),
        title: Text('Database'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: DataSearch(tabIndex: tabController.index));
            },
          ),
        ],
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: 'ALL CARDS'),
            Tab(text: 'BANLIST'),
            Tab(text: 'ARCHETYPES'),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          FragmentCardList(listType: 0),
          FragmentCardList(listType: 1),
          FragmentCardList(), // TODO: ADD ARCHETYPES
        ],
      ),
    );
  }
}
