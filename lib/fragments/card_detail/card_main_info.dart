import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/models/card.dart';

class CardMainInfo extends StatelessWidget {

  final YuGiOhCard card;

  CardMainInfo({this.card});

  @override
  Widget build(BuildContext context) {

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

    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: ListView(
        children: [
          Card(
            margin: EdgeInsets.all(12),
            elevation: 4,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CachedNetworkImage(
                        imageUrl: card.imageUrl,
                        placeholder: (context, url) =>
                            Image.asset('assets/card_back.jpg'),
                        errorWidget: (context, url, error) =>
                            Image.asset('assets/card_back.jpg'),
                      ),
                    ),
                    Text(
                      card.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Text(generalInfo),
                    Text(stats),
                    Text('${card.id}'),
                  ],
                ),
              ),
            ),
          ),
          Card(
            margin: EdgeInsets.fromLTRB(12, 0, 12, 12),
            elevation: 4,
            child: Container(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(card.desc),
              ),
            ),
          ),
        ],
      ),
    );

  }
}
