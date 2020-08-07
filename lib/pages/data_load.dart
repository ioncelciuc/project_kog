import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';
import 'package:project_kog/models/card.dart';
import 'package:project_kog/pages/home.dart';
import 'package:project_kog/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class DataLoad extends StatefulWidget {
  @override
  _DataLoadState createState() => _DataLoadState();
}

class _DataLoadState extends State<DataLoad> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;

  List<Widget> widgetList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widgetList,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    appOpened();
  }

  void appOpened() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    bool openedForTheFirstTime = sharedPreferences.getBool('OPENED_FOR_THE_FIRST_TIME') ?? true;
    if(openedForTheFirstTime == true) {
      setState(() {
        widgetList = [
          SpinKitCircle(color: Colors.blue, size: 80),
          SizedBox(height: 30),
          Text('This is a one-time process!',
              style: TextStyle(fontSize: 20, color: Colors.red)),
          Text('Data loading, please wait...', style: TextStyle(fontSize: 20)),
          Text('This may take some time...', style: TextStyle(fontSize: 20)),
        ];
      });
      await downloadData();
      sharedPreferences.setBool('OPENED_FOR_THE_FIRST_TIME', false);
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()));
  }

  Future<void> downloadData() async {
    Response response =
        await get('https://db.ygoprodeck.com/api/v7/cardinfo.php');
    Map data = jsonDecode(response.body);
    List cards = data['data'];
    for (int i = 0; i < cards.length; i++) {
      YuGiOhCard card = YuGiOhCard();
      card.id = cards[i]['id'];
      card.name = cards[i]['name'];
      card.type = cards[i]['type'];
      card.desc = cards[i]['desc'];
      if (cards[i]['atk'] != null) {
        card.atk = cards[i]['atk'];
      }
      if (cards[i]['def'] != null) {
        card.def = cards[i]['def'];
      }
      if (cards[i]['level'] != null) {
        card.level = cards[i]['level'];
      }
      card.race = cards[i]['race'];
      if (cards[i]['attribute'] != null) {
        card.attribute = cards[i]['attribute'];
      }
      if (cards[i]['archetype'] != null) {
        card.archetype = cards[i]['archetype'];
      }
      if (cards[i]['atk'] != null) {
        card.scale = cards[i]['scale'];
      }
      if (cards[i]['linkval'] != null) {
        card.linkval = cards[i]['linkval'];
      }
      if (card.linkval != 0) {
        List<dynamic> linkList = cards[i]['linkmarkers'];
        for (int i = 0; i < linkList.length; i++) {
          switch (linkList[i]) {
            case 'Top':
              card.linkTop = 1;
              break;
            case 'Top-Right':
              card.linkTopRight = 1;
              break;
            case 'Right':
              card.linkRight = 1;
              break;
            case 'Bottom-Right':
              card.linkBottomRight = 1;
              break;
            case 'Bottom':
              card.linkBottom = 1;
              break;
            case 'Bottom-Left':
              card.linkBottomLeft = 1;
              break;
            case 'Left':
              card.linkLeft = 1;
              break;
            case 'Top-Left':
              card.linkTopLeft = 1;
              break;
          }
        }
      }
      if (cards[i]['card_prices'][0]['cardmarket_price'] != null) {
        card.priceCardMarket =
            double.parse(cards[i]['card_prices'][0]['cardmarket_price']);
      }
      if (cards[i]['card_prices'][0]['tcgplayer_price'] != null) {
        card.priceTcgPlayer =
            double.parse(cards[i]['card_prices'][0]['tcgplayer_price']);
      }
      if (cards[i]['card_prices'][0]['ebay_price'] != null) {
        card.priceEbay = double.parse(cards[i]['card_prices'][0]['ebay_price']);
      }
      if (cards[i]['card_prices'][0]['amazon_price'] != null) {
        card.priceAmazon =
            double.parse(cards[i]['card_prices'][0]['amazon_price']);
      }
      if (cards[i]['card_prices'][0]['coolstuffinc_price'] != null) {
        card.priceCoolStuffInc =
            double.parse(cards[i]['card_prices'][0]['coolstuffinc_price']);
      }
      if (cards[i]['banlist_info'] != null) {
        if (cards[i]['banlist_info']['ban_tcg'] != null) {
          card.banlistTcg = cards[i]['banlist_info']['ban_tcg'] == 'Limited'
              ? 1
              : (cards[i]['banlist_info']['ban_tcg'] == 'Semi-Limited' ? 2 : 0);
        }
        if (cards[i]['banlist_info']['ban_ocg'] != null) {
          card.banlistOcg = cards[i]['banlist_info']['ban_ocg'] == 'Limited'
              ? 1
              : (cards[i]['banlist_info']['ban_ocg'] == 'Semi-Limited' ? 2 : 0);
        }
      }
      card.imageUrl = cards[i]['card_images'][0]['image_url'];
      card.imageUrlSmall = cards[i]['card_images'][0]['image_url_small'];
      await databaseHelper.insertCard(card);
    }
  }
}
