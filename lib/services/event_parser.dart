import 'package:lonelyreminder/models/event_model.dart';
import 'package:chrono/chrono.dart'; // A powerful natural language date parser.

class EventParser {
  /// Parses raw text from OCR to extract event details.
  ///
  /// This function uses the 'chrono' package to intelligently find the first
  /// mention of a date and time in the text. It then assumes the text
  /// preceding the date is the event title.
  ///
  /// Returns a Future that resolves to a structured [Event] object.
  static Future<Event> parseEvent(String text) async {
    // Instantiate the chrono parser.
    final parser = Chrono();
    
    // Use chrono to find the first valid date/time in the text.
    final result = parser.parse(text).firstOrNull;

    String title = text; // Default title is the full text.
    DateTime startTime = DateTime.now(); // Default time is now.

    if (result != null) {
      // If a date was found, set the startTime.
      startTime = result.start.toDateTime();

      // Assume the title is the text leading up to the date match.
      // This is a simple but often effective way to get the title.
      final titleCandidate = text.substring(0, result.start.offset).trim();
      
      // If the extracted title isn't empty, use it.
      if (titleCandidate.isNotEmpty) {
        title = titleCandidate;
      } else {
        // If the date was at the very beginning, the title might be after it.
        // This logic can be improved later.
        title = text.substring(result.end.offset).trim();
      }
    }

    // Create a new Event instance.
    final newEvent = Event()
      ..title = title
      ..startTime = startTime
      ..description = "Parsed from: \"$text\""; // Add context as description

    // Return the structured Event object.
    return newEvent;
  }
}
