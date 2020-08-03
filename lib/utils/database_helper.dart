import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String table_cards = 'cards_table';
  String colId = 'id';
  String colName = 'name';
  String colType = 'type';
  String colDesc = 'desc';
  String colAtk = 'atk';
  String colDef = 'def';
  String colLevel = 'level';
  String colRace = 'race';
  String colAttribute = 'attribute';
  String colArchetype = 'archetype';
  String colScale = 'scale';
  String colLinkval = 'linkval';
  String colLinkTop = 'linkTop';
  String colLinkTopRight = 'linkTopRight';
  String colLinkRight = 'linkRight';
  String colLinkBottomRight = 'linkBottomRight';
  String colLinkBottom = 'linkBottom';
  String colLinkBottomLeft = 'linkBottomLeft';
  String colLinkLeft = 'linkLeft';
  String colLinkTopLeft = 'linkTopLeft';
  String colPriceCardMarket = 'priceCardMarket';
  String colPriceTcgPlayer = 'priceTcgPlayer';
  String colPriceEbay = 'priceEbay';
  String colPriceAmazon = 'priceAmazon';
  String colPriceCoolStuffInc = 'priceCoolStuffInc';
  String colImageUrl = 'imageUrl';
  String colImageUrlSmall = 'imageUrlSmall';

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = new DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'cards.db';
    Database cardsDatabase =
        await openDatabase(path, version: 1, onCreate: _createDb);
    print('DATABASE CREATED!');
    return cardsDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute('CREATE TABLE $table_cards'
        '('
        '$colId INTEGER PRIMARY KEY,'
        '$colName TEXT,'
        '$colType TEXT,'
        '$colDesc TEXT,'
        '$colAtk INTEGER,'
        '$colDef INTEGER,'
        '$colLevel INTEGER,'
        '$colRace TEXT,'
        '$colAttribute TEXT,'
        '$colArchetype TEXT,'
        '$colScale INTEGER,'
        '$colLinkval INTEGER,'
        '$colLinkTop INTEGER,'
        '$colLinkTopRight INTEGER,'
        '$colLinkRight INTEGER,'
        '$colLinkBottomRight INTEGER,'
        '$colLinkBottom INTEGER,'
        '$colLinkBottomLeft INTEGER,'
        '$colLinkLeft INTEGER,'
        '$colLinkTopLeft INTEGER'
        ')');
  }

  void showMessage(){
    print('YUHUUUUU!!!');
  }
}
