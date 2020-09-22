import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/models/filter.dart';
import 'package:project_kog/models/filter_result.dart';
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
  FilterResult filters = FilterResult();

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
          FilterResult filtersParam = filters;
          final FilterResult result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FilterPage(filters: filtersParam),
            ),
          );
          setState(() {
            for (int i = 0; i < result.filterList.length; i++) {
              filters.filterList[i].selected = result.filterList[i].selected;
            }
            filters.currentMinAtkSliderValue = result.currentMinAtkSliderValue;
            filters.currentMaxAtkSliderValue = result.currentMaxAtkSliderValue;
            filters.currentMinDefSliderValue = result.currentMinDefSliderValue;
            filters.currentMaxDefSliderValue = result.currentMaxDefSliderValue;
            filters.currentMinLvlSliderValue = result.currentMinLvlSliderValue;
            filters.currentMaxLvlSliderValue = result.currentMaxLvlSliderValue;
            filters.currentMinScaleSliderValue = result.currentMinScaleSliderValue;
            filters.currentMaxScaleSliderValue = result.currentMaxScaleSliderValue;
            filters.currentMinLinkSliderValue = result.currentMinLinkSliderValue;
            filters.currentMaxLinkSliderValue = result.currentMaxLinkSliderValue;
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
    for (int i = 0;
        i < filters.filterList.length && atLeastAnOption == false;
        i++) if (filters.filterList[i].selected == true) atLeastAnOption = true;
    if (atLeastAnOption == false) return futureList;

    List<YuGiOhCard> cardListFiltered = List<YuGiOhCard>();

    ///CARD TYPES
    bool atLeastOneCardTypeOption = false;
    for (int i = 0; i < 10 && atLeastOneCardTypeOption == false; i++)
      if (filters.filterList[i].selected == true)
        atLeastOneCardTypeOption = true;
    if (atLeastOneCardTypeOption) {
      for (int i = 0; i < 10; i++)
        if (filters.filterList[i].selected == true) {
          if (filters.filterList[i].name == 'Effect') {
            for (int j = 0; j < futureList.length; j++)
              if (!futureList[j]
                  .type
                  .contains('Normal')) //TODO: TEST FILTERING WITH EFFECT
                cardListFiltered.add(futureList[j]);
          } else {
            for (int j = 0; j < futureList.length; j++)
              if (futureList[j].type.startsWith(filters.filterList[i].name))
                cardListFiltered.add(futureList[j]);
          }
        }
    }

    ///ATTRIBUTES
    bool atLeastAnAttributeOption = false;
    for (int i = 10; i < 17 && atLeastAnAttributeOption == false; i++)
      if (filters.filterList[i].selected == true)
        atLeastAnAttributeOption = true;
    if (atLeastAnAttributeOption) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 10; i < 17; i++) {
        if (filters.filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].attribute == filters.filterList[i].name)
              cardListFiltered.add(futureList[j]);
      }
    }

    ///MONSTER TYPE 1
    bool atLeastOneMonsterType1Option = false;
    for (int i = 17; i < 42 && atLeastOneMonsterType1Option == false; i++)
      if (filters.filterList[i].selected == true)
        atLeastOneMonsterType1Option = true;
    if (atLeastOneMonsterType1Option) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 17; i < 42; i++) {
        if (filters.filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].race == filters.filterList[i].name)
              cardListFiltered.add(futureList[j]);
      }
    }

    ///MONSTER TYPE 2
    bool atLeastOneMonsterType2Option = false;
    for (int i = 42; i < 48 && atLeastOneMonsterType2Option == false; i++)
      if (filters.filterList[i].selected == true)
        atLeastOneMonsterType2Option = true;
    if (atLeastOneMonsterType2Option) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 42; i < 48; i++) {
        if (filters.filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].type.contains(filters.filterList[i].name))
              cardListFiltered.add(futureList[j]);
      }
    }

    /// SPELL/TRAP TYPES
    bool atLeastOneSpellTrapTypesOption = false;
    for (int i = 48; i < 55 && atLeastOneSpellTrapTypesOption == false; i++)
      if (filters.filterList[i].selected == true)
        atLeastOneSpellTrapTypesOption = true;
    if (atLeastOneSpellTrapTypesOption) {
      if (cardListFiltered.length > 0) {
        futureList.clear();
        for (int i = 0; i < cardListFiltered.length; i++)
          futureList.add(cardListFiltered[i]);
        cardListFiltered.clear();
      }
      for (int i = 48; i < 55; i++) {
        if (filters.filterList[i].selected == true)
          for (int j = 0; j < futureList.length; j++)
            if (futureList[j].race == filters.filterList[i].name)
              cardListFiltered.add(futureList[j]);
      }
    }

    /// LINK ARROWS
    bool atLeastOneLinkArrowOption = false;
    for (int i = 55; i < 63 && atLeastOneLinkArrowOption == false; i++)
      if (filters.filterList[i].selected == true)
        atLeastOneLinkArrowOption = true;
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
          if (filters.filterList[j].selected == true)
            switch (filters.filterList[j].name) {
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

    ///ATK
    

    //sort and return list
    cardListFiltered.sort((a, b) => a.name.compareTo(b.name));
    return cardListFiltered;
  }

  void initializareTractor() {
    //card types
    filters.filterList.add(Filter(name: 'Normal'));
    filters.filterList.add(Filter(name: 'Effect'));
    filters.filterList.add(Filter(name: 'Ritual'));
    filters.filterList.add(Filter(name: 'Fusion'));
    filters.filterList.add(Filter(name: 'Synchro'));
    filters.filterList.add(Filter(name: 'XYZ'));
    filters.filterList.add(Filter(name: 'Pendulum'));
    filters.filterList.add(Filter(name: 'Spell'));
    filters.filterList.add(Filter(name: 'Trap'));
    filters.filterList.add(Filter(name: 'Link'));
    //attributes
    filters.filterList.add(Filter(name: 'DARK'));
    filters.filterList.add(Filter(name: 'EARTH'));
    filters.filterList.add(Filter(name: 'FIRE'));
    filters.filterList.add(Filter(name: 'LIGHT'));
    filters.filterList.add(Filter(name: 'WATER'));
    filters.filterList.add(Filter(name: 'WIND'));
    filters.filterList.add(Filter(name: 'DIVINE'));
    //monster types
    filters.filterList.add(Filter(name: 'Aqua'));
    filters.filterList.add(Filter(name: 'Beast'));
    filters.filterList.add(Filter(name: 'Beast-Warrior'));
    filters.filterList.add(Filter(name: 'Creator-God'));
    filters.filterList.add(Filter(name: 'Cyberse'));
    filters.filterList.add(Filter(name: 'Dinosaur'));
    filters.filterList.add(Filter(name: 'Divine-Beast'));
    filters.filterList.add(Filter(name: 'Dragon'));
    filters.filterList.add(Filter(name: 'Fairy'));
    filters.filterList.add(Filter(name: 'Fiend'));
    filters.filterList.add(Filter(name: 'Fish'));
    filters.filterList.add(Filter(name: 'Insect'));
    filters.filterList.add(Filter(name: 'Machine'));
    filters.filterList.add(Filter(name: 'Plant'));
    filters.filterList.add(Filter(name: 'Psychic'));
    filters.filterList.add(Filter(name: 'Pyro'));
    filters.filterList.add(Filter(name: 'Reptile'));
    filters.filterList.add(Filter(name: 'Rock'));
    filters.filterList.add(Filter(name: 'Sea Serpent'));
    filters.filterList.add(Filter(name: 'Spellcaster'));
    filters.filterList.add(Filter(name: 'Thunder'));
    filters.filterList.add(Filter(name: 'Warrior'));
    filters.filterList.add(Filter(name: 'Winged Beast'));
    filters.filterList.add(Filter(name: 'Wyrm'));
    filters.filterList.add(Filter(name: 'Zombie'));
    //monster types 2
    filters.filterList.add(Filter(name: 'Flip'));
    filters.filterList.add(Filter(name: 'Gemini'));
    filters.filterList.add(Filter(name: 'Spirit'));
    filters.filterList.add(Filter(name: 'Toon'));
    filters.filterList.add(Filter(name: 'Tuner'));
    filters.filterList.add(Filter(name: 'Union'));
    // spell/trap
    filters.filterList.add(Filter(name: 'Normal'));
    filters.filterList.add(Filter(name: 'Continuous'));
    filters.filterList.add(Filter(name: 'Equip'));
    filters.filterList.add(Filter(name: 'Field'));
    filters.filterList.add(Filter(name: 'Quick-Play'));
    filters.filterList.add(Filter(name: 'Ritual'));
    filters.filterList.add(Filter(name: 'Counter'));
    //link arrows
    filters.filterList.add(Filter(name: 'Top-Left'));
    filters.filterList.add(Filter(name: 'Top'));
    filters.filterList.add(Filter(name: 'Top-Right'));
    filters.filterList.add(Filter(name: 'Left'));
    filters.filterList.add(Filter(name: 'Right'));
    filters.filterList.add(Filter(name: 'Bottom-Left'));
    filters.filterList.add(Filter(name: 'Bottom'));
    filters.filterList.add(Filter(name: 'Bottom-Right'));
    // atk/def/lvl/scale
    filters.currentMinAtkSliderValue = 0;
    filters.currentMaxAtkSliderValue = 5000;
    filters.currentMinDefSliderValue = 0;
    filters.currentMaxDefSliderValue = 5000;
    filters.currentMinLvlSliderValue = 0;
    filters.currentMaxLvlSliderValue = 12;
    filters.currentMinScaleSliderValue = 0;
    filters.currentMaxScaleSliderValue = 12;
    filters.currentMinLinkSliderValue = 0;
    filters.currentMaxLinkSliderValue = 6;
  }
}
