import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/fragments/card_detail/card_main_info.dart';
import 'package:project_kog/fragments/card_detail/card_prices.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/utils/database_helper.dart';

class CardDetail extends StatefulWidget {
  final YuGiOhCard card;

  CardDetail({this.card});

  @override
  _CardDetailState createState() => _CardDetailState(card: this.card);
}

class _CardDetailState extends State<CardDetail> {
  YuGiOhCard card;

  _CardDetailState({this.card});

  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  Icon iconFavouriteBorder = Icon(Icons.favorite_border);
  Icon iconFavourite = Icon(Icons.favorite);
  Icon trailingIcon;

  @override
  Widget build(BuildContext context) {
    trailingIcon = (card.favourite == 0 ? iconFavouriteBorder : iconFavourite);
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text(card.name),
            actions: [
              IconButton(
                icon: trailingIcon,
                onPressed: () {
                  if (card.favourite == 1) {
                    card.favourite = 0;
                  } else {
                    card.favourite = 1;
                  }
                  setState(() {
                    trailingIcon = (card.favourite == 0
                        ? iconFavouriteBorder
                        : iconFavourite);
                    databaseHelper.updateCard(card);
                  });
                },
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'INFO'),
                Tab(text: 'PRICES'),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              CardMainInfo(card: this.card),
              CardPrices(card: this.card),
            ],
          ),
        ),
      ),
    );
  }
}
