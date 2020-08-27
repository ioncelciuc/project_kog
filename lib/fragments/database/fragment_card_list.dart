import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/pages/card_detail.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentCardList extends StatefulWidget {
  //0 => all cards
  //1 => banlist
  //-1 => favourites
  //2 => cards specific to an archetype
  final int listType;
  final String searchParams;
  final String archetype;

  FragmentCardList({this.listType, this.searchParams, this.archetype});

  @override
  _FragmentCardListState createState() => _FragmentCardListState(
        listType: this.listType,
        searchParams: this.searchParams,
        archetype: this.archetype,
      );
}

class _FragmentCardListState extends State<FragmentCardList>
    with AutomaticKeepAliveClientMixin<FragmentCardList> {
  int listType;
  String searchParams;
  String archetype;

  _FragmentCardListState({this.listType, this.searchParams, this.archetype});

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
    Icon iconFavourite = Icon(Icons.favorite);
    Icon trailingIcon;
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
        trailingIcon =
            (card.favourite == 0 ? iconFavouriteBorder : iconFavourite);
        return GestureDetector(
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardDetail(card: cardList[index]),
              ),
            );
            getAllCardsFromDatabase(listType, searchParams, archetype);
          },
          onLongPress: () {
            //add to favourites
            //add to a deck
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
                Flexible(
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
                )
                //TODO: IMPLEMENT ADD TO FAVOURITES DIALOG
//                IconButton(
//                  icon: trailingIcon,
//                  onPressed: () {
//                    if (card.favourite == 1) {
//                      card.favourite = 0;
//                      //databaseHelper.updateCard(card);
//                    } else {
//                      card.favourite = 1;
//                      //databaseHelper.updateCard(card);
//                    }
//                    setState(() {
//                      trailingIcon = (card.favourite == 0
//                          ? iconFavouriteBorder
//                          : iconFavourite);
//                      databaseHelper.updateCard(card);
//                      getAllCardsFromDatabase(listType, searchParams, archetype);
//                    });
//                  },
//                ),
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
