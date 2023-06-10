// ignore_for_file: unused_field, library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:semesterproject/Tasks.dart';
import 'package:semesterproject/splash.dart';

class SideBar extends StatefulWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? _user;
  String? _userName;
  String? _userEmail;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  Future<void> _getUserData() async {
    User? currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      // Fetch user data from Firestore
      DocumentSnapshot userSnapshot =
          await _firestore.collection('users').doc(currentUser.uid).get();

      setState(() {
        _user = currentUser;
        _userName = userSnapshot.get('name');
        _userEmail = currentUser.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            accountName: _userName != null ? Text(_userName!) : null,
            accountEmail: _userEmail != null ? Text(_userEmail!) : null,
            currentAccountPicture: CircleAvatar(
              child: ClipOval(
                child: Image.network(
                  'https://cdn-icons-png.flaticon.com/128/3135/3135715.png',
                  width: 90,
                  height: 90,
                ),
              ),
            ),
            decoration: const BoxDecoration(color: Color(0xFF9f7ced)),
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Color(0xFF9f7ced),
            ),
            title: const Text('Settings'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.add,
              color: Color(0xFF9f7ced),
            ),
            title: const Text('Add Tasks'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const TasksPage()));
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.checklist,
              color: Color(0xFF9f7ced),
            ),
            title: const Text('Terms and Conditions'),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(
              Icons.logout,
              color: Color(0xFF9f7ced),
            ),
            title: const Text('Logout'),
            onTap: () {
              _signOut();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _signOut() async {
    await _firebaseAuth.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const Splash(),
      ),
    ); // Navigate back to the previous screen after sign out
  }
}
