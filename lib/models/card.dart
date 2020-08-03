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
  bool _linkTop;
  bool _linkTopRight;
  bool _linkRight;
  bool _linkBottomRight;
  bool _linkBottom;
  bool _linkBottomLeft;
  bool _linkLeft;
  bool _linkTopLeft;
  double _priceCardMarket;
  double _priceTcgPlayer;
  double _priceEbay;
  double _priceAmazon;
  double _priceCoolStuffInc;

  String _imageUrl;
  String _imageUrlSmall;

  Card(this._id, this._name, this._type, this._desc, this._imageUrl,
      this._imageUrlSmall, this._race,
      [this._atk,
      this._def,
      this._level,
      this._attribute,
      this._archetype,
      this._scale,
      this._linkval,
      this._linkTop,
      this._linkTopRight,
      this._linkRight,
      this._linkBottomRight,
      this._linkBottom,
      this._linkBottomLeft,
      this._linkLeft,
      this._linkTopLeft,
      this._priceCardMarket,
      this._priceTcgPlayer,
      this._priceEbay,
      this._priceAmazon,
      this._priceCoolStuffInc]);

  String get imageUrlSmall => _imageUrlSmall;

  set imageUrlSmall(String value) {
    _imageUrlSmall = value;
  }

  String get imageUrl => _imageUrl;

  set imageUrl(String value) {
    _imageUrl = value;
  }

  double get priceCoolStuffInc => _priceCoolStuffInc;

  set priceCoolStuffInc(double value) {
    _priceCoolStuffInc = value;
  }

  double get priceAmazon => _priceAmazon;

  set priceAmazon(double value) {
    _priceAmazon = value;
  }

  double get priceEbay => _priceEbay;

  set priceEbay(double value) {
    _priceEbay = value;
  }

  double get priceTcgPlayer => _priceTcgPlayer;

  set priceTcgPlayer(double value) {
    _priceTcgPlayer = value;
  }

  double get priceCardMarket => _priceCardMarket;

  set priceCardMarket(double value) {
    _priceCardMarket = value;
  }

  bool get linkTopLeft => _linkTopLeft;

  set linkTopLeft(bool value) {
    _linkTopLeft = value;
  }

  bool get linkLeft => _linkLeft;

  set linkLeft(bool value) {
    _linkLeft = value;
  }

  bool get linkBottomLeft => _linkBottomLeft;

  set linkBottomLeft(bool value) {
    _linkBottomLeft = value;
  }

  bool get linkBottom => _linkBottom;

  set linkBottom(bool value) {
    _linkBottom = value;
  }

  bool get linkBottomRight => _linkBottomRight;

  set linkBottomRight(bool value) {
    _linkBottomRight = value;
  }

  bool get linkRight => _linkRight;

  set linkRight(bool value) {
    _linkRight = value;
  }

  bool get linkTopRight => _linkTopRight;

  set linkTopRight(bool value) {
    _linkTopRight = value;
  }

  bool get linkTop => _linkTop;

  set linkTop(bool value) {
    _linkTop = value;
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

  // Convert Card to Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = this._name;
    map['type'] = this._type;
    map['desc'] = this._desc;
    map['atk'] = this._atk;
    map['def'] = this._def;
    map['level'] = this._level;
    map['race'] = this._race;
    map['attribute'] = this._attribute;
    map['archetype'] = this._archetype;
    map['scale'] = this._scale;
    map['linkval'] = this._linkval;
    map['linkTop'] = this._linkTop;
    map['linkTopRight'] = this._linkTopRight;
    map['linkRight'] = this._linkRight;
    map['linkBottomRight'] = this._linkBottomRight;
    map['linkBottom'] = this._linkBottom;
    map['linkBottomLeft'] = this._linkBottomLeft;
    map['linkLeft'] = this._linkLeft;
    map['linkTopLeft'] = this._linkTopLeft;
    map['priceCardMarket'] = this._priceCardMarket;
    map['priceTcgPlayer'] = this._priceTcgPlayer;
    map['priceEbay'] = this._priceEbay;
    map['priceAmazon'] = this._priceAmazon;
    map['priceCoolStuffInc'] = this._priceCoolStuffInc;
    map['imageUrl'] = this._imageUrl;
    map['imageUrlSmall'] = this._imageUrlSmall;
  }

  // Convert Map to Card
  Card.fromMapToObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._type = map['type'];
    this._desc = map['desc'];
    this._atk = map['atk'];
    this._def = map['def'];
    this._level = map['level'];
    this._race = map['race'];
    this._attribute = map['attribute'];
    this._archetype = map['archetype'];
    this._scale = map['scale'];
    this._linkval = map['linkval'];
    this._linkTop = map['linkTop'];
    this._linkTopRight = map['linkTopRight'];
    this._linkRight = map['linkRight'];
    this._linkBottomRight = map['linkBottomRight'];
    this._linkBottom = map['linkBottom'];
    this._linkBottomLeft = map['linkBottomLeft'];
    this._linkLeft = map['linkLeft'];
    this._linkTopLeft = map['linkTopLeft'];
    this._priceCardMarket = map['priceCardMarket'];
    this._priceTcgPlayer = map['priceTcgPlayer'];
    this._priceEbay = map['priceEbay'];
    this._priceAmazon = map['priceAmazon'];
    this._priceCoolStuffInc = map['priceCoolStuffInc'];
    this._imageUrl = map['imageUrl'];
    this._imageUrlSmall = map['imageUrlSmall'];
  }
}
