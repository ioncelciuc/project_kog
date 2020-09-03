import 'package:flutter/material.dart';

class FragmentDashboard extends StatefulWidget {

  final GlobalKey<ScaffoldState> homeScaffoldState;

  FragmentDashboard({this.homeScaffoldState});

  @override
  _FragmentDashboardState createState() => _FragmentDashboardState();
}

class _FragmentDashboardState extends State<FragmentDashboard> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            widget.homeScaffoldState.currentState.openDrawer();
          },
        ),
        title: Text('Dash Board'),
      ),
      body: Center(
        child: Text('DASHBOARD'),
      ),
    );
  }
}
