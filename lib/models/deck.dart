class Deck{
  int _id;
  String _name;

  Deck(){
    this._name = '';
  }

  Deck.name(String name){
    this._name = name;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    return map;
  }

  Deck.fromMapToObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
  }
}