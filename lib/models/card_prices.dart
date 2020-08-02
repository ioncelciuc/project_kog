class CardPrices {
  double _cardMarketPrice;
  double _tcgPlayerPrice;
  double _eBayPrice;
  double _amazonPrice;
  double _coolStuffIncPrice;

  CardPrices.initialize(
    this._cardMarketPrice,
    this._tcgPlayerPrice,
    this._eBayPrice,
    this._amazonPrice,
    this._coolStuffIncPrice,
  );

  CardPrices();

  double get coolStuffIncPrice => _coolStuffIncPrice;

  set coolStuffIncPrice(double value) {
    _coolStuffIncPrice = value;
  }

  double get amazonPrice => _amazonPrice;

  set amazonPrice(double value) {
    _amazonPrice = value;
  }

  double get eBayPrice => _eBayPrice;

  set eBayPrice(double value) {
    _eBayPrice = value;
  }

  double get tcgPlayerPrice => _tcgPlayerPrice;

  set tcgPlayerPrice(double value) {
    _tcgPlayerPrice = value;
  }

  double get cardMarketPrice => _cardMarketPrice;

  set cardMarketPrice(double value) {
    _cardMarketPrice = value;
  }


}
