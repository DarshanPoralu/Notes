import 'dart:convert';
import 'package:news_app/models/note.dart';
import 'package:news_app/models/api_response.dart';
import 'package:news_app/models/note_insert.dart';
import 'package:news_app/models/notes.dart';
import 'package:http/http.dart' as http;

class NotesService{

  static const api = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const headers = {
    'apiKey': "d92fe631-6be1-4a75-9df3-36439ee0f6d8",
    'Content-Type': 'application/json',
  };

  Future<ApiResponse<List<Notes>>> getNotes() {
    return http.get(Uri.parse('$api/notes'), headers: headers).then((data){
      if(data.statusCode == 200){
        final jsonData = jsonDecode(data.body);
        final notes = <Notes>[];
        for (var item in jsonData){
          notes.add(Notes(noteID: item['noteID'], title: item['noteTitle'], createDateTime: DateTime.parse(item['createDateTime']), latestEditDateTime: DateTime.parse(item['latestEditDateTime'] ?? item['createDateTime'])));
        }
        return ApiResponse(data: notes);
      }
      return ApiResponse(error: true, errorMessage: 'An error occurred');
    });
  }

  Future<ApiResponse<Note>> getNote(String noteId) {
    return http.get(Uri.parse('$api/notes/$noteId'), headers: headers).then((data){
      if(data.statusCode == 200){
        final jsonData = jsonDecode(data.body);
        final note = Note(noteID: jsonData['noteID'], noteTitle: jsonData['noteTitle'], noteContent: jsonData['noteContent'],  createDateTime: DateTime.parse(jsonData['createDateTime']), latestEditDateTime: DateTime.parse(jsonData['latestEditDateTime'] ?? jsonData['createDateTime']));
        return ApiResponse(data: note);
      }
      return ApiResponse(error: true, errorMessage: 'An error occurred');
    });
  }

  Future<ApiResponse<Note>> postNote(NoteInsert note) {
    return http.post(Uri.parse('$api/notes'), headers: headers, body: jsonEncode({'noteTitle': note.noteTitle, 'noteContent': note.noteContent})).then((data){
      if(data.statusCode >= 200 && data.statusCode <= 299){
        return ApiResponse(error: false);
      }
      return ApiResponse(error: true);
    });
  }

  Future<ApiResponse<Note>> putNote(String noteId, NoteInsert note) {
    return http.put(Uri.parse('$api/notes/$noteId'), headers: headers, body: jsonEncode({'noteTitle': note.noteTitle, 'noteContent': note.noteContent})).then((data){
      if(data.statusCode >= 200 && data.statusCode <= 299){
        return ApiResponse(error: false);
      }
      return ApiResponse(error: true);
    });
  }

  Future<ApiResponse<Note>> deleteNote(String noteId,) {
    return http.delete(Uri.parse('$api/notes/$noteId'), headers: headers).then((data){
      if(data.statusCode >= 200 && data.statusCode <= 299){
        return ApiResponse(error: false);
      }
      return ApiResponse(error: true);
    });
  }
}