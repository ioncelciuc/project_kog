import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:http/http.dart';

class DataLoad extends StatefulWidget {
  @override
  _DataLoadState createState() => _DataLoadState();
}

class _DataLoadState extends State<DataLoad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SpinKitCircle(color: Colors.blue, size: 80),
          SizedBox(height: 30),
          Text('This is a one-time process!', style: TextStyle(fontSize: 20, color: Colors.red)),
          Text('Data loading, please wait...', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    downloadData();
  }

  Future<void> downloadData() async{
    Response response = await get('https://db.ygoprodeck.com/api/v7/cardinfo.php');
    Map data = jsonDecode(response.body);
    List cards = data['data'];
    print(cards.length);
  }
}
