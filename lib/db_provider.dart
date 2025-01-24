import 'package:flutter/cupertino.dart';
import 'package:notes_app/db_helper.dart';
import 'note_model.dart';

class DBProvider extends ChangeNotifier
{
  List<NoteModel> _mNotes = [];

  DBHelper dbHelper;
  DBProvider({required this.dbHelper});

  List<NoteModel>getAllNotes() => _mNotes;

  Future<void>addNote({required NoteModel mNote})
  async{
    bool check = await dbHelper.addNote(newNote: mNote);
    if(check)
      {
        _mNotes = await dbHelper.fetchAllNotes();
        notifyListeners();
      }
  }

  Future<void> fetchInitialNotes()
  async{
    _mNotes = await dbHelper.fetchAllNotes();
    notifyListeners();
  }

  Future<void> updateNote({required NoteModel mNote})
  async{
    bool check = await dbHelper.updateNote(updateNote: mNote);
    if(check)
      {
        _mNotes = await dbHelper.fetchAllNotes();
        notifyListeners();
      }
  }

  Future<void> deleteNote({required int noteId})
  async{
    bool check = await dbHelper.deleteNote(id: noteId);
    if(check)
      {
        _mNotes = await dbHelper.fetchAllNotes();
        notifyListeners();
      }
  }

}