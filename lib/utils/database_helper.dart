import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:project_kog/models/archetype.dart';
import 'package:project_kog/models/deck.dart';
import 'package:project_kog/utils/card_list_type.dart';
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
  static final String colFavourite = 'favourite';
  static final String colMain = 'main';
  static final String colExtra = 'extra';
  static final String colSide = 'side';

  // only uses id and name
  static final String tableArchetypes = 'table_archetypes';

  // only uses id and name
  static final String tableDecks = 'table_decks';

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
        '$colPriceCoolStuffInc FLOAT,'
        '$colFavourite INTEGER,'
        '$colMain INTEGER,'
        '$colExtra INTEGER,'
        '$colSide INTEGER'
        ')');

    await db.execute('CREATE TABLE $tableArchetypes '
        '('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colName TEXT'
        ')');

    await db.execute('CREATE TABLE $tableDecks'
        '('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$colName TEXT'
        ')');
  }

  /// CUSTOM QUERY

  //Get all banlist
  Future<List<Map<String, dynamic>>> getAllBanlistCardsAsMaps() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $tableCards WHERE NOT $colBanlistTcg = 3 ORDER BY $colBanlistTcg, $colType, $colName');
  }

  Future<List<YuGiOhCard>> getAllBanlistCards() async {
    var cardMapList = await getAllBanlistCardsAsMaps();
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for (int i = 0; i < cardMapList.length; i++) {
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  //Get all favourites
  Future<List<Map<String, dynamic>>> getAllFavouriteCardsAsMaps() async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $tableCards WHERE $colFavourite = 1 ORDER BY $colName asc');
  }

  Future<List<YuGiOhCard>> getAllFavouriteCards() async {
    var cardMapList = await getAllFavouriteCardsAsMaps();
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for (int i = 0; i < cardMapList.length; i++) {
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  // Get all cards specific to an archetype
  Future<List<Map<String, dynamic>>> getAllArchetypeCardsAsMaps(
      String archetype) async {
    Database db = await instance.database;
    return await db.rawQuery(
        'SELECT * FROM $tableCards WHERE $colArchetype = \'$archetype\' ORDER BY $colName ASC');
  }

  Future<List<YuGiOhCard>> getAllArchetypeCards(String archetype) async {
    var cardMapList = await getAllArchetypeCardsAsMaps(archetype);
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for (int i = 0; i < cardMapList.length; i++) {
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  /// REGULAR DATABASE

  Future<List<Map<String, dynamic>>> getAllCardsAsMaps() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableCards ORDER BY $colName asc');
  }

  Future<List<YuGiOhCard>> getAllCards() async {
    var cardMapList = await getAllCardsAsMaps();
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for (int i = 0; i < cardMapList.length; i++) {
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  Future<List<Map<String, dynamic>>> getAllExtraDeckCardsAsMaps() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableCards WHERE '
        '$colType LIKE \'Fusion%\' OR '
        '$colType LIKE \'Synchro%\' OR '
        '$colType LIKE \'XYZ%\' OR '
        '$colType LIKE \'Link%\' '
        'ORDER BY $colName asc');
  }

  Future<List<YuGiOhCard>> getAllExtraDeckCards() async {
    var cardMapList = await getAllExtraDeckCardsAsMaps();
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for (int i = 0; i < cardMapList.length; i++) {
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  Future<int> insertCard(YuGiOhCard card) async {
    Database db = await instance.database;
    return await db.insert(tableCards, card.toMap());
  }

  Future<int> updateCard(YuGiOhCard card) async {
    Database db = await instance.database;
    return db.update(
      tableCards,
      card.toMap(),
      where: '$colId = ?',
      whereArgs: [card.id],
    );
  }

  ///Archetypes database

  Future<List<Map<String, dynamic>>> getAllArchetypesAsMaps() async {
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT * FROM $tableArchetypes ORDER BY $colName asc');
  }

  Future<List<Archetype>> getAllArchetypes() async {
    var archetypesMapList = await getAllArchetypesAsMaps();
    List<Archetype> archetypeList = List<Archetype>();
    for (int i = 0; i < archetypesMapList.length; i++) {
      archetypeList.add(Archetype.fromMapToObject(archetypesMapList[i]));
    }
    return archetypeList;
  }

  Future<int> insertArchetype(Archetype archetype) async {
    Database db = await instance.database;
    return await db.insert(tableArchetypes, archetype.toMap());
  }

  ///Decks Database
  Future<List<Map<String, dynamic>>> getAllDecksAsMaps() async {
    Database db = await instance.database;
    return await db.rawQuery('SELECT * FROM $tableDecks ORDER BY $colName asc');
  }

  Future<List<Deck>> getAllDecks() async {
    var decksMapList = await getAllDecksAsMaps();
    List<Deck> decksList = List<Deck>();
    for (int i = 0; i < decksMapList.length; i++) {
      decksList.add(Deck.fromMapToObject(decksMapList[i]));
    }
    return decksList;
  }

  Future<int> insertDeck(Deck deck) async {
    Database db = await instance.database;
    await db.execute('CREATE TABLE ${deck.name}main '
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
        '$colPriceCoolStuffInc FLOAT,'
        '$colFavourite INTEGER,'
        '$colMain INTEGER,'
        '$colExtra INTEGER,'
        '$colSide INTEGER'
        ')');
    await db.execute('CREATE TABLE ${deck.name}extra '
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
        '$colPriceCoolStuffInc FLOAT,'
        '$colFavourite INTEGER,'
        '$colMain INTEGER,'
        '$colExtra INTEGER,'
        '$colSide INTEGER'
        ')');
    await db.execute('CREATE TABLE ${deck.name}side '
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
        '$colPriceCoolStuffInc FLOAT,'
        '$colFavourite INTEGER,'
        '$colMain INTEGER,'
        '$colExtra INTEGER,'
        '$colSide INTEGER'
        ')');
    return await db.insert(tableDecks, deck.toMap());
  }

  Future<int> deleteDeck(Deck deck) async {
    Database db = await instance.database;
    await db.execute('DROP TABLE IF EXISTS ${deck.name}main');
    await db.execute('DROP TABLE IF EXISTS ${deck.name}extra');
    await db.execute('DROP TABLE IF EXISTS ${deck.name}side');
    return await db
        .rawDelete('DELETE FROM $tableDecks WHERE $colId = ${deck.id}');
  }

  Future<List<Map<String, dynamic>>> getAllCardsRelatedToDeckAsMaps(
      Deck deck, String deckType) async {
    Database db = await instance.database;
    return await db
        .rawQuery('SELECT * FROM ${deck.name}$deckType ORDER BY $colType asc');
  }

  Future<List<YuGiOhCard>> getAllCardsRelatedToDeck(
      Deck deck, CardListType cardListType) async {
    String deckType = cardListType == CardListType.MAIN_DECK_CARDS
        ? 'main'
        : (cardListType == CardListType.EXTRA_DECK_CARDS ? 'extra' : 'side');
    var cardMapList = await getAllCardsRelatedToDeckAsMaps(deck, deckType);
    List<YuGiOhCard> cardList = List<YuGiOhCard>();
    for (int i = 0; i < cardMapList.length; i++) {
      cardList.add(YuGiOhCard.fromMapToObject(cardMapList[i]));
    }
    return cardList;
  }

  Future<int> insertCardInDeck(
      YuGiOhCard card, Deck deck, CardListType cardListType) async {
    String deckType = (cardListType == CardListType.MAIN_DECK_CARDS
        ? 'main'
        : (cardListType == CardListType.EXTRA_DECK_CARDS ? 'extra' : 'side'));
    String tableName = '${deck.name}$deckType';
    Database db = await instance.database;
    return await db.insert(tableName, card.toMap());
  }

  Future<int> updateCardInDeck(
      YuGiOhCard card, Deck deck, CardListType cardListType) async {
    String deckType = (cardListType == CardListType.MAIN_DECK_CARDS
        ? 'main'
        : (cardListType == CardListType.EXTRA_DECK_CARDS ? 'extra' : 'side'));
    String tableName = '${deck.name}$deckType';
    Database db = await instance.database;
    return db.update(
      tableName,
      card.toMap(),
      where: '$colId = ?',
      whereArgs: [card.id],
    );
  }

  Future<int> deleteCardInDeck(
      YuGiOhCard card, Deck deck, CardListType cardListType) async {
    String deckType = cardListType == CardListType.MAIN_DECK_CARDS
        ? 'main'
        : (cardListType == CardListType.EXTRA_DECK_CARDS ? 'extra' : 'side');
    String tableName = '${deck.name}$deckType';
    Database db = await instance.database;
    return await db
        .rawDelete('DELETE FROM $tableName WHERE $colId = ${card.id}');
  }
}
