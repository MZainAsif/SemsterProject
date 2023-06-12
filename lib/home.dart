import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:semesterproject/Tasks.dart';
import 'package:semesterproject/profile.dart';
import 'package:semesterproject/sidebar.dart';
import 'package:semesterproject/homePage.dart';
import 'package:semesterproject/CalanderPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  int _selectedPage = 0;
  PageController pageController = PageController();

  void onTap(int index) {
    setState(() {
      _selectedPage = index;
    });
    pageController.animateToPage(index,
        duration: const Duration(milliseconds: 100), curve: Curves.bounceIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'TO DO',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: CircleAvatar(
              backgroundColor: Colors.blue,
              child: ClipOval(
                child: IconButton(
                  icon: const Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  color: const Color(0xFFffdd91),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProfileScreen(),
                      ),
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
      body: PageView(
        controller: pageController,
        children: [
          HomePage(),
          CalendarPage(),
          // BookmarksPage(
          //   bookmarkedTasks: [],
          // ),
          TasksPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.date_range), label: 'Calander'),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.bookmark), label: 'BookMarks'),
          BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks')
        ],
        currentIndex: _selectedPage,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        onTap: onTap,
      ),
    );
  }
}
