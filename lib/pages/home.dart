import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/fragments/home/fragment_dashboard.dart';
import 'package:project_kog/fragments/home/fragment_decks.dart';
import 'package:project_kog/fragments/home/fragment_calculator.dart';
import 'package:project_kog/fragments/home/fragment_favourites.dart';
import 'package:project_kog/pages/settings.dart';

import '../fragments/home/fragment_database.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem({this.title, this.icon});
}

class Home extends StatefulWidget {
  final drawerItems = [
    DrawerItem(title: 'DashBoard', icon: Icons.dashboard),
    DrawerItem(title: 'Database', icon: Icons.view_list),
    DrawerItem(title: 'Calculator', icon: Icons.computer),
    DrawerItem(title: 'Favourites', icon: Icons.favorite),
    DrawerItem(title: 'My Decks', icon: Icons.business_center),
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos, GlobalKey<ScaffoldState> homeScaffoldState) {
    switch (pos) {
      case 0:
        return FragmentDashboard(homeScaffoldState: homeScaffoldState);
      case 1:
        return FragmentDatabase(homeScaffoldState: homeScaffoldState);
      case 2:
        return FragmentCalculator(homeScaffoldState: homeScaffoldState);
      case 3:
        return FragmentFavourites(homeScaffoldState: homeScaffoldState);
      case 4:
        return FragmentDecks(homeScaffoldState: homeScaffoldState);
    }
  }

  _onSelectItem(int index) {
    if (_selectedDrawerIndex == index) {
      Navigator.of(context).pop();
    } else {
      setState(() => _selectedDrawerIndex = index);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (int i = 0; i < widget.drawerItems.length; i++) {
      DrawerItem drawerItem = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(drawerItem.icon),
        title: Text(drawerItem.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }
    final GlobalKey<ScaffoldState> _homeScaffoldState =
        GlobalKey<ScaffoldState>();
    return Scaffold(
      key: _homeScaffoldState,
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(
                'Companion App',
                style: TextStyle(fontSize: 20),
              ),
              accountEmail: Text('Still in development'),
            ),
            Column(children: drawerOptions),
            Divider(
              color: Colors.grey,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Settings()),
                );
              },
            ),
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex, _homeScaffoldState),
    );
  }
}
