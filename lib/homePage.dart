// ignore_for_file: file_names

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF60c5cd),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(padding: EdgeInsets.all(20.0)),
                Text(
                  'Todays Tasks',
                  style: TextStyle(fontSize: 28, color: Color(0xFFffdd91)),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: LinearProgressIndicator(
                    backgroundColor: Colors.white,
                    value: 0.5,
                    minHeight: 8.0,
                    valueColor: AlwaysStoppedAnimation(Color(0xFFffdd91)),
                  ),
                ),
                Padding(padding: EdgeInsets.all(20.0)),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF60c5cd),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const Text(
                    'Up comming Events',
                    style: TextStyle(fontSize: 28, color: Color(0xFFffdd91)),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Container(
                          color: const Color(0xFFffdd91),
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text('4 Upcomming Events Check Clander'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
