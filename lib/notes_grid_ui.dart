import 'dart:math';

import 'package:flutter/material.dart';
import 'package:notes_app/db_helper.dart';
import 'package:notes_app/db_provider.dart';
import 'package:notes_app/note_model.dart';
import 'package:notes_app/title_desc.dart';
import 'package:provider/provider.dart';

class notesUi extends StatefulWidget
{
  @override
  State<notesUi> createState() => _notesUiState();
}

class _notesUiState extends State<notesUi>
{
  TextEditingController noteTitleController = TextEditingController();
  TextEditingController noteDateController  = TextEditingController();

  List<NoteModel>mNotes = [];
  DBHelper dbHelper = DBHelper.getInstance();


  @override
  void initState() {
    super.initState();
    //getNotes(); Database
    context.read<DBProvider>().fetchInitialNotes();
  }

  ///Database
  /*getNotes()
  async{
    mNotes = await dbHelper.fetchAllNotes();
    setState(() {
    });
  }*/

  @override
  Widget build(BuildContext context)
  {
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color(0xff252525),
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Notes",style: TextStyle(fontSize: 50,color: Colors.white),),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Color(0xff3B3B3B),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: IconButton(icon: Icon(Icons.search,color: Colors.white,size: 45,),
                            onPressed: ()
                            {},
                          ),
                        )
                      ],
                    ),
                  )
              ),
              Expanded(
                flex: 18,
                child:
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<DBProvider>(builder: (ctx, provider, child){
                    mNotes = provider.getAllNotes();
                    return mNotes.isNotEmpty
                        ? GridView.builder(
                        itemCount: provider.getAllNotes().length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          childAspectRatio: 3/4,
                        ),
                        itemBuilder: (context,index){
                          return InkWell(
                            onTap: ()
                            {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>titleDesc(note: mNotes[index].id)),);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(mNotes[index].title,style: TextStyle(fontSize: 20),overflow: TextOverflow.ellipsis,),
                                    Text(mNotes[index].date,style: TextStyle(fontSize: 20,color: Colors.black45),),
                                    Padding(
                                      padding: EdgeInsets.only(top: 60,left: 150),
                                      child: IconButton(onPressed: ()
                                      async{
                                        ///provider
                                        context.read<DBProvider>().deleteNote(noteId: mNotes[index].id);
                                        ///data base
                                        /*bool check = await dbHelper.deleteNote(id: mNotes[index].id);
                                      if(check)
                                        {

                                          getNotes();
                                        }*/
                                      }
                                          ,icon: Icon(Icons.delete,size: 25,)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        })
                        : Center(child: Text("No yet Notes",style: TextStyle(fontWeight: FontWeight.w900,fontSize: 30,color: Colors.white),));
                  }),
                ),
              ),
            ],
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: (){
            noteTitleController.clear();
            noteDateController.text = "";
            showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (_){
                  return Container(
                    height: 400,
                    width: double.infinity,
                    child: Column(
                      children: [
                        Text("Note Title",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w900),),
                        SizedBox(
                          height: 11,
                        ),
                        SizedBox(
                          width: 400,
                          child: TextField(
                            controller: noteTitleController,
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
                            controller: noteDateController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              hintText: "Date",
                              label: Text("Date"),
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
                                ///2nd Way for use Provider
                                context.read<DBProvider>().addNote(mNote: NoteModel(title: noteTitleController.text, date: noteDateController.text));
                                Navigator.pop(context);
                                ///1st Way for use Provider
                                //Provider.of<DBProvider>(context).addNote(mNote: NoteModel(title: noteTitleController.text, date: noteDateController.text));
                                ///Database
                                /*async{
                                bool check = await dbHelper.addNote(newNote: NoteModel(title: noteTitleController.text, date: noteDateController.text));
                                if(check)
                                  {
                                    getNotes();
                                    Navigator.pop(context);
                                  }*/
                              },
                              child: Text("Add"),
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
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}