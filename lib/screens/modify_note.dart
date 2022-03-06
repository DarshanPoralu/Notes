import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/models/note.dart';
import 'package:news_app/models/note_insert.dart';
import 'package:news_app/services/notes_service.dart';

class ModifyNote extends StatefulWidget {
  const ModifyNote({Key? key, required this.noteId}) : super(key: key);
  final String noteId;

  @override
  State<ModifyNote> createState() => _ModifyNoteState();
}

class _ModifyNoteState extends State<ModifyNote> {
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  bool isCreate() => widget.noteId == "";
  NotesService get service => GetIt.I<NotesService>();
  String? errorMessage;
  Note? note;
  bool isLoading = true, isLoad = false;

  @override
  void initState() {
    if (!isCreate()) {
      _getNote();
    } else {
      setState(() {
        isLoading = false;
      });
    }
    super.initState();
  }

  _getNote() async {
    await service.getNote(widget.noteId).then((response) {
      if (response.error != null) {
        errorMessage = response.errorMessage ?? "An error occurred";
      }
      note = response.data;
      title.text = note!.noteTitle;
      content.text = note!.noteContent;
    });
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isCreate() ? "Create a note" : "Update a note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  TextField(
                    controller: title,
                    decoration:
                        const InputDecoration(hintText: "Enter note title..."),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: content,
                    decoration: const InputDecoration(
                        hintText: "Enter note content..."),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: isLoad
                        ? const Center(child: CircularProgressIndicator())
                        : TextButton(
                            onPressed: () async {
                              setState(() {
                                isLoad = true;
                              });
                              if (isCreate()) {
                                NoteInsert note = NoteInsert(
                                    noteTitle: title.text,
                                    noteContent: content.text);
                                final response = await service.postNote(note);
                                if (response.error == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content:
                                              const Text('An error occurred')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: const Text('Note created')));
                                  Navigator.pop(context);
                                }
                              } else {
                                NoteInsert note = NoteInsert(
                                    noteTitle: title.text,
                                    noteContent: content.text);
                                final response =
                                    await service.putNote(widget.noteId, note);
                                if (response.error == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content:
                                              const Text('An error occurred')));
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          behavior: SnackBarBehavior.floating,
                                          backgroundColor:
                                              Theme.of(context).primaryColor,
                                          content: const Text('Note updated')));
                                  Navigator.pop(context);
                                }
                              }
                              setState(() {
                                isLoad = false;
                              });
                            },
                            child: Text(
                              isCreate() ? "Add" : "Update",
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor),
                            )),
                  )
                ],
              ),
      ),
    );
  }
}
