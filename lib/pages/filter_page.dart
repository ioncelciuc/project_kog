import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/models/filter.dart';
import 'dart:math' as math;

class FilterPage extends StatefulWidget {
  final List<Filter> filterList;

  FilterPage({this.filterList});

  @override
  _FilterPageState createState() =>
      _FilterPageState(filterList: this.filterList);
}

class _FilterPageState extends State<FilterPage> {
  List<Filter> filterList;
  final List<Filter> initialFilterList = new List<Filter>();

  _FilterPageState({this.filterList});

  Widget buildButton(
      {int index, String text, Color buttonColor, String image}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        height: 50,
        child: FlatButton(
          color: buttonColor != null ? buttonColor : null,
          onPressed: () {
            setState(() {
              filterList[index].selected = !filterList[index].selected;
            });
          },
          padding: EdgeInsets.all(index == 6 || index == 48 || index == 49
              ? 0
              : (image != null || text != null ? 8 : 0)),
          child: index == 6 || index == 48 || index == 49
              ? Stack(
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: index == 6
                              ? [Colors.deepOrange[400], Colors.green[500]]
                              : [Colors.green[500], Colors.pink[700]],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(0),
                      ),
                    ),
                    Center(
                      child: Text(
                        text != null ? text : '',
                        style: TextStyle(
                          color: index == 5 ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(
                      flex: image != null ? 1 : 0,
                      child: image != null
                          ? Image.asset(image, height: 34, width: 34)
                          : Container(color: Colors.red),
                    ),
                    Expanded(
                      flex: image != null ? 2 : 1,
                      child: Text(
                        text != null ? text : '',
                        style: TextStyle(
                          color: index == 5 ? Colors.white : Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: filterList[index].selected == true
                  ? Theme.of(context).primaryColorDark
                  : Colors.grey,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }

  Widget buildLinkButton({int index, double angle}) {
    return Container(
      height: 50,
      width: 50,
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90),
          border: Border.all(
              width: 5,
              color: filterList[index].selected
                  ? Theme.of(context).primaryColor
                  : Colors.grey)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: Colors.white,
          onPressed: () {
            setState(() {
              filterList[index].selected = !filterList[index].selected;
            });
          },
          child: Transform.rotate(
            angle: angle * math.pi / 180,
            child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildUnselectButton({int rangeLeft, int rangeRight}) {
    return Expanded(
      child: Container(
        margin: EdgeInsets.all(4),
        height: 50,
        child: FlatButton(
          color: Colors.red,
          onPressed: () {
            setState(() {
              for (int i = rangeLeft; i <= rangeRight; i++)
                filterList[i].selected = false;
            });
          },
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: Colors.grey,
              width: 2,
              style: BorderStyle.solid,
            ),
            borderRadius: BorderRadius.circular(0),
          ),
          child: Icon(
            Icons.clear,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    for (int i = 0; i < filterList.length; i++) {
      initialFilterList.add(new Filter(name: filterList[i].name));
      initialFilterList[i].selected = filterList[i].selected;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, initialFilterList);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filter Results'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, filterList);
              },
            ),
          ],
        ),
        body: ListView(
          children: [
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('CARD TYPES', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildButton(
                  index: 0,
                  buttonColor: Colors.yellow[300],
                  text: 'NORMAL',
                ),
                buildButton(
                  index: 1,
                  buttonColor: Colors.deepOrange[400],
                  text: 'EFFECT',
                ),
                buildButton(
                  index: 2,
                  buttonColor: Colors.indigoAccent[100],
                  text: 'RITUAL',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 3,
                  buttonColor: Colors.deepPurple[400],
                  text: 'FUSION',
                ),
                buildButton(
                  index: 4,
                  buttonColor: Colors.white60,
                  text: 'SYNCHRO',
                ),
                buildButton(
                  index: 5,
                  buttonColor: Colors.black87,
                  text: 'XYZ',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 6,
                  text: 'PENDULUM',
                ),
                buildButton(
                  index: 7,
                  buttonColor: Colors.green[500],
                  text: 'SPELL',
                ),
                buildButton(
                  index: 8,
                  buttonColor: Colors.pink[700],
                  text: 'TRAP',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 9,
                  buttonColor: Colors.blue[900],
                  text: 'LINK',
                ),
                buildUnselectButton(rangeLeft: 0, rangeRight: 9),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('ATTRIBUTES', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildButton(
                  index: 10,
                  text: filterList[10].name,
                  image: 'assets/attr_dark.png',
                ),
                buildButton(
                  index: 11,
                  text: filterList[11].name,
                  image: 'assets/attr_earth.png',
                ),
                buildButton(
                  index: 12,
                  text: filterList[12].name,
                  image: 'assets/attr_fire.png',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 13,
                  text: filterList[13].name,
                  image: 'assets/attr_light.png',
                ),
                buildButton(
                  index: 14,
                  text: filterList[14].name,
                  image: 'assets/attr_water.png',
                ),
                buildButton(
                  index: 15,
                  text: filterList[15].name,
                  image: 'assets/attr_wind.png',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 16,
                  text: filterList[16].name,
                  image: 'assets/attr_divine.png',
                ),
                buildUnselectButton(rangeLeft: 10, rangeRight: 16),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('MONSTER TYPES 1', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildButton(
                  index: 17,
                  text: filterList[17].name,
                ),
                buildButton(
                  index: 18,
                  text: filterList[18].name,
                ),
                buildButton(
                  index: 19,
                  text: filterList[19].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 20,
                  text: filterList[20].name,
                ),
                buildButton(
                  index: 21,
                  text: filterList[21].name,
                ),
                buildButton(
                  index: 22,
                  text: filterList[22].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 23,
                  text: filterList[23].name,
                ),
                buildButton(
                  index: 24,
                  text: filterList[24].name,
                ),
                buildButton(
                  index: 25,
                  text: filterList[25].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 26,
                  text: filterList[26].name,
                ),
                buildButton(
                  index: 27,
                  text: filterList[27].name,
                ),
                buildButton(
                  index: 28,
                  text: filterList[28].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 29,
                  text: filterList[29].name,
                ),
                buildButton(
                  index: 30,
                  text: filterList[30].name,
                ),
                buildButton(
                  index: 31,
                  text: filterList[31].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 32,
                  text: filterList[32].name,
                ),
                buildButton(
                  index: 33,
                  text: filterList[33].name,
                ),
                buildButton(
                  index: 34,
                  text: filterList[34].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 35,
                  text: filterList[35].name,
                ),
                buildButton(
                  index: 36,
                  text: filterList[36].name,
                ),
                buildButton(
                  index: 37,
                  text: filterList[37].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 38,
                  text: filterList[38].name,
                ),
                buildButton(
                  index: 39,
                  text: filterList[39].name,
                ),
                buildButton(
                  index: 40,
                  text: filterList[40].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 41,
                  text: filterList[41].name,
                ),
                buildUnselectButton(rangeLeft: 17, rangeRight: 41),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('MONSTER TYPES 2', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildButton(
                  index: 42,
                  text: filterList[42].name,
                ),
                buildButton(
                  index: 43,
                  text: filterList[43].name,
                ),
                buildButton(
                  index: 44,
                  text: filterList[44].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 45,
                  text: filterList[45].name,
                ),
                buildButton(
                  index: 46,
                  text: filterList[46].name,
                ),
                buildButton(
                  index: 47,
                  text: filterList[47].name,
                ),
              ],
            ),
            Row(
              children: [
                buildUnselectButton(rangeLeft: 42, rangeRight: 47),
                Expanded(flex: 2, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('SPELL/TRAP TYPES', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildButton(
                  index: 48,
                  text: filterList[48].name,
                ),
                buildButton(
                  index: 49,
                  text: filterList[49].name,
                ),
                buildButton(
                  index: 50,
                  text: filterList[50].name,
                  buttonColor: Colors.green[500],
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 51,
                  text: filterList[51].name,
                  buttonColor: Colors.green[500],
                ),
                buildButton(
                  index: 52,
                  text: filterList[52].name,
                  buttonColor: Colors.green[500],
                ),
                buildButton(
                  index: 53,
                  text: filterList[53].name,
                  buttonColor: Colors.green[500],
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 54,
                  text: filterList[54].name,
                  buttonColor: Colors.pink[700],
                ),
                buildUnselectButton(rangeLeft: 48, rangeRight: 54),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('LINK ARROWS', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildLinkButton(index: 55, angle: 225),
                buildLinkButton(index: 56, angle: 270),
                buildLinkButton(index: 57, angle: 315),
              ],
            ),
            Row(
              children: [
                buildLinkButton(index: 58, angle: 180),
                Container(
                  height: 50,
                  width: 50,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(90),
                      border: Border.all(width: 5, color: Colors.grey)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(90),
                    child: FlatButton(
                      padding: EdgeInsets.all(0),
                      color: Colors.red,
                      onPressed: () {
                        setState(() {
                          for (int i = 55; i < 63; i++)
                            filterList[i].selected = false;
                        });
                      },
                      child: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                buildLinkButton(index: 59, angle: 0),
              ],
            ),
            Row(
              children: [
                buildLinkButton(index: 60, angle: 135),
                buildLinkButton(index: 61, angle: 90),
                buildLinkButton(index: 62, angle: 45),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
