import 'dart:io';
import 'package:lonelyreminder/models/event_model.dart';
import 'package:lonelyreminder/services/event_parser.dart';

/// A simple OCR test that demonstrates event parsing without actual OCR
/// This replaces the broken OCR functionality with a simple text parsing demo
void main(List<String> arguments) async {
  print('Starting Event Parser test...');

  // Sample text that would normally come from OCR
  const sampleTexts = [
    'Meeting with John tomorrow at 10am',
    'Doctor appointment on Friday at 2:30 PM',
    'Team standup Monday 9:00 AM',
    'Lunch with Sarah next Tuesday at 12:30',
    'Project deadline December 15th',
  ];

  print('Testing event parsing with sample texts:\n');

  for (int i = 0; i < sampleTexts.length; i++) {
    final text = sampleTexts[i];
    print('--- Test ${i + 1} ---');
    print('Input text: "$text"');
    
    try {
      final event = await EventParser.parseEvent(text);
      print('Parsed event:');
      print('  Title: ${event.title}');
      print('  Start time: ${event.startTime}');
      print('  Description: ${event.description ?? 'None'}');
      print('  End time: ${event.endTime ?? 'None'}');
    } catch (e) {
      print('Error parsing event: $e');
    }
    
    print('');
  }

  print('Event parser test completed!');
}
