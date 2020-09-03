import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_archetypes.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/utils/card_list_type.dart';

class FragmentDatabase extends StatefulWidget {
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
      backgroundColor: Theme.of(context).primaryColor,
      appBar: TabBar(
        controller: tabController,
        tabs: [
          Tab(text: 'ALL CARDS'),
          Tab(text: 'BANLIST'),
          Tab(text: 'ARCHETYPES'),
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
