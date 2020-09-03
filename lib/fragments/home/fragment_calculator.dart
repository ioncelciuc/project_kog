import 'dart:math';
import 'package:flutter/material.dart';
import 'package:project_kog/icons/dice_icon_icons.dart';
import 'package:project_kog/models/log.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FragmentCalculator extends StatefulWidget {
  @override
  _FragmentCalculatorState createState() => _FragmentCalculatorState();
}

class _FragmentCalculatorState extends State<FragmentCalculator> {
  int lpToCalculate = 0;
  int lpToSubstract = 0;
  int lpPlayer1;
  int lpPlayer2;
  int selectedContainer = 0;
  Log first;
  Log second;
  int turn;

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
      setState(() {
        turn++;
      });
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
      case 'Coin':
        showDialog(context: context, builder: (_) => CoinDialog());
        break;
      case 'Undo':
        setState(() {
          if (selectedContainer == 1) {
            if (first.stack.length > 1) {
              first.stack.removeLast();
              lpPlayer1 = first.stack.last;
              lpToCalculate = first.stack.last;
            }
          } else if (selectedContainer == 2) {
            if (second.stack.length > 1) {
              second.stack.removeLast();
              lpPlayer2 = second.stack.last;
              lpToCalculate = second.stack.last;
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
        if (lpToSubstract != 0) {
          lpToCalculate = lpToCalculate ~/= lpToSubstract;
          setState(() {
            if (selectedContainer == 1) {
              lpPlayer1 = lpToCalculate;
              first.stack.add(lpToCalculate);
            } else if (selectedContainer == 2) {
              lpPlayer2 = lpToCalculate;
              second.stack.add(lpToCalculate);
            }
            lpToSubstract = 0;
          });
        }
        break;
      case '×':
        lpToCalculate = lpToCalculate * lpToSubstract;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.stack.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.stack.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
      case '-':
        if (lpToSubstract != 0) {
          lpToCalculate = lpToCalculate - lpToSubstract;
          if (lpToCalculate < 0) lpToCalculate = 0;
          setState(() {
            if (selectedContainer == 1) {
              lpPlayer1 = lpToCalculate;
              first.stack.add(lpToCalculate);
            } else if (selectedContainer == 2) {
              lpPlayer2 = lpToCalculate;
              second.stack.add(lpToCalculate);
            }
            lpToSubstract = 0;
          });
        }
        break;
      case '+':
        if (lpToSubstract != 0) {
          lpToCalculate = lpToCalculate + lpToSubstract;
          setState(() {
            if (selectedContainer == 1) {
              lpPlayer1 = lpToCalculate;
              first.stack.add(lpToCalculate);
            } else if (selectedContainer == 2) {
              lpPlayer2 = lpToCalculate;
              second.stack.add(lpToCalculate);
            }
            lpToSubstract = 0;
          });
        }
        break;
      case '=':
        lpToCalculate = lpToSubstract;
        setState(() {
          if (selectedContainer == 1) {
            lpPlayer1 = lpToCalculate;
            first.stack.add(lpToCalculate);
          } else if (selectedContainer == 2) {
            lpPlayer2 = lpToCalculate;
            second.stack.add(lpToCalculate);
          }
          lpToSubstract = 0;
        });
        break;
    }
  }

  Widget buildResetDialog() {
    return AlertDialog(
      title: Text(
        'Reset LP and number of turns?',
        style: TextStyle(color: Theme.of(context).primaryColor),
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
          onPressed: () {
            setState(() {
              lpToCalculate = lpToSubstract = selectedContainer = 0;
              lpPlayer1 = lpPlayer2 = 8000;
              first.stack.clear();
              first.stack.add(8000);
              second.stack.clear();
              second.stack.add(8000);
              turn = 1;
              saveChanges();
            });
            Navigator.of(context).pop();
          },
          child: Text(
            'Yes',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    callOnInitState();
    super.initState();
  }

  void callOnInitState() async {
    first = Log();
    second = Log();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      lpPlayer1 = sharedPreferences.getInt('lpPlayer1') ?? 8000;
      lpPlayer2 = sharedPreferences.getInt('lpPlayer2') ?? 8000;
      turn = sharedPreferences.getInt('turn') ?? 1;
      selectedContainer = sharedPreferences.getInt('selectedContainer') ?? 0;
      first.getStackFromStringList(
          sharedPreferences.getStringList('first') ?? ['8000']);
      second.getStackFromStringList(
          sharedPreferences.getStringList('second') ?? ['8000']);
    });
  }

  @override
  void dispose() {
    saveChanges();
    super.dispose();
  }

  void saveChanges() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setInt('lpPlayer1', lpPlayer1);
    await sharedPreferences.setInt('lpPlayer2', lpPlayer2);
    await sharedPreferences.setInt('turn', turn);
    await sharedPreferences.setInt('selectedContainer', selectedContainer);
    await sharedPreferences.setStringList('first', first.toStringList());
    await sharedPreferences.setStringList('second', second.toStringList());
  }

  @override
  Widget build(BuildContext context) {
    Color selectedContainerColor = Theme.of(context).primaryColorDark;
    Color unselectedContainerColor = Colors.black54;

    return Scaffold(
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
                              lpPlayer1 != null ? '$lpPlayer1' : '',
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
                              lpPlayer2 != null ? '$lpPlayer2' : '',
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
                        turn != null ? 'Turn $turn' : 'Turn  ',
                        Theme.of(context).primaryColorDark,
                        Border(
                          top: BorderSide(color: Colors.black, width: 1),
                          left: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                      buildButton(
                        'Coin',
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

class DiceDialog extends StatefulWidget {
  @override
  _DiceDialogState createState() => _DiceDialogState();
}

class _DiceDialogState extends State<DiceDialog> {
  @override
  Widget build(BuildContext context) {
    int diceNumber = Random().nextInt(6) + 1;
    return AlertDialog(
//      shape: RoundedRectangleBorder(
//        borderRadius: BorderRadius.all(Radius.circular(5)),
//      ),
      elevation: 11,
      content: Container(
        child: Image.asset(
          'assets/dice$diceNumber.png',
          color: Theme.of(context).primaryColor,
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
          onPressed: () {
            setState(() {
              diceNumber = Random().nextInt(6) + 1;
            });
          },
          child: Text(
            'Roll',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}

class CoinDialog extends StatefulWidget {
  @override
  _CoinDialogState createState() => _CoinDialogState();
}

class _CoinDialogState extends State<CoinDialog> {
  int coin = Random().nextInt(2) + 1;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 11,
      content: Container(
        child: Image.asset('assets/coin$coin.png'),
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
          onPressed: () {
            setState(() {
              coin = Random().nextInt(2) + 1;
            });
          },
          child: Text(
            'Flip',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
        )
      ],
    );
  }
}

//Custom actions
//actions: [
//IconButton(
//onPressed: () {
//saveChanges();
//},
//icon: Icon(Icons.save),
//),
//IconButton(
//onPressed: () {
//showDialog(
//context: context,
//builder: (_) => DiceDialog(),
//barrierDismissible: true,
//);
//},
//icon: Icon(DiceIcon.perspective_dice_one),
//),
//IconButton(
//onPressed: () {
//showDialog(context: context, builder: (_) => buildResetDialog());
//},
//icon: Icon(Icons.refresh),
//),
//],
