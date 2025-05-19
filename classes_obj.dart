import 'dart:io';

void main() {
  stdout.write('Enter Your name: ');
  var name = stdin.readLineSync();
  print('Welcome ${name}');

  BigInt longValue;
  longValue = BigInt.parse('1111111111111111');
  print(longValue);

// Creating a new class object
  var obj = Name();
  obj.printName('Name1');
//
//
  obj.printName('Name2');
//
//
  obj.printName('Name3');
}

class Name {
  
  void printName(String name) {
      print(name);
  }

}