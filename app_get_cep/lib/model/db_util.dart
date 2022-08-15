import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE places(id TEXT PRIMARY KEY, titlecep TEXT, address TEXT, number TEXT, complement TEXT, district TEXT, city TEXT, state TEXT)');
      },
      version: 1,
    );
  }

  static Future<sql.Database> databaseTypeScreen() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(
      path.join(dbPath, 'typescreen.db'),
      onCreate: (db, version) {
        return db.execute(
            'CREATE TABLE type(typeselected TEXT)');
      },
      version: 1,
    );
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<void> insertTypes(String table, Map<String, Object> data) async {
    final db = await DbUtil.databaseTypeScreen();
    await db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }


  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }

  static Future<List<Map<String, dynamic>>> getDataTypeScreen(String table) async {
    final db = await DbUtil.databaseTypeScreen();
    return db.query(table);
  }

  Future<int> deletePlace(int id) async {
    final db = await DbUtil.database();

    return await db.delete('places', where: "id=?", whereArgs: [id]);
  }
}
