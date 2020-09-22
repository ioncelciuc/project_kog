import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_kog/models/filter.dart';
import 'dart:math' as math;

import 'package:project_kog/models/filter_result.dart';

class FilterPage extends StatefulWidget {
  final FilterResult filters;

  FilterPage({this.filters});

  @override
  _FilterPageState createState() =>
      _FilterPageState(filters: this.filters);
}

class _FilterPageState extends State<FilterPage> {

  FilterResult filters;

  _FilterPageState({this.filters});

  FilterResult initialFilters;

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
              filters.filterList[index].selected = !filters.filterList[index].selected;
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
              color: filters.filterList[index].selected == true
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
              color: filters.filterList[index].selected
                  ? Theme.of(context).primaryColor
                  : Colors.grey)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(90),
        child: FlatButton(
          padding: EdgeInsets.all(0),
          color: Colors.white,
          onPressed: () {
            setState(() {
              filters.filterList[index].selected = !filters.filterList[index].selected;
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
                filters.filterList[i].selected = false;
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
    initialFilters = new FilterResult();
    for (int i = 0; i < filters.filterList.length; i++) {
      initialFilters.filterList.add(new Filter(name: filters.filterList[i].name));
      initialFilters.filterList[i].selected = filters.filterList[i].selected;
    }
    double minAtk = filters.currentMinAtkSliderValue;
    double maxAtk = filters.currentMaxAtkSliderValue;
    initialFilters.currentMinAtkSliderValue = minAtk;
    initialFilters.currentMaxAtkSliderValue = maxAtk;
    double minDef = filters.currentMinDefSliderValue;
    double maxDef = filters.currentMaxDefSliderValue;
    initialFilters.currentMinDefSliderValue = minDef;
    initialFilters.currentMaxDefSliderValue = maxDef;
    double minLvl = filters.currentMinLvlSliderValue;
    double maxLvl = filters.currentMaxLvlSliderValue;
    initialFilters.currentMinLvlSliderValue = minLvl;
    initialFilters.currentMaxLvlSliderValue = maxLvl;
    double minScale = filters.currentMinScaleSliderValue;
    double maxScale = filters.currentMaxScaleSliderValue;
    initialFilters.currentMinScaleSliderValue = minScale;
    initialFilters.currentMaxScaleSliderValue = maxScale;
    double minLink = filters.currentMinLinkSliderValue;
    double maxLink = filters.currentMaxLinkSliderValue;
    initialFilters.currentMinLinkSliderValue = minLink;
    initialFilters.currentMaxLinkSliderValue = maxLink;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, initialFilters);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Filter Results'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () {
                Navigator.pop(context, filters);
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
                  text: filters.filterList[10].name,
                  image: 'assets/attr_dark.png',
                ),
                buildButton(
                  index: 11,
                  text: filters.filterList[11].name,
                  image: 'assets/attr_earth.png',
                ),
                buildButton(
                  index: 12,
                  text: filters.filterList[12].name,
                  image: 'assets/attr_fire.png',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 13,
                  text: filters.filterList[13].name,
                  image: 'assets/attr_light.png',
                ),
                buildButton(
                  index: 14,
                  text: filters.filterList[14].name,
                  image: 'assets/attr_water.png',
                ),
                buildButton(
                  index: 15,
                  text: filters.filterList[15].name,
                  image: 'assets/attr_wind.png',
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 16,
                  text: filters.filterList[16].name,
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
                  text: filters.filterList[17].name,
                ),
                buildButton(
                  index: 18,
                  text: filters.filterList[18].name,
                ),
                buildButton(
                  index: 19,
                  text: filters.filterList[19].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 20,
                  text: filters.filterList[20].name,
                ),
                buildButton(
                  index: 21,
                  text: filters.filterList[21].name,
                ),
                buildButton(
                  index: 22,
                  text: filters.filterList[22].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 23,
                  text: filters.filterList[23].name,
                ),
                buildButton(
                  index: 24,
                  text: filters.filterList[24].name,
                ),
                buildButton(
                  index: 25,
                  text: filters.filterList[25].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 26,
                  text: filters.filterList[26].name,
                ),
                buildButton(
                  index: 27,
                  text: filters.filterList[27].name,
                ),
                buildButton(
                  index: 28,
                  text: filters.filterList[28].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 29,
                  text: filters.filterList[29].name,
                ),
                buildButton(
                  index: 30,
                  text: filters.filterList[30].name,
                ),
                buildButton(
                  index: 31,
                  text: filters.filterList[31].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 32,
                  text: filters.filterList[32].name,
                ),
                buildButton(
                  index: 33,
                  text: filters.filterList[33].name,
                ),
                buildButton(
                  index: 34,
                  text: filters.filterList[34].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 35,
                  text: filters.filterList[35].name,
                ),
                buildButton(
                  index: 36,
                  text: filters.filterList[36].name,
                ),
                buildButton(
                  index: 37,
                  text: filters.filterList[37].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 38,
                  text: filters.filterList[38].name,
                ),
                buildButton(
                  index: 39,
                  text: filters.filterList[39].name,
                ),
                buildButton(
                  index: 40,
                  text: filters.filterList[40].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 41,
                  text: filters.filterList[41].name,
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
                  text: filters.filterList[42].name,
                ),
                buildButton(
                  index: 43,
                  text: filters.filterList[43].name,
                ),
                buildButton(
                  index: 44,
                  text: filters.filterList[44].name,
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 45,
                  text: filters.filterList[45].name,
                ),
                buildButton(
                  index: 46,
                  text: filters.filterList[46].name,
                ),
                buildButton(
                  index: 47,
                  text: filters.filterList[47].name,
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
                  text: filters.filterList[48].name,
                ),
                buildButton(
                  index: 49,
                  text: filters.filterList[49].name,
                ),
                buildButton(
                  index: 50,
                  text: filters.filterList[50].name,
                  buttonColor: Colors.green[500],
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 51,
                  text: filters.filterList[51].name,
                  buttonColor: Colors.green[500],
                ),
                buildButton(
                  index: 52,
                  text: filters.filterList[52].name,
                  buttonColor: Colors.green[500],
                ),
                buildButton(
                  index: 53,
                  text: filters.filterList[53].name,
                  buttonColor: Colors.green[500],
                ),
              ],
            ),
            Row(
              children: [
                buildButton(
                  index: 54,
                  text: filters.filterList[54].name,
                  buttonColor: Colors.pink[700],
                ),
                buildUnselectButton(rangeLeft: 48, rangeRight: 54),
                Expanded(flex: 1, child: Container()),
              ],
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('ATTACK', style: TextStyle(fontSize: 20)),
            ),
            RangeSlider(
              onChanged: (RangeValues value) {
                setState(() {
                  filters.currentMinAtkSliderValue = value.start;
                  filters.currentMaxAtkSliderValue = value.end;
                });
              },
              values: RangeValues(
                  filters.currentMinAtkSliderValue, filters.currentMaxAtkSliderValue),
              onChangeStart: (RangeValues value) {
                setState(() {
                  filters.currentMinAtkSliderValue = value.start;
                });
              },
              onChangeEnd: (RangeValues value) {
                setState(() {
                  filters.currentMaxAtkSliderValue = value.end;
                });
              },
              min: 0,
              max: 5000,
              divisions: 50,
              labels: RangeLabels(
                filters.currentMinAtkSliderValue.toStringAsFixed(0),
                filters.currentMaxAtkSliderValue.toStringAsFixed(0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('DEFENCE', style: TextStyle(fontSize: 20)),
            ),
            RangeSlider(
              onChanged: (RangeValues value) {
                setState(() {
                  filters.currentMinDefSliderValue = value.start;
                  filters.currentMaxDefSliderValue = value.end;
                });
              },
              values: RangeValues(
                  filters.currentMinDefSliderValue, filters.currentMaxDefSliderValue),
              onChangeStart: (RangeValues value) {
                setState(() {
                  filters.currentMinDefSliderValue = value.start;
                });
              },
              onChangeEnd: (RangeValues value) {
                setState(() {
                  filters.currentMaxDefSliderValue = value.end;
                });
              },
              min: 0,
              max: 5000,
              divisions: 50,
              labels: RangeLabels(
                filters.currentMinDefSliderValue.toStringAsFixed(0),
                filters.currentMaxDefSliderValue.toStringAsFixed(0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('LEVEL/RANK', style: TextStyle(fontSize: 20)),
            ),
            RangeSlider(
              onChanged: (RangeValues value) {
                setState(() {
                  filters.currentMinLvlSliderValue = value.start;
                  filters.currentMaxLvlSliderValue = value.end;
                });
              },
              values: RangeValues(
                  filters.currentMinLvlSliderValue, filters.currentMaxLvlSliderValue),
              onChangeStart: (RangeValues value) {
                setState(() {
                  filters.currentMinLvlSliderValue = value.start;
                });
              },
              onChangeEnd: (RangeValues value) {
                setState(() {
                  filters.currentMaxLvlSliderValue = value.end;
                });
              },
              min: 0,
              max: 12,
              divisions: 12,
              labels: RangeLabels(
                filters.currentMinLvlSliderValue.toStringAsFixed(0),
                filters.currentMaxLvlSliderValue.toStringAsFixed(0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('SCALE', style: TextStyle(fontSize: 20)),
            ),
            RangeSlider(
              onChanged: (RangeValues value) {
                setState(() {
                  filters.currentMinScaleSliderValue = value.start;
                  filters.currentMaxScaleSliderValue = value.end;
                });
              },
              values: RangeValues(
                  filters.currentMinScaleSliderValue, filters.currentMaxScaleSliderValue),
              onChangeStart: (RangeValues value) {
                setState(() {
                  filters.currentMinScaleSliderValue = value.start;
                });
              },
              onChangeEnd: (RangeValues value) {
                setState(() {
                  filters.currentMaxScaleSliderValue = value.end;
                });
              },
              min: 0,
              max: 12,
              divisions: 12,
              labels: RangeLabels(
                filters.currentMinScaleSliderValue.toStringAsFixed(0),
                filters.currentMaxScaleSliderValue.toStringAsFixed(0),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(4),
              child: Text('LINK', style: TextStyle(fontSize: 20)),
            ),
            RangeSlider(
              onChanged: (RangeValues value) {
                setState(() {
                  filters.currentMinLinkSliderValue = value.start;
                  filters.currentMaxLinkSliderValue = value.end;
                });
              },
              values: RangeValues(
                  filters.currentMinLinkSliderValue, filters.currentMaxLinkSliderValue),
              onChangeStart: (RangeValues value) {
                setState(() {
                  filters.currentMinLinkSliderValue = value.start;
                });
              },
              onChangeEnd: (RangeValues value) {
                setState(() {
                  filters.currentMaxLinkSliderValue = value.end;
                });
              },
              min: 0,
              max: 6,
              divisions: 6,
              labels: RangeLabels(
                filters.currentMinLinkSliderValue.toStringAsFixed(0),
                filters.currentMaxLinkSliderValue.toStringAsFixed(0),
              ),
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
                            filters.filterList[i].selected = false;
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
