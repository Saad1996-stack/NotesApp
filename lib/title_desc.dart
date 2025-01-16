import 'package:flutter/material.dart';
import 'package:notes_app/db_helper.dart';
import 'package:notes_app/note_model.dart';
import 'notes_grid_ui.dart';

class titleDesc extends StatefulWidget
{
  final int noteId;
  titleDesc({required this.noteId});

  @override
  State<titleDesc> createState() => _titleDescState();
}

class _titleDescState extends State<titleDesc>
{
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getNotes();
  }

  getNotes() async {
    var db = await dbHelper.getDB();
    var noteData = await db.query(
      DBHelper.TABLE_NOTE,
      where: "${DBHelper.COLUMN_NOTE_ID} = ?",
      whereArgs: [widget.noteId],
    );
    if (noteData.isNotEmpty) {
      mNotes = noteData.map((note)=> NoteModel.fromMap(note)).toList();
    }
    setState(() {});
  }

  TextEditingController updateNoteTitleController = TextEditingController();
  TextEditingController updateNoteDateController  = TextEditingController();
  TextEditingController updateNoteDescController  = TextEditingController();

  List<NoteModel>mNotes = [];
  DBHelper dbHelper = DBHelper.getInstance();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0xff252525),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                          child: IconButton(onPressed: ()
                          {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>notesUi()));
                          },
                              icon: Icon(Icons.arrow_back_ios_new,color: Colors.white,))),

                      Container(
                        height: 70,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Color(0xff3B3B3B),
                              borderRadius: BorderRadius.circular(15),
                            ),
                        child: Center(child: Text("Save",style: TextStyle(fontSize: 25,color: Colors.white),)),
                          ),
                    ],
                  ),
                )
              ),
              Expanded(
                flex: 15,
                child: mNotes.isNotEmpty ? ListView.builder(
                  itemCount: mNotes.length,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Text(mNotes[index].title,
                          style: TextStyle(fontSize: 28,fontWeight: FontWeight.w900,color: Colors.white,)),
                        subtitle: Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mNotes[index].date,style: TextStyle(fontSize: 20,color: Colors.white),),
                              SizedBox(
                                height: 15,
                              ),
                              Text(mNotes[index].desc,style: TextStyle(fontSize: 20,color: Colors.white),),
                            ],
                          ),
                        ),
                      );
                    },
                    )
                    : Center(child: Text("No Notes Available",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 20,color: Colors.white),))
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){

            if(mNotes.isNotEmpty)
              {
                updateNoteTitleController.text = mNotes[0].title;
                updateNoteDateController.text  = mNotes[0].date;
                updateNoteDescController.text  = mNotes[0].desc;
              }

            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_){
                  return Container(
                    height: 800,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Note Update",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
                        SizedBox(
                          height: 11,
                        ),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: updateNoteTitleController,
                            minLines: 4,
                            maxLines: 5,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Text("Title"),
                              hintText: "Title",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: updateNoteDateController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Text("Date"),
                              hintText: "Month Date, Year",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        SizedBox(
                          width: 400,
                          child: TextField(
                            minLines: 6,
                            maxLines: 8,
                            controller: updateNoteDescController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              label: Text("Description"),
                              hintText: "Description",
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 10,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            OutlinedButton(
                              onPressed: ()
                              async{
                                // bool check = await dbHelper.updateNote(updateTitle: updateNoteTitleController.text, updateDate: updateNoteDateController.text, updateDesc: updateNoteDescController.text, id: mNotes[0].id);
                                bool check = await dbHelper.updateNote(updateNote: NoteModel(title: updateNoteTitleController.text, date: updateNoteDateController.text, desc: updateNoteDescController.text, id: mNotes[0].id));
                                if(check)
                                {
                                  getNotes();
                                  Navigator.pop(context);
                                }
                              },
                              child: Text("Update"),
                            ),

                            OutlinedButton(
                              onPressed: ()
                              {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                });
          },
          child: Icon(Icons.edit),
        ),
      ),
    );
  }
}
