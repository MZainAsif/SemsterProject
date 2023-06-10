// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:semesterproject/home.dart';
import 'package:semesterproject/reusable_widgets.dart';
import 'package:semesterproject/signup.dart';

class SignIN extends StatefulWidget {
  const SignIN({Key? key}) : super(key: key);

  @override
  _SignINState createState() => _SignINState();
}

class _SignINState extends State<SignIN> {
  TextEditingController emailTextController = TextEditingController();
  TextEditingController passwordTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailTextController.text,
        password: passwordTextController.text,
      );
      // ignore: use_build_context_synchronously
      Navigator.push(
          context, MaterialPageRoute(builder: (_) => const MyHomePage()));
      print('User logged in: ${userCredential.user?.email}');
      Fluttertoast.showToast(msg: 'Login successful!');
    } on FirebaseAuthException catch (e) {
      print('Login failed: $e');
      Fluttertoast.showToast(msg: 'Login failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF60c5cd),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  20, MediaQuery.of(context).size.height * 0.2, 20, 0),
              child: Column(
                children: <Widget>[
                  const Text(
                    "LOG IN TO DO..",
                    style: TextStyle(fontSize: 35, color: Color(0xFFffdd91)),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  reusableTextField(
                    "Enter your email ",
                    Icons.person_outline,
                    false,
                    emailTextController,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  reusableTextField(
                    "Enter your Password ",
                    Icons.person_outline,
                    false,
                    passwordTextController,
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignupPage(),
                        ),
                      );
                    },
                    child: const Text(
                      "Do not have an Account? SignUp Here",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24.0),
                  firebaseUIButton(context, 'SignIn', () {
                    _login();
                  })
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
