import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static const _databaseName = "items.db";
  static const _databaseVersion = 1;

  static const String tableItems = 'items';
  static const String createItemsTableQuery =
      'CREATE TABLE $tableItems (id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute(createItemsTableQuery);
      },
    );
  }

  Future<void> insertItem(String name) async {
    final db = await database;
    await db.insert(
      tableItems,
      {'name': name},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>> fetchItems() async {
    final db = await database;
    return db.query(tableItems);
  }

  Future<void> updateItem(int id, String name) async {
    final db = await database;
    await db.update(
      tableItems,
      {'name': name},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteItem(int id) async {
    final db = await database;
    await db.delete(
      tableItems,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
