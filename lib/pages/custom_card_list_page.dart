import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/utils/card_list_type.dart';

class CustomCardListPage extends StatefulWidget {
  final Deck deck;
  final CardListType cardListType;

  CustomCardListPage({this.deck, this.cardListType});

  @override
  _CustomCardListPageState createState() =>
      _CustomCardListPageState(deck: this.deck, cardListType: this.cardListType);
}

class _CustomCardListPageState extends State<CustomCardListPage> {
  Deck deck;
  CardListType cardListType;

  _CustomCardListPageState({this.deck, this.cardListType});

  List<YuGiOhCard> cardList = List<YuGiOhCard>();

  @override
  Widget build(BuildContext context) {
    String deckType =
        cardListType == CardListType.MAIN_DECK_CARDS ? 'Main' : (cardListType == CardListType.EXTRA_DECK_CARDS ? 'Extra' : 'Side');

    return Scaffold(
      appBar: AppBar(
        title: Text('Add cards to $deckType Deck'),
      ),
      body: FragmentCardList(
        listType: CardListType.ADD_CARDS_TO_NEW_DECK,
        deck: deck,
        deckType: cardListType,
      ),
    );
  }
}
