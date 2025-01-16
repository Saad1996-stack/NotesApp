import 'package:notes_app/db_helper.dart';

class NoteModel
{
  int id;
  String title;
  String desc;
  String date;

  NoteModel({this.id = 0, required this.title, required this.date, this.desc = ""});


  ///fromMap get data from Database

  factory NoteModel.fromMap(Map<String,dynamic>map)
  {
    return NoteModel(
      id: map[DBHelper.COLUMN_NOTE_ID],
      title: map[DBHelper.COLUMN_NOTE_TITLE],
      date: map[DBHelper.COLUMN_NOTE_DATE],
      desc: map[DBHelper.COLUMN_NOTE_DESC],
    );
  }

  ///toMap for insertion in Database

  Map<String,dynamic>toMap()
  {
    return
      {
        DBHelper.COLUMN_NOTE_TITLE : title,
        DBHelper.COLUMN_NOTE_DATE  : date,
        DBHelper.COLUMN_NOTE_DESC  : desc,
      };
  }

}