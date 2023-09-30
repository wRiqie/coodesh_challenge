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
  static const _wordIsFavorited = 'isFavorited';

  static const _createTableWord = """
    CREATE TABLE IF NOT EXISTS $_wordTable(
      $_wordId INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      $_wordText TEXT,
      $_wordIsFavorited INTEGER
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

  Future<int> updateWord(WordModel word) async {
    final db = await database;
    var sql = StringBuffer();
    sql.write(" UPDATE word SET text = '${word.text}', ");
    sql.write(" isFavorited = ${word.isFavorited ? 1 : 0} ");
    sql.write(" WHERE $_wordId = ${word.id} ");

    return db.rawUpdate(sql.toString());
  }

  Future<PaginableModel<WordModel>> getWords(
      String query, int? limit, int? offset, bool onlyFavorited) async {
    final db = await database;

    var sql = StringBuffer();
    sql.write(" SELECT * FROM $_wordTable ");
    var operation = 'WHERE';
    if (query.trim().isNotEmpty) {
      sql.write(" $operation $_wordText LIKE '$query%' ");
      operation = 'AND';
    }
    if (onlyFavorited) sql.write(" $operation $_wordIsFavorited = 1 ");
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
}
