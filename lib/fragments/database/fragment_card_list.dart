import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/models/filter.dart';
import 'package:project_kog/pages/card_detail.dart';
import 'package:project_kog/pages/filter_page.dart';
import 'package:project_kog/utils/card_list_type.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentCardList extends StatefulWidget {
  final CardListType listType;
  final String archetype;
  final Deck deck;
  final CardListType deckType;
  final String searchParams;

  FragmentCardList({
    this.listType,
    this.archetype,
    this.deck,
    this.deckType,
    this.searchParams,
  });

  @override
  _FragmentCardListState createState() => _FragmentCardListState(
        listType: this.listType,
        archetype: this.archetype,
        deck: this.deck,
        deckType: this.deckType,
        searchParams: this.searchParams,
      );
}

class _FragmentCardListState extends State<FragmentCardList>
    with AutomaticKeepAliveClientMixin<FragmentCardList> {
  CardListType listType;
  String archetype;
  Deck deck;
  CardListType deckType;
  String searchParams;

  _FragmentCardListState({
    this.listType,
    this.archetype,
    this.deck,
    this.deckType,
    this.searchParams,
  });

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<YuGiOhCard> cardList = List<YuGiOhCard>();
  List<Filter> filterList = List<Filter>();

  @override
  void initState() {
    super.initState();
    initializareTractor();
    getAllCardsFromDatabase();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: cardList.length,
        itemBuilder: (BuildContext context, int index) {
          YuGiOhCard card = cardList[index];
          String generalInfo = (card.type.contains('Spell')
              ? 'SPELL / ${card.race}'
              : (card.type.contains('Trap')
                  ? 'TRAP / ${card.race}'
                  : '${card.attribute.toUpperCase()} / ${card.race} / ${(card.type.contains('Monster') ? card.type.substring(0, card.type.lastIndexOf('Monster')) : card.type)}'));
          String stats = (card.attribute == ''
              ? ''
              : (card.type.contains('Link')
                  ? '${card.atk} / LINK-${card.linkval}'
                  : (card.type.contains('Pendulum')
                      ? '${card.atk} / ${card.def} / LEVEL ${card.level} / SCALE ${card.scale}'
                      : '${card.atk} / ${card.def} / LEVEL ${card.level}')));
          return GestureDetector(
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CardDetail(card: cardList[index]),
                ),
              );
              if (listType == CardListType.FAVOURITE_CARDS)
                getAllCardsFromDatabase();
            },
            child: Container(
              height: 86,
              color: Colors.white,
              child: Row(
                children: [
                  CachedNetworkImage(
                    height: 86,
                    imageUrl: card.imageUrlSmall,
                    placeholder: (context, url) =>
                        Image.asset('assets/card_back.jpg'),
                    errorWidget: (context, url, error) =>
                        Image.asset('assets/card_back.jpg'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Marquee(
                          child: Text(
                            '${card.name}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          pauseDuration: Duration(milliseconds: 500),
                        ),
                        Marquee(
                          child: Text(generalInfo),
                          pauseDuration: Duration(milliseconds: 500),
                        ),
                        Marquee(
                          child: Text(stats),
                          pauseDuration: Duration(milliseconds: 500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      trailingIcon(card),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: listType,
        child: Icon(
          Icons.filter_list,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          List<Filter> filterListParam = filterList;
          final List<Filter> result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(filterList: filterListParam),
            ),
          );
          setState(() {
            for (int i = 0; i < result.length; i++) {
              filterList[i].selected = result[i].selected;
            }
          });
          getAllCardsFromDatabase();
        },
      ),
    );
  }

  Widget trailingIcon(YuGiOhCard card) {
    Icon iconFavouriteBorder = Icon(Icons.favorite_border);
    Icon iconFavourite = Icon(
      Icons.favorite,
      color: Colors.red,
    );

    return IconButton(
      icon: card.favourite == 0 ? iconFavouriteBorder : iconFavourite,
      onPressed: () async {
        setState(() {
          if (card.favourite == 1)
            card.favourite = 0;
          else
            card.favourite = 1;
        });
        databaseHelper.updateCard(card);
        if (listType == CardListType.FAVOURITE_CARDS) getAllCardsFromDatabase();
      },
    );
  }

  void getAllCardsFromDatabase() async {
    List<YuGiOhCard> futureList = List<YuGiOhCard>();
    switch (listType) {
      case CardListType.ALL_CARDS:
        futureList = await databaseHelper.getAllCards();
        break;
      case CardListType.BANLIST_CARDS:
        futureList = await databaseHelper.getAllBanlistCards();
        break;
      case CardListType.FAVOURITE_CARDS:
        futureList = await databaseHelper.getAllFavouriteCards();
        break;
      case CardListType.ARCHETYPE_CARDS:
        futureList = await databaseHelper.getAllArchetypeCards(archetype);
        break;
      case CardListType.MAIN_DECK_CARDS:
        futureList =
            await databaseHelper.getAllCardsRelatedToDeck(deck, listType);
        break;
      case CardListType.EXTRA_DECK_CARDS:
        futureList =
            await databaseHelper.getAllCardsRelatedToDeck(deck, listType);
        break;
      case CardListType.SIDE_DECK_CARDS:
        futureList =
            await databaseHelper.getAllCardsRelatedToDeck(deck, listType);
        break;
      default:
        futureList = await databaseHelper.getAllCards();
        break;
    }

    if (searchParams != null && searchParams != '') {
      //futureList = cardList;
      List<YuGiOhCard> searchList = List<YuGiOhCard>();
      for (int i = 0; i < futureList.length; i++) {
        if (futureList[i]
                .name
                .toLowerCase()
                .trim()
                .contains(searchParams.toLowerCase().trim()) ||
            futureList[i]
                .desc
                .toLowerCase()
                .contains(searchParams.toLowerCase())) {
          searchList.add(futureList[i]);
        }
      }
      setState(() {
        this.cardList = filterCardList(searchList);
      });
      return;
    }

    setState(() {
      this.cardList = filterCardList(futureList);
    });
  }

  List<YuGiOhCard> filterCardList(List<YuGiOhCard> futureList) {
    bool atLeastAnOption = false;
    for (int i = 0; i < filterList.length && atLeastAnOption == false; i++)
      if (filterList[i].selected == true) atLeastAnOption = true;
    if (atLeastAnOption == false) return futureList;

    List<YuGiOhCard> cardListFiltered = List<YuGiOhCard>();

    ///CARD TYPES
    bool atLeastOneCardTypeOption = false;
    for (int i = 0; i < 10 && atLeastOneCardTypeOption == false; i++)
      if (filterList[i].selected == true) atLeastOneCardTypeOption = true;
    if (atLeastOneCardTypeOption) {
      for (int i = 0; i < 10; i++)
        if (filterList[i].selected == true) {
          if (filterList[i].name == 'Effect') {
            for (int j = 0; j < futureList.length; j++)
              if (!futureList[j]
                  .type
                  .contains('Normal')) //TODO: TEST FILTERING WITH EFFECT
                cardListFiltered.add(futureList[j]);
          } else {
            for (int j = 0; j < futureList.length; j++)
              if (futureList[j].type.startsWith(filterList[i].name))
                cardListFiltered.add(futureList[j]);
          }
        }
    }

    ///ATTRIBUTES
    bool atLeastAnAttributeOption = false;
    for (int i = 10; i < 17 && atLeastAnAttributeOption == false; i++)
      if (filterList[i].selected == true) atLeastAnAttributeOption = true;
    if (atLeastAnAttributeOption) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 10; i < 17; i++) {
        if (filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].attribute == filterList[i].name)
              cardListFiltered.add(futureList[j]);
      }
    }

    ///MONSTER TYPE 1
    bool atLeastOneMonsterType1Option = false;
    for (int i = 17; i < 42 && atLeastOneMonsterType1Option == false; i++)
      if (filterList[i].selected == true) atLeastOneMonsterType1Option = true;
    if (atLeastOneMonsterType1Option) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 17; i < 42; i++) {
        if (filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].race == filterList[i].name)
              cardListFiltered.add(futureList[j]);
      }
    }

    ///MONSTER TYPE 2
    bool atLeastOneMonsterType2Option = false;
    for (int i = 42; i < 48 && atLeastOneMonsterType2Option == false; i++)
      if (filterList[i].selected == true) atLeastOneMonsterType2Option = true;
    if (atLeastOneMonsterType2Option) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 42; i < 48; i++) {
        if (filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].type.contains(filterList[i].name))
              cardListFiltered.add(futureList[j]);
      }
    }

    /// SPELL/TRAP TYPES
    bool atLeastOneSpellTrapTypesOption = false;
    for (int i = 48; i < 55 && atLeastOneSpellTrapTypesOption == false; i++)
      if (filterList[i].selected == true) atLeastOneSpellTrapTypesOption = true;
    if (atLeastOneSpellTrapTypesOption) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 48; i < 55; i++) {
        if (filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].race == filterList[i].name)
              cardListFiltered.add(futureList[j]);
      }
    }

    /// LINK ARROWS
    bool atLeastOneLinkArrowOption = false;
    for (int i = 55; i < 63 && atLeastOneLinkArrowOption == false; i++)
      if (filterList[i].selected == true) atLeastOneLinkArrowOption = true;
    if (atLeastOneLinkArrowOption) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 0; i < futureList.length; i++) {
        bool goodToBeAdded = true;
        for (int j = 55; j < 63 && goodToBeAdded == true; j++)
          if (filterList[j].selected == true)
            switch (filterList[j].name) {
              case 'Top-Left':
                if (futureList[i].linkTopLeft == 0) goodToBeAdded = false;
                break;
              case 'Top':
                if (futureList[i].linkTop == 0) goodToBeAdded = false;
                break;
              case 'Top-Right':
                if (futureList[i].linkTopRight == 0) goodToBeAdded = false;
                break;
              case 'Left':
                if (futureList[i].linkLeft == 0) goodToBeAdded = false;
                break;
              case 'Right':
                if (futureList[i].linkRight == 0) goodToBeAdded = false;
                break;
              case 'Bottom-Left':
                if (futureList[i].linkBottomLeft == 0) goodToBeAdded = false;
                break;
              case 'Bottom':
                if (futureList[i].linkBottom == 0) goodToBeAdded = false;
                break;
              case 'Bottom-Right':
                if (futureList[i].linkBottomRight == 0) goodToBeAdded = false;
                break;
            }
        if (goodToBeAdded == true) cardListFiltered.add(futureList[i]);
      }
    }

    //sort and return list
    cardListFiltered.sort((a, b) => a.name.compareTo(b.name));
    return cardListFiltered;
  }

  void initializareTractor() {
    //card types
    filterList.add(Filter(name: 'Normal'));
    filterList.add(Filter(name: 'Effect'));
    filterList.add(Filter(name: 'Ritual'));
    filterList.add(Filter(name: 'Fusion'));
    filterList.add(Filter(name: 'Synchro'));
    filterList.add(Filter(name: 'XYZ'));
    filterList.add(Filter(name: 'Pendulum'));
    filterList.add(Filter(name: 'Spell'));
    filterList.add(Filter(name: 'Trap'));
    filterList.add(Filter(name: 'Link'));
    //attributes
    filterList.add(Filter(name: 'DARK'));
    filterList.add(Filter(name: 'EARTH'));
    filterList.add(Filter(name: 'FIRE'));
    filterList.add(Filter(name: 'LIGHT'));
    filterList.add(Filter(name: 'WATER'));
    filterList.add(Filter(name: 'WIND'));
    filterList.add(Filter(name: 'DIVINE'));
    //monster types
    filterList.add(Filter(name: 'Aqua'));
    filterList.add(Filter(name: 'Beast'));
    filterList.add(Filter(name: 'Beast-Warrior'));
    filterList.add(Filter(name: 'Creator-God'));
    filterList.add(Filter(name: 'Cyberse'));
    filterList.add(Filter(name: 'Dinosaur'));
    filterList.add(Filter(name: 'Divine-Beast'));
    filterList.add(Filter(name: 'Dragon'));
    filterList.add(Filter(name: 'Fairy'));
    filterList.add(Filter(name: 'Fiend'));
    filterList.add(Filter(name: 'Fish'));
    filterList.add(Filter(name: 'Insect'));
    filterList.add(Filter(name: 'Machine'));
    filterList.add(Filter(name: 'Plant'));
    filterList.add(Filter(name: 'Psychic'));
    filterList.add(Filter(name: 'Pyro'));
    filterList.add(Filter(name: 'Reptile'));
    filterList.add(Filter(name: 'Rock'));
    filterList.add(Filter(name: 'Sea Serpent'));
    filterList.add(Filter(name: 'Spellcaster'));
    filterList.add(Filter(name: 'Thunder'));
    filterList.add(Filter(name: 'Warrior'));
    filterList.add(Filter(name: 'Winged Beast'));
    filterList.add(Filter(name: 'Wyrm'));
    filterList.add(Filter(name: 'Zombie'));
    //monster types 2
    filterList.add(Filter(name: 'Flip'));
    filterList.add(Filter(name: 'Gemini'));
    filterList.add(Filter(name: 'Spirit'));
    filterList.add(Filter(name: 'Toon'));
    filterList.add(Filter(name: 'Tuner'));
    filterList.add(Filter(name: 'Union'));
    // spell/trap
    filterList.add(Filter(name: 'Normal'));
    filterList.add(Filter(name: 'Continuous'));
    filterList.add(Filter(name: 'Equip'));
    filterList.add(Filter(name: 'Field'));
    filterList.add(Filter(name: 'Quick-Play'));
    filterList.add(Filter(name: 'Ritual'));
    filterList.add(Filter(name: 'Counter'));
    //link arrows
    filterList.add(Filter(name: 'Top-Left'));
    filterList.add(Filter(name: 'Top'));
    filterList.add(Filter(name: 'Top-Right'));
    filterList.add(Filter(name: 'Left'));
    filterList.add(Filter(name: 'Right'));
    filterList.add(Filter(name: 'Bottom-Left'));
    filterList.add(Filter(name: 'Bottom'));
    filterList.add(Filter(name: 'Bottom-Right'));
  }
}
