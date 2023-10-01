import 'package:english_dictionary/app/data/models/favorite_model.dart';
import 'package:english_dictionary/app/data/models/history_model.dart';
import 'package:english_dictionary/app/data/models/paginable_model.dart';
import 'package:english_dictionary/app/data/models/word_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDbService {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }
    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'dictionary.db');
    return openDatabase(
      path,
      version: 1,
      onOpen: (db) async {
        await _createTables(db);
      },
      onCreate: (Database db, int version) async {
        await _createTables(db);
      },
    );
  }

  // Generics
  Future<void> _createTables(Database db) async {
    await db.execute(_createTableWord);
    await db.execute(_createTableFavorite);
    await db.execute(_createTableHistory);
  }

  Future<int> getTableCount(String table, {String? condition}) async {
    final db = await database;
    var sql = StringBuffer();
    sql.write(" SELECT COUNT(0) AS total ");
    sql.write(" FROM $table ");
    if (condition != null) sql.write(" $condition ");

    var res = await db.rawQuery(sql.toString());

    return res.isNotEmpty ? res.first['total'] as int : 0;
  }

  // Word
  static const _wordTable = 'word';
  static const _wordId = 'id';
  static const _wordText = 'text';

  static const _createTableWord = """
    CREATE TABLE IF NOT EXISTS $_wordTable(
      $_wordId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      $_wordText TEXT
    );
  """;

  Future<void> saveAllWords(List<String> datas) async {
    final db = await database;
    // Removing previous data to avoid duplication
    await db.delete(_wordTable);
    var batch = db.batch();
    for (var data in datas) {
      batch.rawInsert("INSERT INTO $_wordTable($_wordText) VALUES('$data')");
    }
    await batch.commit(noResult: true, continueOnError: true);
  }

  Future<PaginableModel<WordModel>> getWords(String query, int? limit,
      int? offset, bool onlyFavorited, String userId) async {
    final db = await database;

    var sql = StringBuffer();
    sql.write(" SELECT WRD.$_wordId, ");
    sql.write(" WRD.$_wordText, ");
    sql.write(
        " (CASE WHEN FAV.$_favoriteId IS NOT NULL THEN 1 ELSE 0 END) AS isFavorited ");
    sql.write(" FROM $_wordTable WRD ");
    sql.write(
        " ${onlyFavorited ? 'INNER JOIN' : 'LEFT JOIN'} $_favoriteTable FAV ");
    sql.write(" ON FAV.$_favoriteWordId = WRD.$_wordId ");
    sql.write(" AND FAV.$_favoriteUserId = '$userId' ");
    var operation = 'WHERE';
    if (query.trim().isNotEmpty) {
      sql.write(" $operation WRD.$_wordText LIKE '$query%' ");
      operation = 'AND';
    }
    sql.write(" LIMIT $limit ");
    sql.write(" OFFSET $offset ");

    var res = await db.rawQuery(sql.toString());

    List<WordModel> words =
        res.isNotEmpty ? res.map((e) => WordModel.fromMap(e)).toList() : [];

    return PaginableModel(
      items: words,
      totalItemsCount: await getTableCount(
        '$_wordTable WRD',
        condition: onlyFavorited
            ? '''
          INNER JOIN $_favoriteTable FAV
          ON FAV.$_favoriteWordId = WRD.$_wordId
          AND FAV.$_favoriteUserId = '$userId'
          WHERE FAV.$_favoriteUserId = '$userId'
        '''
            : null,
      ),
    );
  }

  // Favorite
  static const _favoriteTable = 'favorite';
  static const _favoriteId = 'id';
  static const _favoriteUserId = 'userId';
  static const _favoriteWordId = 'wordId';

  static const _createTableFavorite = """
    CREATE TABLE IF NOT EXISTS $_favoriteTable(
      $_favoriteId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      $_favoriteUserId TEXT,
      $_favoriteWordId INTEGER
    );
  """;

  Future<void> saveFavorite(FavoriteModel favorite) async {
    final db = await database;

    var sql = StringBuffer();
    sql.write(
        " INSERT INTO $_favoriteTable($_favoriteUserId, $_favoriteWordId) ");
    sql.write(" VALUES ('${favorite.userId}', ${favorite.wordId}) ");

    await db.rawInsert(sql.toString());
  }

  Future<void> deleteFavorite(int wordId, String userId) async {
    final db = await database;
    await db.delete(_favoriteTable,
        where: '$_favoriteWordId = ? AND $_favoriteUserId = ?',
        whereArgs: [wordId, userId]);
  }

  // History
  static const _historyTable = 'history';
  static const _historyId = 'id';
  static const _historyWordId = 'wordId';
  static const _historyUserId = 'userId';
  static const _historyDisplayDate = 'displayDate';

  static const _createTableHistory = """
    CREATE TABLE IF NOT EXISTS $_historyTable(
      $_historyId TEXT NOT NULL PRIMARY KEY,
      $_historyWordId INTEGER,
      $_historyUserId TEXT,
      $_historyDisplayDate TEXT
    );
  """;

  Future<void> saveHistory(HistoryModel history) async {
    final db = await database;

    await db.insert(
      _historyTable,
      history.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<PaginableModel<WordModel>> getHistoryWords(
      String query, int? limit, int? offset, String userId) async {
    final db = await database;

    var sql = StringBuffer();
    sql.write(" SELECT WRD.$_wordId, ");
    sql.write(" WRD.$_wordText ");
    sql.write(" FROM $_wordTable WRD ");
    sql.write(" INNER JOIN $_historyTable HIS ");
    sql.write(" ON HIS.$_historyWordId = WRD.$_wordId ");
    sql.write(" AND FAV.$_historyUserId = '$userId' ");
    var operation = 'WHERE';
    if (query.trim().isNotEmpty) {
      sql.write(" $operation WRD.$_wordText LIKE '$query%' ");
      operation = 'AND';
    }
    sql.write(" LIMIT $limit ");
    sql.write(" OFFSET $offset ");

    var res = await db.rawQuery(sql.toString());

    List<WordModel> words =
        res.isNotEmpty ? res.map((e) => WordModel.fromMap(e)).toList() : [];

    return PaginableModel(
      items: words,
      totalItemsCount: await getTableCount(_wordTable),
    );
  }

  Future<void> deleteHistoryWord(int wordId, String userId) async {
    final db = await database;

    await db.delete(
      _historyTable,
      where: '$_historyWordId = ? AND $_historyUserId = ?',
      whereArgs: [wordId, userId],
    );
  }

  Future<void> deleteUserHistory(String userId) async {
    final db = await database;

    await db.delete(
      _historyTable,
      where: '$_historyUserId = ?',
      whereArgs: [userId],
    );
  }
}
