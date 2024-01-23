import 'package:carbon_emission_app/data/database/user_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:carbon_emission_app/data/bloc/registration_bloc/user_model.dart';

class EmissionsDatabaseHelper {
  static EmissionsDatabaseHelper? _instance;
  late Database _database;

  EmissionsDatabaseHelper._privateConstructor();

  static Future<EmissionsDatabaseHelper> getInstance() async {
    if (_instance == null) {
      _instance = EmissionsDatabaseHelper._privateConstructor();
      await _instance!._initDatabase();
    }
    return _instance!;
  }

  Future<void> _initDatabase() async {
    User loggedInUser = await _getLoggedInUser();
    String tableName = 'emissions_history_${loggedInUser.id}';

    String path = join(await getDatabasesPath(), '$tableName.db');
    _database = await openDatabase(path, version: 1, onCreate: (db, version) {
      return _createTable(db, tableName);
    });
  }

  Future<void> _createTable(Database db, String tableName) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        emissions_value REAL,
        selected_date TEXT
      )
    ''');
  }

  Future<int> insertEmissionsHistory({
    required double emissionsValue,
    required String selectedDate,
  }) async {
    String tableName = await _getEmissionsTableName();
    return await _database.insert(tableName, {
      'emissions_value': emissionsValue,
      'selected_date': selectedDate,
    });
  }

  Future<List<Map<String, dynamic>>> getEmissionsHistory() async {
    String tableName = await _getEmissionsTableName();
    return await _database.query(tableName);
  }

  Future<User> _getLoggedInUser() async {
    // Assuming UserProvider is a class managing the logged-in user state
    User? loggedInUser = UserProvider.getLoggedInUser();

    // If the logged-in user is null, you may want to throw an error or return a default user
    if (loggedInUser == null) {
      throw Exception('No logged-in user found');
    }

    return loggedInUser;
  }


  Future<String> _getEmissionsTableName() async {
    User loggedInUser = await _getLoggedInUser();
    return 'emissions_history_${loggedInUser.id}';
  }
}
