// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:semesterproject/home.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                  ),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 24.0),
                ElevatedButton(
                  onPressed: register,
                  child: const Text('Sign Up'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future register() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures, unused_local_variable
    User? user = await FirebaseAuth.instance.currentUser;
    try {
      await auth
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text)
          .then((signedInUser) => {
                FirebaseFirestore.instance
                    .collection('users')
                    .doc(signedInUser.user!.uid)
                    .set({
                  'name': _nameController.text,
                  'email': _emailController.text,
                  'password': _passwordController.text,
                }).then((signedInUser) => {
                          print('Succes'),
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const MyHomePage(),
                            ),
                          ),
                          Fluttertoast.showToast(
                              msg: "Account created Successfully"),
                        })
              });
    } catch (e) {
      Fluttertoast.showToast(msg: 'Account creation failed');
    }
  }
}
