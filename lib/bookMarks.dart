// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:semesterproject/home.dart';

class BookmarksPage extends StatelessWidget {
  final List<Task> bookmarkedTasks;

  const BookmarksPage({Key? key, required this.bookmarkedTasks})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('BookMarks'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MyHomePage(),
              ),
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: bookmarkedTasks.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              bookmarkedTasks[index].title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              bookmarkedTasks[index].description,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Task {
  final String id;
  final String title;
  final String description;
  bool bookmarked;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.bookmarked = false,
  });

  // Factory method to create a Task from a DocumentSnapshot
  factory Task.fromDocumentSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Task(
      id: snapshot.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      bookmarked: data['bookmarked'] ?? false,
    );
  }
}
