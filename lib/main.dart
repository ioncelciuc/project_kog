import 'package:flutter/material.dart';
import 'package:project_kog/pages/data_load.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: DataLoad(),
    theme: ThemeData(
      primaryColor: Colors.deepPurple[500],
      primaryColorDark: Colors.deepPurple[700],
      accentColor: Colors.deepPurple[200],
    ),
  ));
}
