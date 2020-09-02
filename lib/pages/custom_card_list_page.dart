import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/models/deck.dart';

class CustomCardListPage extends StatefulWidget {
  final Deck deck;
  final int tabIndex;

  CustomCardListPage({this.deck, this.tabIndex});

  @override
  _CustomCardListPageState createState() =>
      _CustomCardListPageState(deck: this.deck, tabIndex: this.tabIndex);
}

class _CustomCardListPageState extends State<CustomCardListPage> {
  Deck deck;
  int tabIndex;

  _CustomCardListPageState({this.deck, this.tabIndex});

  @override
  Widget build(BuildContext context) {
    String deckType =
        tabIndex == 0 ? 'Main' : (tabIndex == 1 ? 'Extra' : 'Side');

    return Scaffold(
      appBar: AppBar(
        title: Text('Add cards to $deckType Deck'),
      ),
      body: FragmentCardList(
        listType: 6,
        deck: deck,
        tabIndexForSpecificDeck: tabIndex,
      ),
    );
  }
}
