import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/fragments/fragment_calculator.dart';
import 'package:project_kog/fragments/fragment_favourites.dart';
import 'package:project_kog/pages/settings.dart';

import '../fragments/fragment_database.dart';

class DrawerItem {
  String title;
  IconData icon;

  DrawerItem({this.title, this.icon});
}

class Home extends StatefulWidget {
  final drawerItems = [
    DrawerItem(title: 'Database', icon: Icons.view_list),
    DrawerItem(title: 'Calculator', icon: Icons.computer),
    DrawerItem(title: 'Favourites', icon: Icons.favorite),
  ];

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return FragmentDatabase();
      case 1:
        return FragmentCalculator();
      case 2:
        return FragmentFavourites();

      default:
        return Center(child: Text('ERROR', style: TextStyle(fontSize: 25)));
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop();
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
    return Scaffold(
      appBar:
          AppBar(title: Text(widget.drawerItems[_selectedDrawerIndex].title)),
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
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
