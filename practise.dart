
import 'dart:io';

Future<void> main() async {
  stdout.write("Enter you name: ");

  var name = stdin.readLineSync();

  print("Welcome ${name}");
}


// Future<void> main() async => print('Welcome to dart');

