import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/pages/card_detail.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentCardList extends StatefulWidget {
  final String listType;

  FragmentCardList({this.listType});

  @override
  _FragmentCardListState createState() =>
      _FragmentCardListState(listType: this.listType);
}

class _FragmentCardListState extends State<FragmentCardList>
    with AutomaticKeepAliveClientMixin<FragmentCardList> {
  String listType;

  _FragmentCardListState({this.listType});

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<YuGiOhCard> cardList;
  int count = 0;

  @override
  void initState() {
    super.initState();
    getAllCardsFromDatabase(listType != null ? listType : 'null');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
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
                      ? '${card.atk} / ${card.def} / SCALE ${card.scale}'
                      : '${card.atk} / ${card.def} / LEVEL ${card.level}')));
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => CardDetail(card: cardList[index])));
            },
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 1,
                    child: CachedNetworkImage(
                      imageUrl: card.imageUrlSmall,
                      placeholder: (context, url) =>
                          Image.asset('assets/card_back.jpg'),
                      errorWidget: (context, url, error) =>
                          Image.asset('assets/card_back.jpg'),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          card.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        Text(generalInfo),
                        Text(stats),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void getAllCardsFromDatabase(String listType) async {
    List<YuGiOhCard> futureList;

    switch (listType) {
      case 'all_cards':
        futureList = await databaseHelper.getAllCards();
        break;
      case 'banlist':
        futureList = await databaseHelper.getAllBanlistCards();
        break;
      case 'null':
        futureList = await databaseHelper.getAllCards();
        break;
    }

    setState(() {
      this.cardList = futureList;
      this.count = futureList.length;
    });
  }
}
