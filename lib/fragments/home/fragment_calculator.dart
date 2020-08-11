import 'package:flutter/material.dart';

class FragmentCalculator extends StatefulWidget {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  FragmentCalculator({this.homeScaffoldState});

  @override
  _FragmentCalculatorState createState() =>
      _FragmentCalculatorState(homeScaffoldState: this.homeScaffoldState);
}

class _FragmentCalculatorState extends State<FragmentCalculator> {
  final GlobalKey<ScaffoldState> homeScaffoldState;

  _FragmentCalculatorState({this.homeScaffoldState});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            homeScaffoldState.currentState.openDrawer();
          },
        ),
        title: Text('Calculator'),
      ),
      body: Center(
        child: Text('CALCULATOR'),
      ),
    );
  }
}
