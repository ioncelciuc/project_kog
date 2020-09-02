import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/pages/card_detail.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentCardList extends StatefulWidget {
  //0 => all cards
  //1 => banlist
  //-1 => favourites
  //2 => cards specific to an archetype
  //3 => cards specific to a created deck - MAIN
  //4 => cards specific to a created deck - EXTRA
  //5 => cards specific to a created deck - SIDE
  final int listType;
  final String searchParams;
  final String archetype;
  final Deck deck;

  FragmentCardList(
      {this.listType, this.searchParams, this.archetype, this.deck});

  @override
  _FragmentCardListState createState() => _FragmentCardListState(
        listType: this.listType,
        searchParams: this.searchParams,
        archetype: this.archetype,
        deck: this.deck,
      );
}

class _FragmentCardListState extends State<FragmentCardList>
    with AutomaticKeepAliveClientMixin<FragmentCardList> {
  int listType;
  String searchParams;
  String archetype;
  final Deck deck;

  _FragmentCardListState(
      {this.listType, this.searchParams, this.archetype, this.deck});

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<YuGiOhCard> cardList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getAllCardsFromDatabase(listType, searchParams, archetype);
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Icon iconFavouriteBorder = Icon(Icons.favorite_border);
    Icon iconFavourite = Icon(
      Icons.favorite,
      color: Colors.red,
    );

    return ListView.builder(
      itemCount: count,
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
            if (listType == -1)
              getAllCardsFromDatabase(listType, searchParams, archetype);
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: card.favourite == 0
                          ? iconFavouriteBorder
                          : iconFavourite,
                      onPressed: () async {
                        setState(() {
                          if (card.favourite == 1)
                            card.favourite = 0;
                          else
                            card.favourite = 1;
                        });
                        databaseHelper.updateCard(card);
                        if (listType == -1)
                          getAllCardsFromDatabase(
                              listType, searchParams, archetype);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void getAllCardsFromDatabase(
      int listType, String searchParams, String archetype) async {
    List<YuGiOhCard> futureList;

    switch (listType) {
      case 0:
        futureList = await databaseHelper.getAllCards();
        break;
      case 1:
        futureList = await databaseHelper.getAllBanlistCards();
        break;
      case -1:
        futureList = await databaseHelper.getAllFavouriteCards();
        break;
      case 2:
        futureList = await databaseHelper.getAllArchetypeCards(archetype);
        break;
      case 3:
        futureList =
            await databaseHelper.getAllCardsRelatedToDeck(deck, 'main');
        break;
      case 4:
        futureList =
            await databaseHelper.getAllCardsRelatedToDeck(deck, 'extra');
        break;
      case 5:
        futureList =
            await databaseHelper.getAllCardsRelatedToDeck(deck, 'side');
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
        this.cardList = searchList != null ? searchList : List<YuGiOhCard>();
        this.count = searchList != null ? searchList.length : 0;
      });

      return;
    }

    setState(() {
      this.cardList = futureList != null ? futureList : List<YuGiOhCard>();
      this.count = futureList != null ? futureList.length : 0;
    });
  }
}
