import 'package:flutter/material.dart';
import 'package:sqlite/edit.dart';
import 'MyHomePage.dart';
import 'addNote.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: {
        '/home': (context) => const MyHomePage(),
        '/note': (context) => const AddNotePage(),
        '/editNote': (context)=> const EditNotePage(),
      },
    );
  }
}