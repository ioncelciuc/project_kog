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

  _FilterPageState({this.filterList});

  @override
  void initState() {
    super.initState();
  }

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
          padding: EdgeInsets.all(image != null || text != null ? 8 : 0),
          child: index == 6
              ? Ink(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.deepOrange[400], Colors.green[500]],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(0)),
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
                      child: Center(child: Text(text != null ? text : '')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filter Results'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () => Navigator.pop(context, filterList),
          ),
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(4),
            child: Text('Border Color', style: TextStyle(fontSize: 20)),
          ),
          Row(
            children: [
              buildButton(index: 0, buttonColor: Colors.yellow[300]),
              buildButton(index: 1, buttonColor: Colors.deepOrange[400]),
              buildButton(index: 2, buttonColor: Colors.indigoAccent[100]),
            ],
          ),
          Row(
            children: [
              buildButton(index: 3, buttonColor: Colors.deepPurple[400]),
              buildButton(index: 4, buttonColor: Colors.white60),
              buildButton(index: 5, buttonColor: Colors.black87),
            ],
          ),
          Row(
            children: [
              buildButton(index: 6),
              buildButton(index: 7, buttonColor: Colors.green[500]),
              buildButton(index: 8, buttonColor: Colors.pink[700]),
            ],
          ),
          Row(
            children: [
              buildButton(index: 9, buttonColor: Colors.blue[900]),
              Expanded(flex: 2, child: Container()),
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
              Expanded(flex: 2, child: Container()),
            ],
          ),
        ],
      ),
    );
  }
}
