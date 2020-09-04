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
          List<Filter> futureFilterList = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => FilterPage(filterList: this.filterList)),
          );
          if (futureFilterList != null) {
            setState(() {
              filterList = futureFilterList;
            });
            for (int i = 0; i < filterList.length; i++) {
              if (filterList[i].selected == true) print(filterList[i].name);
            }
          }
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
        this.cardList = searchList;
      });
      return;
    }

    setState(() {
      this.cardList = futureList;
    });
  }

  void initializareTractor() {
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
    filterList.add(Filter(name: 'DARK'));
    filterList.add(Filter(name: 'EARTH'));
    filterList.add(Filter(name: 'FIRE'));
    filterList.add(Filter(name: 'LIGHT'));
    filterList.add(Filter(name: 'WATER'));
    filterList.add(Filter(name: 'WIND'));
    filterList.add(Filter(name: 'DIVINE'));
  }
}
