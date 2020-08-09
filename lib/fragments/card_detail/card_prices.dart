import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/models/card.dart';

class CardPrices extends StatelessWidget {
  final YuGiOhCard card;

  CardPrices({this.card});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/cardmarket.png',
                    width: 200,
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        '${card.priceCardMarket}\$',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/tcgplayer.jpg',
                    width: 200,
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        '${card.priceTcgPlayer}\$',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/amazon.png',
                    width: 200,
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        '${card.priceAmazon}\$',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/ebay.png',
                    width: 200,
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        '${card.priceEbay}\$',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Container(
              padding: EdgeInsets.all(8),
              child: Row(
                children: [
                  Image.asset(
                    'assets/coolstuffinc.png',
                    width: 200,
                    height: 50,
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      margin: EdgeInsets.only(right: 8),
                      child: Text(
                        '${card.priceCoolStuffInc}\$',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
