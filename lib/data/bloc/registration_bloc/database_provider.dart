// database_provider.dart
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseProvider {
  static const String tableName = 'users';

  static Future<Database> open() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'app_database.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id INTEGER PRIMARY KEY, name TEXT, email TEXT, age TEXT, password TEXT, country TEXT)',
        );
      },
      version: 1,
    );

    return database;
  }

  static Future<void> insertUser(User user) async {
    final Database db = await open();
    await db.insert(
      tableName,
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  // database_provider.dart
  static Future<List<User>> getUsersByEmail(String email) async {
    final Database db = await open();
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'email = ?',
      whereArgs: [email],
    );
    return List.generate(
      maps.length,
          (index) {
        return User(
          id: maps[index]['id'],
          name: maps[index]['name'],
          email: maps[index]['email'],
          age: maps[index]['age'],
          password: maps[index]['password'],
          country: maps[index]['country'],
        );
      },
    );
  }


  static Future<List<User>> getUsers() async {
    final Database db = await open();
    final List<Map<String, dynamic>> maps = await db.query(tableName);
    return List.generate(
      maps.length,
          (index) {
        return User(
          id: maps[index]['id'],
          name: maps[index]['name'],
          email: maps[index]['email'],
          age: maps[index]['age'],
          password: maps[index]['password'],
          country: maps[index]['country'],
        );
      },
    );
  }
}
