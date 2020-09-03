import 'package:flutter/material.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/pages/deck_page.dart';
import 'package:project_kog/utils/database_helper.dart';

class FragmentDecks extends StatefulWidget {
  @override
  _FragmentDecksState createState() => _FragmentDecksState();
}

class _FragmentDecksState extends State<FragmentDecks> {
  final DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Deck> deckList;
  int count = 0;

  Widget insertDeckDialog() {
    TextEditingController deckNameController = TextEditingController();
    return AlertDialog(
      title: Text('Insert new deck!'),
      content: Container(
        child: Padding(
          padding: EdgeInsets.all(8),
          child: TextField(
            controller: deckNameController,
            decoration: InputDecoration(
              labelText: 'Deck name',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
            ),
          ),
        ),
      ),
      actions: [
        FlatButton(
          hoverColor: Theme.of(context).accentColor,
          splashColor: Theme.of(context).accentColor,
          highlightColor: Theme.of(context).accentColor,
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'Cancel',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
        FlatButton(
          hoverColor: Theme.of(context).accentColor,
          splashColor: Theme.of(context).accentColor,
          highlightColor: Theme.of(context).accentColor,
          onPressed: () async {
            bool different = true;
            if (deckNameController.text.trim().contains(' ')) {
              different = false;
              Navigator.of(context).pop();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text(
                  'Only use letters of the English alphabet and numbers. No spaces between words allowed!',
                ),
              ));
            } else {
              for (int i = 0; i < deckList.length && different == true; i++)
                if (deckList[i].name.toLowerCase().trim() ==
                    deckNameController.text.toLowerCase().trim()) {
                  different = false;
                  Navigator.of(context).pop();
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text(
                      'Name already in use! Try changing at least a letter or adding a new one!',
                    ),
                  ));
                }
            }
            if (different == true) {
              Deck deck = new Deck();
              deck.name = deckNameController.text.trim();
              await databaseHelper.insertDeck(deck);
              Navigator.of(context).pop();
            }
          },
          child: Text(
            'Accept',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    getAllDecksFromDatabase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: count,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              elevation: 5,
              child: ListTile(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DeckPage(deck: deckList[index])));
                },
                title: Text('${deckList[index].name}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    await databaseHelper.deleteDeck(deckList[index]);
                    getAllDecksFromDatabase();
                  },
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () async {
          await showDialog(
              context: context, builder: (_) => insertDeckDialog());
          getAllDecksFromDatabase();
        },
      ),
    );
  }

  void getAllDecksFromDatabase() async {
    List<Deck> futureList;
    futureList = await databaseHelper.getAllDecks();
    setState(() {
      deckList = futureList != null ? futureList : List<Deck>();
      count = futureList != null ? futureList.length : 0;
    });
  }
}
