import 'package:notes_app/note_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper
{
  ///Table Name
  static const String TABLE_NOTE = "note";

  ///
  static const String COLUMN_NOTE_ID = "note_id";
  static const String COLUMN_NOTE_TITLE = "note_title";
  static const String COLUMN_NOTE_DATE = "note_date";
  static const String COLUMN_NOTE_DESC = "note_desc";

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
          "create table note ( $COLUMN_NOTE_ID integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text, $COLUMN_NOTE_DATE text)");
    });
  }

  Future<bool>addNote({required NoteModel newNote})
  async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE, newNote.toMap());
    return rowsEffected > 0;
  }

  Future<List<NoteModel>>fetchAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NOTE);
    List<NoteModel> mNotes = [];

    for(int i=0; i<mData.length; i++)
      {
        NoteModel eachNote = NoteModel.fromMap(mData[i]);
        mNotes.add(eachNote);
      }
    return mNotes;
  }

  Future<bool> updateNote(
      {required NoteModel updateNote}) async {
    var db = await getDB();
    int rowsEffected = await db.update(
        TABLE_NOTE,updateNote.toMap(),
        where: "$COLUMN_NOTE_ID = ${updateNote.id}",);
    return rowsEffected > 0;
  }

  Future<bool> deleteNote({required int id}) async {
    var db = await getDB();
    int rowsEffectecd = await db.delete(TABLE_NOTE, where: "$COLUMN_NOTE_ID = $id");
    return rowsEffectecd > 0;
  }
}
