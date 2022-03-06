import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/models/api_response.dart';
import 'package:news_app/models/notes.dart';
import 'package:news_app/services/notes_service.dart';
import 'modify_note.dart';
import 'delete_note.dart';

class NotesList extends StatefulWidget {
  const NotesList({Key? key}) : super(key: key);

  @override
  _NotesListState createState() => _NotesListState();
}

class _NotesListState extends State<NotesList> {
  NotesService get service => GetIt.I<NotesService>();
  late ApiResponse<List<Notes>> _apiResponse;
  bool isLoading = true;

  String formatDateTime(DateTime dateTime) {
    return "${dateTime.day}/${dateTime.month}/${dateTime.year}";
  }

  @override
  void initState() {
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    _apiResponse = await service.getNotes();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "List of Notes",
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(
                builder: (context) => const ModifyNote(noteId: ''),
              ))
              .then((value) => _fetchNotes());
        },
        child: const Icon(Icons.add),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (_apiResponse.error != null && _apiResponse.error == true) {
            return Center(
              child: Text(_apiResponse.errorMessage == null
                  ? 'No error'
                  : 'An error occurred'),
            );
          }
          return ListView.separated(
            itemCount: _apiResponse.data!.length,
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(
              height: 1,
              color: Colors.black45,
            ),
            itemBuilder: (BuildContext context, int index) => Dismissible(
              background: Container(
                color: Colors.red,
                padding: const EdgeInsets.only(left: 10),
                child: const Align(
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                  alignment: Alignment.centerLeft,
                ),
              ),
              key: ValueKey(_apiResponse.data![index].noteID),
              direction: DismissDirection.startToEnd,
              onDismissed: (direction) {},
              confirmDismiss: (direction) async{
                final result = await showDialog(
                    context: context, builder: (context) => const DeleteNote());
                if(result){
                  setState(() {
                    isLoading = true;
                  });
                  await service.deleteNote(_apiResponse.data![index].noteID);
                  await _fetchNotes();
                }
              },
              child: ListTile(
                title: Text(
                  _apiResponse.data![index].title,
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
                subtitle: Text(
                    "Last edited on ${formatDateTime(_apiResponse.data![index].latestEditDateTime)}"),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(
                          builder: (context) => ModifyNote(
                                noteId: _apiResponse.data![index].noteID,
                              )))
                      .then((value) => _fetchNotes());
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
