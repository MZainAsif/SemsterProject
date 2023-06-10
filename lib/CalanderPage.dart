// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> events = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   elevation: 0.0,
      //   centerTitle: true,
      //   backgroundColor: Colors.white,
      //   automaticallyImplyLeading: false,
      //   title: const Text('Calendar'),
      // ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              calendarFormat: calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2021),
              lastDay: DateTime.utc(2030),
              selectedDayPredicate: (day) => _selectedDay == day,
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              eventLoader: _getEventsForDay,
              calendarStyle: const CalendarStyle(
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
                markerMargin: EdgeInsets.symmetric(horizontal: 4),
                markerSizeScale: 0.15,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _showAddEventDialog(context);
              },
              child: const Text('Add Event'),
            ),
            const SizedBox(height: 20),
            if (_selectedDay != null && events.containsKey(_selectedDay))
              Column(
                children: events[_selectedDay]!
                    .map((event) => ListTile(
                          title: Text(
                            event,
                            style: const TextStyle(
                              color: Colors.black,
                              wordSpacing: 2,
                              fontSize: 20,
                            ),
                          ),
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }

  List<String> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  Future<void> _showAddEventDialog(BuildContext context) async {
    String eventTitle = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Event'),
          content: TextField(
            onChanged: (value) {
              eventTitle = value;
            },
            decoration: const InputDecoration(
              hintText: 'Event Title',
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (eventTitle.isNotEmpty && _selectedDay != null) {
                  setState(() {
                    events[_selectedDay!] ??= [];
                    events[_selectedDay!]!.add(eventTitle);
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
