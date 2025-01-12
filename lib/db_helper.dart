import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();
  static DBHelper getInstance() => DBHelper._();

  Database? mDB;

  Future<Database> getDB() async {
    return mDB ?? await openDB();
  }

  Future<Database> openDB() async {
    var appDir = await getApplicationDocumentsDirectory();
    String dbPath = join(appDir.path, "mainDB.db");

    return await openDatabase(dbPath, version: 1, onCreate: (db, version) {
      db.execute(
          "create table note ( note_id integer primary key autoincrement, note_title text, note_desc text, note_date text)");
    });
  }

  Future<bool> addNote(
      {required String title, String desc = "", required String date}) async {
    var db = await getDB();
    int rowsEffected = await db.insert("note", {
      "note_title": title,
      "note_desc": desc,
      "note_date": date,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query("note");
    return mData;
  }

  Future<bool> updateNote(
      {required String updateTitle,
      required String updateDesc,
      required String updateDate,
      required int id}) async {
    var db = await getDB();
    int rowsEffected = await db.update(
        "note",
        {
          "note_title": updateTitle,
          "note_desc": updateDesc,
          "note_date": updateDate,
        },
        where: "note_id = $id");
    return rowsEffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
    int rowsEffectecd = await db.delete("note", where: "note_id = $id");
    return rowsEffectecd > 0;
  }
}
