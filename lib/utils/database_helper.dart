import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:project_kog/models/card.dart';

class DatabaseHelper {
  static final String _databaseName = 'yugioh_cards.db';
  static final int _databaseVersion = 1;

  static final String tableCards = 'table_cards';
  static final String colId = 'id';
  static final String colName = 'name';
  static final String colType = 'type';
  static final String colDesc = 'desc';
  static final String colAtk = 'atk';
  static final String colDef = 'def';
  static final String colLevel = 'level';
  static final String colRace = 'race';
  static final String colAttribute = 'attribute';
  static final String colArchetype = 'archetype';
  static final String colScale = 'scale';
  static final String colLinkval = 'linkval';
  static final String colLinkTop = 'linkTop';
  static final String colLinkTopRight = 'linkTopRight';
  static final String colLinkRight = 'linkRight';
  static final String colLinkBottomRight = 'linkBottomRight';
  static final String colLinkBottom = 'linkBottom';
  static final String colLinkBottomLeft = 'linkBottomLeft';
  static final String colLinkLeft = 'linkLeft';
  static final String colLinkTopLeft = 'linkTopLeft';
  static final String colPriceCardMarket = 'priceCardMarket';
  static final String colPriceTcgPlayer = 'priceTcgPlayer';
  static final String colPriceEbay = 'priceEbay';
  static final String colPriceAmazon = 'priceAmazon';
  static final String colPriceCoolStuffInc = 'priceCoolStuffInc';
  static final String colImageUrl = 'imageUrl';
  static final String colImageUrlSmall = 'imageUrlSmall';
  static final String colBanlistTcg = 'banlistTcg';
  static final String colBanlistOcg = 'banlistOcg';

  // Make this a singleton class
  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only have an app reference for the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // Lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // This opens the db (or creates it if it doesn't already exist
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE $tableCards '
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
        '$colLinkTopLeft INTEGER,'
        '$colImageUrl TEXT,'
        '$colImageUrlSmall TEXT,'
        '$colBanlistTcg INTEGER,'
        '$colBanlistOcg INTEGER,'
        '$colPriceCardMarket FLOAT,'
        '$colPriceTcgPlayer FLOAT,'
        '$colPriceEbay FLOAT,'
        '$colPriceAmazon FLOAT,'
        '$colPriceCoolStuffInc FLOAT'
        ')');
  }

  Future<List<Map<String, dynamic>>> getAllCardsAsMaps() async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableCards ORDER BY $colName asc');
  }

  Future<List<YuGiOhCard>> getAllCards() async{
    var cardMapList = await getAllCardsAsMaps();
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for(int i=0 ; i< cardMapList.length; i++){
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  Future<List<Map<String, dynamic>>> getAllBanlistCardsAsMaps() async{
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableCards WHERE NOT $colBanlistTcg = 3 ORDER BY $colBanlistTcg, $colType, $colName');
  }

  Future<List<YuGiOhCard>> getAllBanlistCards() async{
    var cardMapList = await getAllBanlistCardsAsMaps();
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for(int i=0 ; i< cardMapList.length; i++){
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  Future<int> insertCard(YuGiOhCard card) async {
    Database db = await instance.database;
    return await db.insert(tableCards, card.toMap());
  }
  
}
