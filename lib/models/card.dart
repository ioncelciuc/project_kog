import 'package:project_kog/models/card_images.dart';
import 'package:project_kog/models/card_prices.dart';
import 'package:project_kog/models/card_sets.dart';

class Card {
  int _id;
  String _name;
  String _type;
  String _desc;
  int _atk;
  int _def;
  int _level;
  String _race;
  String _attribute;
  String _archetype;
  int _scale;
  int _linkval;
  List<String> _linkmarkers;
  List<CardSets> _cardSets;
  List<CardImages> _cardImages;
  CardPrices _cardPrices;

  Card.initialize(this._id, this._name, this._type, this._race, this._desc, this._cardImages,
      [this._atk,
      this._def,
      this._level,
      this._attribute,
      this._archetype,
      this._scale,
      this._linkval,
      this._linkmarkers,
      this._cardSets,
      this._cardPrices]);

  Card();

  CardPrices get cardPrices => _cardPrices;

  set cardPrices(CardPrices value) {
    _cardPrices = value;
  }

  List<CardImages> get cardImages => _cardImages;

  set cardImages(List<CardImages> value) {
    _cardImages = value;
  }

  List<CardSets> get cardSets => _cardSets;

  set cardSets(List<CardSets> value) {
    _cardSets = value;
  }

  List<String> get linkmarkers => _linkmarkers;

  set linkmarkers(List<String> value) {
    _linkmarkers = value;
  }

  int get linkval => _linkval;

  set linkval(int value) {
    _linkval = value;
  }

  int get scale => _scale;

  set scale(int value) {
    _scale = value;
  }

  String get archetype => _archetype;

  set archetype(String value) {
    _archetype = value;
  }

  String get attribute => _attribute;

  set attribute(String value) {
    _attribute = value;
  }

  String get race => _race;

  set race(String value) {
    _race = value;
  }

  int get level => _level;

  set level(int value) {
    _level = value;
  }

  int get def => _def;

  set def(int value) {
    _def = value;
  }

  int get atk => _atk;

  set atk(int value) {
    _atk = value;
  }

  String get desc => _desc;

  set desc(String value) {
    _desc = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }
}
