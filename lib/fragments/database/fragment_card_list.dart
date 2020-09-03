import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/pages/card_detail.dart';
import 'package:project_kog/pages/custom_card_list_page.dart';
import 'package:project_kog/utils/card_list_type.dart';
import 'package:project_kog/utils/data_search.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentCardList extends StatefulWidget {
  final CardListType listType;
  final String archetype;
  final Deck deck;
  final CardListType deckType;

  FragmentCardList({
    this.listType,
    this.archetype,
    this.deck,
    this.deckType,
  });

  @override
  _FragmentCardListState createState() => _FragmentCardListState(
        listType: this.listType,
        archetype: this.archetype,
        deck: this.deck,
        deckType: this.deckType,
      );
}

class _FragmentCardListState extends State<FragmentCardList>
    with AutomaticKeepAliveClientMixin<FragmentCardList> {
  CardListType listType;
  String archetype;
  Deck deck;
  CardListType deckType;

  _FragmentCardListState({
    this.listType,
    this.archetype,
    this.deck,
    this.deckType,
  });

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<YuGiOhCard> cardList = List<YuGiOhCard>();
  List<YuGiOhCard> cardsAddedToDeck = List<YuGiOhCard>();

  @override
  void initState() {
    super.initState();
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
      floatingActionButton: floatingActionButton(),
    );
  }

  Widget trailingIcon(YuGiOhCard card) {
    Icon iconFavouriteBorder = Icon(Icons.favorite_border);
    Icon iconFavourite = Icon(
      Icons.favorite,
      color: Colors.red,
    );

    if (listType == CardListType.MAIN_DECK_CARDS ||
        listType == CardListType.EXTRA_DECK_CARDS ||
        listType == CardListType.SIDE_DECK_CARDS ||
        listType == CardListType.ADD_CARDS_TO_NEW_DECK)
      return Container(
        margin: EdgeInsets.all(10),
        width: 40,
        height: 40,
        child: Center(
          child: RaisedButton(
            color: Theme.of(context).accentColor,
            child: Text(
              listType == CardListType.MAIN_DECK_CARDS
                  ? '${card.main}'
                  : (listType == CardListType.EXTRA_DECK_CARDS
                      ? '${card.extra}'
                      : '${card.side}'),
              style: TextStyle(fontSize: 17),
            ),
            onPressed: () async {
              if (listType == CardListType.MAIN_DECK_CARDS) {
                if (card.main == 1 || card.main == 2) {
                  setState(() {
                    card.main++;
                  });
                  databaseHelper.updateCardInDeck(
                    card,
                    deck,
                    CardListType.MAIN_DECK_CARDS,
                  );
                } else if (card.main == 3) {
                  setState(() {
                    card.main = 0;
                  });
                  databaseHelper.deleteCardInDeck(
                    card,
                    deck,
                    CardListType.MAIN_DECK_CARDS,
                  );
                }
              } else if (listType == CardListType.EXTRA_DECK_CARDS) {
                if (card.extra == 0) {
                  setState(() {
                    card.extra++;
                  });
                  databaseHelper.insertCardInDeck(
                    card,
                    deck,
                    CardListType.EXTRA_DECK_CARDS,
                  );
                } else if (card.extra == 1 || card.extra == 2) {
                  setState(() {
                    card.extra++;
                  });
                  databaseHelper.updateCardInDeck(
                    card,
                    deck,
                    CardListType.EXTRA_DECK_CARDS,
                  );
                } else if (card.extra == 3) {
                  setState(() {
                    card.extra = 0;
                  });
                  databaseHelper.deleteCardInDeck(
                    card,
                    deck,
                    CardListType.EXTRA_DECK_CARDS,
                  );
                }
              } else if (listType == CardListType.SIDE_DECK_CARDS) {
                if (card.side == 0) {
                  setState(() {
                    card.side++;
                  });
                  databaseHelper.insertCardInDeck(
                    card,
                    deck,
                    CardListType.SIDE_DECK_CARDS,
                  );
                } else if (card.side == 1 || card.extra == 2) {
                  setState(() {
                    card.side++;
                  });
                  databaseHelper.updateCardInDeck(
                    card,
                    deck,
                    CardListType.SIDE_DECK_CARDS,
                  );
                } else if (card.side == 3) {
                  setState(() {
                    card.side = 0;
                  });
                  databaseHelper.deleteCardInDeck(
                    card,
                    deck,
                    CardListType.SIDE_DECK_CARDS,
                  );
                }
              }

              ///In CustomCardListPage() we use these:

              if (deckType == CardListType.MAIN_DECK_CARDS &&
                  listType == CardListType.ADD_CARDS_TO_NEW_DECK) {
                if (card.main == 0) {
                  setState(() {
                    card.main++;
                  });
                  databaseHelper.insertCardInDeck(
                    card,
                    deck,
                    CardListType.MAIN_DECK_CARDS,
                  );
                } else if (card.main == 1 || card.main == 2) {
                  setState(() {
                    card.main++;
                  });
                  databaseHelper.updateCardInDeck(
                    card,
                    deck,
                    CardListType.MAIN_DECK_CARDS,
                  );
                } else if (card.main == 3) {
                  setState(() {
                    card.main = 0;
                  });
                  databaseHelper.deleteCardInDeck(
                    card,
                    deck,
                    CardListType.MAIN_DECK_CARDS,
                  );
                }
              } else if (deckType == CardListType.EXTRA_DECK_CARDS &&
                  listType == CardListType.ADD_CARDS_TO_NEW_DECK) {
                if (card.extra == 0) {
                  setState(() {
                    card.extra++;
                  });
                  databaseHelper.insertCardInDeck(
                    card,
                    deck,
                    CardListType.EXTRA_DECK_CARDS,
                  );
                } else if (card.extra == 1 || card.extra == 2) {
                  setState(() {
                    card.extra++;
                  });
                  databaseHelper.updateCardInDeck(
                    card,
                    deck,
                    CardListType.EXTRA_DECK_CARDS,
                  );
                } else if (card.extra == 3) {
                  setState(() {
                    card.extra = 0;
                  });
                  databaseHelper.deleteCardInDeck(
                    card,
                    deck,
                    CardListType.EXTRA_DECK_CARDS,
                  );
                }
              } else if (deckType == CardListType.SIDE_DECK_CARDS &&
                  listType == CardListType.ADD_CARDS_TO_NEW_DECK) {
                if (card.side == 0) {
                  setState(() {
                    card.side++;
                  });
                  databaseHelper.insertCardInDeck(
                    card,
                    deck,
                    CardListType.SIDE_DECK_CARDS,
                  );
                } else if (card.side == 1 || card.extra == 2) {
                  setState(() {
                    card.side++;
                  });
                  databaseHelper.updateCardInDeck(
                    card,
                    deck,
                    CardListType.SIDE_DECK_CARDS,
                  );
                } else if (card.side == 3) {
                  setState(() {
                    card.side = 0;
                  });
                  databaseHelper.deleteCardInDeck(
                    card,
                    deck,
                    CardListType.SIDE_DECK_CARDS,
                  );
                }
              }
              getAllCardsFromDatabase();
            },
          ),
        ),
      );

    ///ELSE YOU MUST SHOW FAVOURITES ICON
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

  Widget floatingActionButton() {
    if (listType != CardListType.MAIN_DECK_CARDS &&
        listType != CardListType.EXTRA_DECK_CARDS &&
        listType != CardListType.SIDE_DECK_CARDS) {
      return null;
    }

    return FloatingActionButton(
      heroTag: listType,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CustomCardListPage(
                      deck: deck,
                      cardListType: listType,
                    )));
        getAllCardsFromDatabase();
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
      case CardListType.ADD_CARDS_TO_NEW_DECK:
        if (deckType == CardListType.MAIN_DECK_CARDS) {
          futureList = await databaseHelper.getAllCards();
        } else if (deckType == CardListType.EXTRA_DECK_CARDS) {
          futureList = await databaseHelper.getAllExtraDeckCards();
        } else {
          futureList = await databaseHelper.getAllCards();
        }
        break;
      default:
        futureList = await databaseHelper.getAllCards();
        break;
    }

    setState(() {
      this.cardList = futureList;
    });

//    if (searchParams != null && searchParams != '') {
//      List<YuGiOhCard> searchList = List<YuGiOhCard>();
//      for (int i = 0; i < futureList.length; i++) {
//        if (futureList[i]
//                .name
//                .toLowerCase()
//                .trim()
//                .contains(searchParams.toLowerCase().trim()) ||
//            futureList[i]
//                .desc
//                .toLowerCase()
//                .contains(searchParams.toLowerCase())) {
//          searchList.add(futureList[i]);
//        }
//      }
//
//      setState(() {
//        this.cardList = searchList != null ? searchList : List<YuGiOhCard>();
//        this.count = searchList != null ? searchList.length : 0;
//      });
//
//      return;
//    }
  }
}
