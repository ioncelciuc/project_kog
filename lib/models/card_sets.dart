class CardSets {
  String _setName;
  String _setCode;
  String _setRarity;
  double _setPrice;

  CardSets.initialize(this._setName, this._setCode, [this._setRarity, this._setPrice]);

  CardSets();

  get setName => _setName;

  get setCode => _setCode;

  get setRarity => _setRarity;

  get setPrice => _setPrice;

  set setName(String name) {
    this._setName = setName;
  }

  set setCode(String setCode) {
    this._setCode = setCode;
  }

  set setRarity(String setRarity) {
    this._setRarity = setRarity;
  }

  set setPrice(double setPrice) {
    this._setPrice = setPrice;
  }
}
