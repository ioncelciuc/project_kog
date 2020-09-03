import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_archetypes.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/utils/card_list_type.dart';
import 'package:project_kog/utils/data_search.dart';

class FragmentDatabase extends StatefulWidget {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  FragmentDatabase({this.homeScaffoldState});

  @override
  _FragmentDatabaseState createState() => _FragmentDatabaseState();
}

class _FragmentDatabaseState extends State<FragmentDatabase>
    with SingleTickerProviderStateMixin {
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
            widget.homeScaffoldState.currentState.openDrawer();
          },
        ),
        title: Text('Database'),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: 'ALL CARDS'),
            Tab(text: 'BANLIST'),
            Tab(text: 'ARCHETYPES'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: DataSearch(
                      listType: tabController.index == 0
                          ? CardListType.ALL_CARDS
                          : (tabController.index == 1
                              ? CardListType.BANLIST_CARDS
                              : null)));
            },
          ),
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          FragmentCardList(listType: CardListType.ALL_CARDS),
          FragmentCardList(listType: CardListType.BANLIST_CARDS),
          FragmentArchetypes(),
        ],
      ),
    );
  }
}
