// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
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
                    'Today\'s Tasks',
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
                      'Upcoming Events',
                      style: TextStyle(fontSize: 28, color: Color(0xFFffdd91)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('events')
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return const Text('Error occurred');
                          }

                          if (snapshot.hasData) {
                            final events = snapshot.data!.docs;

                            return Column(
                              children: events.map((event) {
                                final title = event['title'] as String;
                                final date = event['date'] as Timestamp;

                                return Container(
                                  color: const Color(0xFFffdd91),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Text(
                                      '$title - $date',
                                    ),
                                  ),
                                );
                              }).toList(),
                            );
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
