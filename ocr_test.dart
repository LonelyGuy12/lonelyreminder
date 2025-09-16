import 'dart:convert';
import 'dart:io';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:reminderapp/event_parser.dart'; // Assuming Event and EventParser are still relevant

void main(List<String> arguments) async {
  if (arguments.isEmpty) {
    print('Usage: dart ocr_test.dart <image_path>');
    exit(1);
  }

  final imagePath = arguments[0];
  final imageFile = File(imagePath);

  if (!await imageFile.exists()) {
    print('Error: Image file not found at $imagePath');
    exit(1);
  }

  try {
    final textRecognizer = TextRecognizer();
    final recognizedText = await textRecognizer.processImage(InputImage.fromFilePath(imageFile.path));

    final eventParser = EventParser();
    final event = eventParser.parse(recognizedText.text);

    final Map<String, dynamic> result = {
      'success': true,
      'imagePath': imagePath,
      'recognizedText': recognizedText.text,
      'parsedEvent': {
        'title': event.title,
        'date': event.date?.toIso8601String(),
        'time': event.time,
      },
    };
    print(jsonEncode(result));
  } catch (e) {
    final Map<String, dynamic> errorResult = {
      'success': false,
      'imagePath': imagePath,
      'error': e.toString(),
    };
    print(jsonEncode(errorResult));
  }
}
