import 'package:newnote/model/model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Db {
  Db._();

  static final db = Db._();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  _initDatabase() async {
    final path = join(await getDatabasesPath(), 'newnote.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) {
      db.execute(
        'CREATE TABLE note (id INTEGER PRIMARY KEY, content TEXT, category TEXT, date INTEGER, del INTEGER)',
      );
    });
  }
  //CRUD OPERATIONS

  createData(Note note) async {
    var db = await database;
    db.insert('note', note.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  retrieveData() async {
    var db = await database;
    var res = await db.query('note');
    // var ress = await db.rawQuery(sql)
    if (res.isNotEmpty) {
      return res;
    } else {
      return null;
    }
  }

  updateData(Note note, int id) async {
    var db = await database;
    await db.update('note', note.toMap(), where: 'id = ?', whereArgs: [id], conflictAlgorithm: ConflictAlgorithm.replace);
  }

  deleteData(int id) async {
    var db = await database;
    await db.delete('note', where: 'id = ?', whereArgs: [id]);
  }
}
