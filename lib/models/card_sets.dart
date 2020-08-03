class CardSets {
  int _id;
  String _name;
  String _code;
  String _rarity;
  double _price;

  CardSets(this._id, this._name, this._code, this._rarity, this._price);

  double get price => _price;

  set price(double value) {
    _price = value;
  }

  String get rarity => _rarity;

  set rarity(String value) {
    _rarity = value;
  }

  String get code => _code;

  set code(String value) {
    _code = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  // Convert CardSets to Map
  Map<String, dynamic> toMap() {
    Map map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = this._name;
    map['code'] = this._code;
    map['rarity'] = this._rarity;
    map['price'] = this._price;
    return map;
  }

  // Convert Map to CardSets
  CardSets.fromMapToObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._code = map['code'];
    this._rarity = map['rarity'];
    this._price = map['price'];
  }

  Map toJson() => {
    'id' : _id,
    'name' : _name,
    'code' : _code,
    'rarity' : _rarity,
    'price' : _price,
  };
}
