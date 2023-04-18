import 'package:sqflite/sqflite.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  Future<Database> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_crud');
    var database =
        await openDatabase(path, version: 1, onCreate: _createDatabase);
    return database;
  }

  Future<void> _createDatabase(Database database, int version) async {
    // print("_createDatabase method called"); 
    String sql =
        "CREATE TABLE employees (id INTEGER PRIMARY KEY, name TEXT, role TEXT, fromDate TEXT, toDate TEXT);";
    try {
      await database.execute(sql);
     // print("employees table created successfully");
    } catch (e) {
     // print("error creating employees table: $e");
    }
  }
}
