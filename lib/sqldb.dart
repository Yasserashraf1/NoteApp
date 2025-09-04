import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlDb {
  static Database? _db;

  Future<Database?> get dataBase async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, "yasser.db");
    Database myDb = await openDatabase(
      path,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
      version: 2,
    );
    return myDb;
  }

  _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print("onUpgrade from $oldVersion to $newVersion");
    if (oldVersion < 2) {
      await db.execute("ALTER TABLE notes ADD COLUMN title TEXT");
      await db.execute("ALTER TABLE notes ADD COLUMN color TEXT");
    }
  }

  _onCreate(Database db, int version) async {
    await db.execute("""
     CREATE TABLE 'notes'(
     'id' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
     'note' TEXT NOT NULL,
     'title' TEXT,
     'color' TEXT
     )
    """);
    print("onCreate");
  }

  readData(String sql) async {
    Database? myDb = await dataBase;
    List<Map> response = await myDb!.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database? myDb = await dataBase;
    int response = await myDb!.rawInsert(sql);
    return response;
  }

  insertNote({required String note, String? title, String? color}) async {
    Database? myDb = await dataBase;
    int response = await myDb!.insert('notes', {
      'note': note,
      'title': title ?? '',
      'color': color ?? 'blue',
    });
    return response;
  }

  updateData(String sql) async {
    Database? myDb = await dataBase;
    int response = await myDb!.rawUpdate(sql);
    return response;
  }

  // NEW: Safe update method
  updateNote({required int id, required String note, String? title, String? color}) async {
    Database? myDb = await dataBase;
    int response = await myDb!.update(
      'notes',
      {
        'note': note,
        'title': title ?? '',
        'color': color ?? 'blue',
      },
      where: 'id = ?',
      whereArgs: [id],
    );
    return response;
  }

  deleteData(String sql) async {
    Database? myDb = await dataBase;
    int response = await myDb!.rawDelete(sql);
    return response;
  }
}

