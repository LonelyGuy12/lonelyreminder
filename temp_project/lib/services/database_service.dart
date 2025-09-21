import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:lonelyreminder/models/event_model.dart';
import 'dart:io';

/// A simple file-based database service for storing events
/// This replaces Isar to avoid build issues while maintaining functionality
class DatabaseService {
  static const String _fileName = 'events.json';
  late File _file;
  bool _initialized = false;

  DatabaseService();

  /// Initialize the database file
  Future<void> _initDB() async {
    if (_initialized) return;
    
    final directory = await getApplicationDocumentsDirectory();
    _file = File('${directory.path}/$_fileName');
    
    // Create file if it doesn't exist
    if (!await _file.exists()) {
      await _file.writeAsString('[]');
    }
    
    _initialized = true;
  }

  /// Adds a new Event object to the database
  Future<void> addEvent(Event newEvent) async {
    await _initDB();
    
    final events = await getAllEvents();
    
    // Generate a simple ID based on timestamp
    final eventMap = {
      'id': DateTime.now().millisecondsSinceEpoch,
      'title': newEvent.title,
      'description': newEvent.description,
      'startTime': newEvent.startTime.toIso8601String(),
      'endTime': newEvent.endTime?.toIso8601String(),
    };
    
    events.add(Event(
      title: eventMap['title'] as String,
      description: eventMap['description'] as String?,
      startTime: DateTime.parse(eventMap['startTime'] as String),
      endTime: eventMap['endTime'] != null ? DateTime.parse(eventMap['endTime'] as String) : null,
    ));
    
    await _saveEvents(events);
  }

  /// Retrieves all events from the database
  Future<List<Event>> getAllEvents() async {
    await _initDB();
    
    try {
      final jsonString = await _file.readAsString();
      final List<dynamic> jsonList = json.decode(jsonString);
      
      return jsonList.map((json) => Event(
        title: json['title'] as String,
        description: json['description'] as String?,
        startTime: DateTime.parse(json['startTime'] as String),
        endTime: json['endTime'] != null ? DateTime.parse(json['endTime'] as String) : null,
      )).toList();
    } catch (e) {
      // If there's an error reading the file, return empty list
      return [];
    }
  }

  /// Saves events to the file
  Future<void> _saveEvents(List<Event> events) async {
    final jsonList = events.map((event) => {
      'title': event.title,
      'description': event.description,
      'startTime': event.startTime.toIso8601String(),
      'endTime': event.endTime?.toIso8601String(),
    }).toList();
    
    await _file.writeAsString(json.encode(jsonList));
  }

  /// Deletes an event from the database based on its title and start time
  /// (Since we don't have unique IDs in this simple implementation)
  Future<void> deleteEvent(String title, DateTime startTime) async {
    await _initDB();
    
    final events = await getAllEvents();
    events.removeWhere((event) => 
      event.title == title && 
      event.startTime.isAtSameMomentAs(startTime)
    );
    
    await _saveEvents(events);
  }

  /// Updates an existing event in the database
  Future<void> updateEvent(Event oldEvent, Event newEvent) async {
    await _initDB();
    
    final events = await getAllEvents();
    final index = events.indexWhere((event) => 
      event.title == oldEvent.title && 
      event.startTime.isAtSameMomentAs(oldEvent.startTime)
    );
    
    if (index != -1) {
      events[index] = newEvent;
      await _saveEvents(events);
    }
  }

  /// Clears all events from the database
  Future<void> clearAllEvents() async {
    await _initDB();
    await _file.writeAsString('[]');
  }
}
