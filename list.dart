
void main() {
  var list = [10, 20, 30, 40];
  list.add(50);

  print("${list}");

  var name = [];
  name.insert(0, "name1");
  name.insert(1, "name2");
  name.insert(2, "name3");
  name.addAll(list);

  print("${name}");

  name.replaceRange(0, 2, [1,2,3]);
  print("${name}");

  name.remove(30);
  print("${name}");
}