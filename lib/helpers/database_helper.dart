import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/models.dart';

String query = "";

class DBHelper {
  DBHelper._();
  static final DBHelper dbHelper = DBHelper._();
  String dbName = "quotes.db";
  String categoryTable = "${query.toLowerCase().replaceAll(' ', '_')}table";
  String colId = "id";
  String colQuote = "quote";
  String colAuthor = "author";
  String colFavorite = "favorite";
  String colMarkedAsRead = "marked_as_read";
  String colBGImage = "background_image";

  Database? db;

  Future<Database?> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      categoryTable = "${query.toLowerCase().replaceAll(' ', '_')}table";
      String sqlQuery =
          "CREATE TABLE IF NOT EXISTS $categoryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colQuote TEXT, $colAuthor TEXT, $colFavorite TEXT, $colMarkedAsRead TEXT,$colBGImage TEXT);";
      await db.execute(sqlQuery);
    });
    categoryTable = "${query.toLowerCase().replaceAll(' ', '_')}table";
    String sqlQuery =
        "CREATE TABLE IF NOT EXISTS $categoryTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colQuote TEXT, $colAuthor TEXT, $colFavorite TEXT, $colMarkedAsRead TEXT,$colBGImage TEXT);";
    await db!.execute(sqlQuery);
    return db;
  }

  insertDataIntoTable(Quote data) async {
    db = await initDB();
    categoryTable = "${query.toLowerCase().replaceAll(' ', '_')}table";
    String sqlQuery =
        "INSERT INTO $categoryTable($colQuote,$colAuthor, $colFavorite,$colMarkedAsRead,$colBGImage) VALUES(?,?,?,?,?);";
    List args = [
      data.quote,
      data.author,
      data.favorite,
      data.markedAsRead,
      data.backgroundImage,
    ];
    await db!.rawInsert(sqlQuery, args);
  }

  Future<List<Quote>?> fetchData() async {
    db = await initDB();
    categoryTable = "${query.toLowerCase().replaceAll(' ', '_')}table";
    String sqlQuery = "SELECT * FROM $categoryTable";
    List<Map<String, dynamic>> dbData = await db!.rawQuery(sqlQuery);
    List<Quote>? finalData = dbData.map((e) => Quote.fromMap(e)).toList();
    return finalData;
  }

  Future<int> markAsRead({required int? id, required String markAsRead}) async {
    categoryTable = "${query.toLowerCase().replaceAll(' ', '_')}table";

    String sqlQuery =
        "UPDATE $categoryTable SET $colMarkedAsRead = ?  WHERE $colId = ?";
    List args = [markAsRead, id];

    return await db!.rawUpdate(sqlQuery, args);
  }
}
