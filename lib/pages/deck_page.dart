import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/models/deck.dart';

class DeckPage extends StatefulWidget {
  final Deck deck;

  DeckPage({this.deck});

  @override
  _DeckPageState createState() => _DeckPageState(deck: deck);
}

class _DeckPageState extends State<DeckPage>
    with SingleTickerProviderStateMixin {
  Deck deck;

  _DeckPageState({this.deck});

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
        title: Text(deck.name),
        bottom: TabBar(
          controller: tabController,
          tabs: [
            Tab(text: 'MAIN'),
            Tab(text: 'EXTRA'),
            Tab(text: 'SIDE'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box),
            onPressed: () {
              //add card to deck
            },
          )
        ],
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          FragmentCardList(listType: 3, deck: deck),
          FragmentCardList(listType: 4, deck: deck),
          FragmentCardList(listType: 5, deck: deck),
        ],
      ),
    );
  }
}
