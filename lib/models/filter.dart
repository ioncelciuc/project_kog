class Filter {
  bool selected;
  String name;

  Filter({String name}) {
    selected = false;
    this.name = name != null ? name : '';
  }
}
