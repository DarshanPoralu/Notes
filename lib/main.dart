import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:news_app/screens/home.dart';
import 'package:news_app/services/notes_service.dart';

void setupLocator(){
  GetIt.I.registerLazySingleton(() => NotesService());
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesList(),
    );
  }
}

