import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';

class FragmentFavourites extends StatefulWidget {
  @override
  _FragmentFavouritesState createState() => _FragmentFavouritesState();
}

class _FragmentFavouritesState extends State<FragmentFavourites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FragmentCardList(listType: 'favourites'),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          SnackBar snackBar = SnackBar(
            content: Text('Not yet implemented'),
            duration: Duration(seconds: 1),
          );
          Scaffold.of(context).showSnackBar(snackBar);
        },
      ),
    );
  }
}
