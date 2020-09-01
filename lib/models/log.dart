class Log {
  List<int> stack;

  Log() {
    stack = List<int>();
  }



  List<String> toStringList() {
    List<String> list = List<String>();
    for (int i = 0; i < stack.length; i++) {
      list.add(stack[i].toString());
    }
    return list;
  }

  void getStackFromStringList(List<String> list) {
    stack = List<int>();
    for (int i = 0; i < list.length; i++) {
      stack.add(int.parse(list[i]));
    }
  }
}
