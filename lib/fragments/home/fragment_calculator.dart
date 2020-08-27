import 'package:flutter/material.dart';
import 'package:project_kog/icons/dice_icon_icons.dart';

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
        elevation: 10,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            homeScaffoldState.currentState.openDrawer();
          },
        ),
        title: Text('Calculator'),
        actions: [
          IconButton(
            onPressed: () {
              //show duel log
            },
            icon: Icon(Icons.view_list),
          ),
          IconButton(
            onPressed: () {
              //da cu zarul
            },
            icon: Icon(DiceIcon.perspective_dice_one),
          ),
          IconButton(
            onPressed: () {
              //reset calculator
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Center(
        child: Text('CALCULATOR'),
      ),
    );
  }
}
