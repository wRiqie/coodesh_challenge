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

  Future<void> _createTables(Database db) async {
    await db.execute(_createTableWord);
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

  Future<int> saveWord(WordModel word) async {
    final db = await database;
    return db.insert(_wordTable, word.toMap());
  }

  Future<List<WordModel>> getWords(int? limit, int offset) async {
    final db = await database;
    var res = await db.query(_wordTable, limit: limit, offset: offset);
    return res.isNotEmpty ? res.map((e) => WordModel.fromMap(e)).toList() : [];
  }
}
