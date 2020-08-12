import 'package:flutter/material.dart';
import 'package:project_kog/fragments/database/fragment_card_list.dart';

class FragmentFavourites extends StatefulWidget {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  FragmentFavourites({this.homeScaffoldState});

  @override
  _FragmentFavouritesState createState() =>
      _FragmentFavouritesState(homeScaffoldState: this.homeScaffoldState);
}

class _FragmentFavouritesState extends State<FragmentFavourites> {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  _FragmentFavouritesState({this.homeScaffoldState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            homeScaffoldState.currentState.openDrawer();
          },
        ),
        title: Text('Favourites'),
      ),
      body: FragmentCardList(listType: -1),
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
