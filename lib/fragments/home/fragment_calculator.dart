import 'package:flutter/cupertino.dart';
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

  int lpToCalculate = 0;
  int lpToSubstract = 0;
  int lpPlayer1 = 8000;
  int lpPlayer2 = 8000;
  int selectedContainer = 0;
  List<int> first = [8000];
  List<int> second = [8000];

  Widget buildButton(String text, Color chosenColor, Border chosenBorder) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: chosenBorder),
        child: FlatButton(
          onPressed: () => buttonPressed(text),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          color: chosenColor,
          textColor: Colors.white,
        ),
      ),
    );
  }

  void buttonPressed(String text) {
    if (text.contains('Turn')) {
      //TODO: ADVANCE IN TURN AND UPDATE LOG
      return;
    }
    switch (text) {
      case '0':
        setState(() {
          lpToSubstract *= 10;
        });
        break;
      case '00':
        setState(() {
          lpToSubstract *= 100;
        });
        break;
      case '1':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 1;
        });
        break;
      case '2':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 2;
        });
        break;
      case '3':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 3;
        });
        break;
      case '4':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 4;
        });
        break;
      case '5':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 5;
        });
        break;
      case '6':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 6;
        });
        break;
      case '7':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 7;
        });
        break;
      case '8':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 8;
        });
        break;
      case '9':
        setState(() {
          lpToSubstract = lpToSubstract * 10 + 9;
        });
        break;
      case 'Log':
        //TODO: LP LOG
        break;
      case 'Undo':
        setState(() {
          if (selectedContainer == 1) {
            if (first.length > 1) {
              first.removeLast();
              lpPlayer1 = first.last;
            }
          } else if (selectedContainer == 2) {
            if (second.length > 1) {
              second.removeLast();
              lpPlayer2 = second.last;
            }
          }
        });
        break;
      case '⌫':
        setState(() {
          lpToSubstract = lpToSubstract ~/ 10;
        });
        break;
      case '÷':
        lpToCalculate = lpToSubstract != 0
            ? lpToCalculate ~/= lpToSubstract
            : lpToCalculate;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
      case '×':
        lpToCalculate = lpToCalculate * lpToSubstract;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
      case '-':
        lpToCalculate = lpToCalculate - lpToSubstract;
        if (lpToCalculate < 0) lpToCalculate = 0;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
      case '+':
        lpToCalculate = lpToCalculate + lpToSubstract;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
      case '=':
        lpToCalculate = lpToSubstract;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Color selectedContainerColor = Theme.of(context).primaryColorDark;
    Color unselectedContainerColor = Colors.black54;

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
              //TODO: DICE!
            },
            icon: Icon(DiceIcon.perspective_dice_one),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                lpToCalculate = lpToSubstract = selectedContainer = 0;
                lpPlayer1 = lpPlayer2 = 8000;
                first.clear();
                first.add(8000);
                second.clear();
                second.add(8000);
              });
            },
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 5,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        lpToCalculate = lpPlayer1;
                        selectedContainer = 1;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 0, 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedContainer == 1
                              ? selectedContainerColor
                              : unselectedContainerColor,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Player 1',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$lpPlayer1',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        lpToCalculate = lpPlayer2;
                        selectedContainer = 2;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 8, 8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedContainer == 2
                              ? selectedContainerColor
                              : unselectedContainerColor,
                          width: 3,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Player 2',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '$lpPlayer2',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 11,
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          '$lpToSubstract',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildButton(
                        'Turn 1',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        'Log',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        'Undo',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '⌫',
                        Theme.of(context).accentColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildButton(
                        '7',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '8',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '9',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '÷',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildButton(
                        '4',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '5',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '6',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '×',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildButton(
                        '1',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '2',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '3',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '-',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildButton(
                        '00',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '0',
                        Theme.of(context).primaryColor,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '=',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        '+',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          right: BorderSide(color: Colors.black, width: 1),
                          bottom: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
