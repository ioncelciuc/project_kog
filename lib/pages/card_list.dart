import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';
import 'package:project_kog/utils/card_list_type.dart';

class CardList extends StatefulWidget {
  final CardListType listType;
  final String searchParams;
  final String archetype;

  CardList({this.listType, this.searchParams, this.archetype});

  @override
  _CardListState createState() => _CardListState(
        listType: this.listType,
        searchParams: this.searchParams,
        archetype: this.archetype,
      );
}

class _CardListState extends State<CardList> {
  final CardListType listType;
  final String searchParams;
  final String archetype;

  _CardListState({this.listType, this.searchParams, this.archetype});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((archetype != '' && archetype != null)
            ? archetype
            : 'NO TITLE FOUND'),
      ),
      body: FragmentCardList(
        listType: listType,
        archetype: archetype,
      ),
    );
  }
}
