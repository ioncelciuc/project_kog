class Archetype {
  int _id;
  String _name;

  Archetype.fullConstructor(this._name, [this._id]);

  Archetype() {
    this._name = '';
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = new Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = this._name;
    return map;
  }

  Archetype.fromMapToObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
  }
}
