import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Note {
  final String id;
  final String description;
  final String dateTime;
  final String location;

  Note({
    required this.id,
    required this.description,
    required this.dateTime,
    required this.location,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['empid'],
      description: json['description'],
      dateTime: json['time'],
      location: json['location'],
    );
  }
}

class NoteService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static Future<List<Note>> fetchNotes() async {
    final response = await http.get(Uri.parse('$baseUrl/notes/'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => Note.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load notes');
    }
  }

  static Future<void> addNote(String description, String location) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var empid = prefs.getString("empId");
    final response = await http.post(
      Uri.parse('$baseUrl/notes/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'empid': "S101",
        'description': description,
        'location': location,
        'time': DateTime.now().toIso8601String(),
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('Failed to add note');
    }
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<Note> notes = [];
  final TextEditingController _descriptionController = TextEditingController();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    fetchNotes();
    _getCurrentLocation();
  }

  Future<void> fetchNotes() async {
    try {
      final List<Note> fetchedNotes = await NoteService.fetchNotes();
      print(fetchedNotes.length);
      setState(() {
        notes = fetchedNotes;
      });
      print(notes);
    } catch (e) {
      print(e);
      // Handle error
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission != LocationPermission.whileInUse &&
            permission != LocationPermission.always) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Location Permission Required'),
              content: const Text(
                  'Please grant permission to access your location.'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
          return;
        }
      }
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to retrieve location.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      body: notes.isEmpty
          ? Center(child: Text("No notes added"))
          : ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  title: Text(note.description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date & Time: ${note.dateTime}'),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Add Note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _descriptionController,
                    decoration:
                        const InputDecoration(hintText: 'Enter description'),
                  ),
                  if (_currentPosition != null)
                    Text('Current Location: ${_currentPosition!.latitude}, '
                        '${_currentPosition!.longitude}'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    final description = _descriptionController.text;
                    final location = _currentPosition != null
                        ? '${_currentPosition!.latitude},${_currentPosition!.longitude}'
                        : '';
                    if (description.isNotEmpty) {
                      await NoteService.addNote(description, location);
                      Navigator.pop(context);
                      fetchNotes();
                    }
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
