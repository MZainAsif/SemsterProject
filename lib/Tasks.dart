// ignore_for_file: file_names, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesterproject/bookMarks.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({Key? key}) : super(key: key);

  @override
  State<TasksPage> createState() => _MyTasksPageState();
}

class _MyTasksPageState extends State<TasksPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  List<Task> _tasks = [];

  @override
  void initState() {
    super.initState();
    _getUserData();
    _fetchTasks();
  }

  Future<void> _getUserData() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      setState(() {
        _user = currentUser;
      });
    }
  }

  Future<void> _fetchTasks() async {
    if (_user != null) {
      // Fetch tasks for the current user from Firestore
      QuerySnapshot taskSnapshot = await _firestore
          .collection('users')
          .doc(_user!.uid)
          .collection('tasks')
          .get();

      List<Task> tasks = [];
      taskSnapshot.docs.forEach((doc) {
        tasks.add(Task.fromDocumentSnapshot(doc));
      });

      setState(() {
        _tasks = tasks;
      });
    }
  }

  Future<void> _addTask() async {
    if (_user != null) {
      String taskTitle = '';
      String taskDescription = '';

      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Add Task'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    taskTitle = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Task Title',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    taskDescription = value;
                  },
                  decoration: const InputDecoration(
                    hintText: 'Task Description',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    // Create a new task document in Firestore for the current user
                    DocumentReference taskRef = await _firestore
                        .collection('users')
                        .doc(_user!.uid)
                        .collection('tasks')
                        .add({
                      'title': taskTitle,
                      'description': taskDescription,
                      'bookmarked': false, // Initialize bookmarked as false
                    });

                    // Fetch the newly created task document and add it to the list
                    DocumentSnapshot taskSnapshot = await taskRef.get();
                    Task newTask = Task.fromDocumentSnapshot(taskSnapshot);

                    setState(() {
                      _tasks.add(newTask);
                    });
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _toggleBookmark(Task task) async {
    bool newBookmarkStatus = !task.bookmarked;

    await _firestore
        .collection('users')
        .doc(_user!.uid)
        .collection('tasks')
        .doc(task.id)
        .update({'bookmarked': newBookmarkStatus});

    setState(() {
      task.bookmarked = newBookmarkStatus;
    });
  }

  void _navigateToBookmarks() {
    List<Task> bookmarkedTasks =
        _tasks.where((task) => task.bookmarked).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookmarksPage(bookmarkedTasks: bookmarkedTasks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.bookmark,
              color: Colors.black,
            ),
            onPressed: _navigateToBookmarks,
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        decoration: const BoxDecoration(),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "These are the tasks you have created today",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  radius: 40,
                                  child: ClipOval(
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.add,
                                        size: 30,
                                      ),
                                      color: Colors.white,
                                      onPressed: _addTask,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          return taskWidget(_tasks[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget taskWidget(Task task) {
    Color color = task.bookmarked ? Colors.red : const Color(0xFF60c5cd);
    return Slidable(
      child: Container(
        height: 80,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, 9),
              blurRadius: 20,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: const Color(0xFFffdd91),
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 4),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  task.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  task.description,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(),
            ),
            IconButton(
              icon: Icon(
                task.bookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: Colors.white,
              ),
              onPressed: () => _toggleBookmark(task),
            ),
          ],
        ),
      ),
    );
  }
}
