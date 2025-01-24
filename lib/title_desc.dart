import 'package:flutter/material.dart';
import 'package:notes_app/note_model.dart';
import 'package:provider/provider.dart';
import 'db_provider.dart';

class titleDesc extends StatefulWidget {
  final int note; // Selected Note ID
  titleDesc({required this.note});

  @override
  State<titleDesc> createState() => _titleDescState();
}

class _titleDescState extends State<titleDesc> {
  TextEditingController updateNoteTitleController = TextEditingController();
  TextEditingController updateNoteDateController = TextEditingController();
  TextEditingController updateNoteDescController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xff252525),
          child: Column(
            children: [
              // App Bar
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Back Button
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                        ),
                      ),
                      // Save Button
                      Container(
                        height: 70,
                        width: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xff3B3B3B),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: const Center(
                          child: Text("Save", style: TextStyle(fontSize: 25, color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Note Details
              Expanded(
                flex: 15,
                child: Consumer<DBProvider>(
                  builder: (ctx, provider, child) {
                    // Filter selected note
                    final selectedNote = provider.getAllNotes().firstWhere(
                          (note) => note.id == widget.note,
                      orElse: () => NoteModel(id: 0, title: "N/A", date: "N/A", desc: "No Data"),
                    );

                    return ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        // Title
                        Text(
                          selectedNote.title,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Date
                        Text(
                          selectedNote.date,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        const SizedBox(height: 15),
                        // Description
                        Text(
                          selectedNote.desc,
                          style: const TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            final provider = context.read<DBProvider>();
            final selectedNote = provider.getAllNotes().firstWhere(
                  (note) => note.id == widget.note,
              orElse: () => NoteModel(id: 0, title: "", date: "", desc: ""),
            );

            // Pre-fill update controllers
            updateNoteTitleController.text = selectedNote.title;
            updateNoteDateController.text = selectedNote.date;
            updateNoteDescController.text = selectedNote.desc;

            showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return Container(
                  height: 800,
                  width: double.infinity,
                  child: Column(
                    children: [
                      const Text("Note Update", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 11),
                      // Title Field
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: updateNoteTitleController,
                          decoration: InputDecoration(
                            label: const Text("Title"),
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
                      const SizedBox(height: 10),
                      // Date Field
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: updateNoteDateController,
                          decoration: InputDecoration(
                            label: const Text("Date"),
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
                      const SizedBox(height: 10),
                      // Description Field
                      SizedBox(
                        width: 400,
                        child: TextField(
                          controller: updateNoteDescController,
                          maxLines: 5,
                          decoration: InputDecoration(
                            label: const Text("Description"),
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
                      const SizedBox(height: 10),
                      // Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            onPressed: () async {
                              final updatedNote = NoteModel(
                                id: selectedNote.id,
                                title: updateNoteTitleController.text,
                                date: updateNoteDateController.text,
                                desc: updateNoteDescController.text,
                              );
                               await provider.updateNote(mNote: updatedNote);
                              Navigator.pop(context);
                            },
                            child: const Text("Update"),
                          ),
                          OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancel"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          child: const Icon(Icons.edit),
        ),
      ),
    );
  }
}