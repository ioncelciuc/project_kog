import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/models/filter.dart';

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
          padding: EdgeInsets.all(
              index == 6 ? 0 : (image != null || text != null ? 8 : 0)),
          child: index == 6
              ? Stack(
                  children: [
                    Ink(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.deepOrange[400], Colors.green[500]],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    Center(
                      child: Text(
                        text != null ? text : '',
                        textAlign: TextAlign.center,
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
                      child: Center(
                        child: Text(
                          text != null ? text : '',
                          style: TextStyle(
                            color: index == 5 ? Colors.white : Colors.black,
                          ),
                        ),
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
              child: Text('Card Type', style: TextStyle(fontSize: 20)),
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
              child: Text('Attribute', style: TextStyle(fontSize: 20)),
            ),
            Row(
              children: [
                buildButton(
                  index: 10,
                  text: 'Dark',
                  image: 'assets/attr_dark.png',
                ),
                buildButton(
                  index: 11,
                  text: 'Earth',
                  image: 'assets/attr_earth.png',
                ),
                buildButton(
                  index: 12,
                  text: 'Fire',
                  image: 'assets/attr_fire.png',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 13,
                  text: 'Light',
                  image: 'assets/attr_light.png',
                ),
                buildButton(
                  index: 14,
                  text: 'Water',
                  image: 'assets/attr_water.png',
                ),
                buildButton(
                  index: 15,
                  text: 'Wind',
                  image: 'assets/attr_wind.png',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 16,
                  text: 'Divine',
                  image: 'assets/attr_divine.png',
                ),
                buildUnselectButton(rangeLeft: 10, rangeRight: 16),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('Monster types', style: TextStyle(fontSize: 20)),
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
          ],
        ),
      ),
    );
  }
}
