import 'package:flutter/material.dart';
import 'package:project_kog/models/archetype.dart';
import 'package:project_kog/pages/card_list.dart';
import 'package:project_kog/utils/card_list_type.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentArchetypes extends StatefulWidget {
  final String searchParams;

  FragmentArchetypes({this.searchParams});

  @override
  _FragmentArchetypesState createState() =>
      _FragmentArchetypesState(searchParams: searchParams);
}

class _FragmentArchetypesState extends State<FragmentArchetypes>
    with AutomaticKeepAliveClientMixin<FragmentArchetypes> {
  String searchParams;

  _FragmentArchetypesState({this.searchParams});

  List<Archetype> archetypeList;

  @override
  void initState() {
    super.initState();
    getAllArchetypesFromDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: archetypeList != null ? archetypeList.length : 0,
      itemBuilder: (context, index) => Card(
        margin: EdgeInsets.fromLTRB(8, 4, 8, 4),
        elevation: 8,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CardList(
                  archetype: archetypeList[index].name,
                  listType: CardListType.ARCHETYPE_CARDS,
                ),
              ),
            );
          },
          title: Text(archetypeList[index].name),
        ),
      ),
    );
  }

  void getAllArchetypesFromDatabase() async {
    final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    List<Archetype> futureArchetypeList =
        await databaseHelper.getAllArchetypes();
    if (searchParams != null && searchParams != '') {
      List<Archetype> archetypeSearchList = List<Archetype>();
      for (int i = 0; i < futureArchetypeList.length; i++) {
        if (futureArchetypeList[i]
            .name
            .toLowerCase()
            .contains(searchParams.toLowerCase())) {
          archetypeSearchList.add(futureArchetypeList[i]);
        }
      }
      setState(() {
        this.archetypeList =
            archetypeSearchList != null ? archetypeSearchList : new List<Archetype>();
      });
      return;
    }
    setState(() {
      this.archetypeList =
          futureArchetypeList != null ? futureArchetypeList : new List<Archetype>();
    });
  }

  @override
  bool get wantKeepAlive => true;
}
