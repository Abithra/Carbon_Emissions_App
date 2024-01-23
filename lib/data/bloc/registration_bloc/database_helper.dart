import 'dart:io';
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'users';
  static const tableGeneralEmissions = 'general_emissions';
  static const columnId = 'id';
  static const columnName = 'name';
  static const columnEmail = 'email';
  static const columnAge = 'age';
  static const columnPassword = 'password';
  static const columnCountry = 'country';
  static const columnRegulation = 'regulation';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY,
        $columnName TEXT NOT NULL,
        $columnEmail TEXT NOT NULL,
        $columnAge TEXT NOT NULL,
        $columnPassword TEXT NOT NULL,
        $columnCountry TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE $tableGeneralEmissions (
        $columnCountry TEXT PRIMARY KEY,
        $columnRegulation TEXT NOT NULL
      )
    ''');

    await db.insert(
      tableGeneralEmissions,
      {columnCountry: 'USA', columnRegulation: 'Sample regulations for USA'},
    );
    await db.insert(
      tableGeneralEmissions,
      {columnCountry: 'Canada', columnRegulation: 'Sample regulations for Canada'},
    );
  }

  Future<void> insertUser(User user) async {
    Database db = await instance.database;
    await db.insert(
      table,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<User>> getUsersByEmail(String email) async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnEmail = ?',
      whereArgs: [email],
    );
    return List.generate(
      maps.length,
          (index) {
        return User(
          id: maps[index][columnId],
          name: maps[index][columnName],
          email: maps[index][columnEmail],
          age: maps[index][columnAge],
          password: maps[index][columnPassword],
          country: maps[index][columnCountry],
        );
      },
    );
  }

  Future<List<User>> getUsers() async {
    Database db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(
      maps.length,
          (index) {
        return User(
          id: maps[index][columnId],
          name: maps[index][columnName],
          email: maps[index][columnEmail],
          age: maps[index][columnAge],
          password: maps[index][columnPassword],
          country: maps[index][columnCountry],
        );
      },
    );
  }

  Future<String> getGeneralEmissionsByCountry(String country) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result = await db.query(
      tableGeneralEmissions,
      columns: [columnRegulation],
      where: '$columnCountry = ?',
      whereArgs: [country],
    );

    if (result.isNotEmpty) {
      return result.first[columnRegulation].toString();
    } else {
      return "General emissions regulations not available for $country";
    }
  }
}