import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/items_bloc.dart';
import 'data/db/database_helper.dart';
import 'presentation/screens/home_screen.dart';

void main() {
  final dbHelper = DatabaseHelper();
  runApp(MyApp(dbHelper: dbHelper));
}

class MyApp extends StatelessWidget {
  final DatabaseHelper dbHelper;
  const MyApp({super.key, required this.dbHelper});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQLite Bloc Demo',
      home: BlocProvider(
        create: (_) => ItemsBloc(dbHelper)..add(LoadItems()),
        child: HomeScreen(),
      ),
    );
  }
}
