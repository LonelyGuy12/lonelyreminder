import 'package:flutter/material.dart';
import 'package:lonelyreminder/models/event_model.dart';
import 'package:lonelyreminder/services/event_parser.dart';
import 'package:intl/intl.dart'; // For formatting the date nicely

class OcrTest extends StatefulWidget {
  const OcrTest({super.key});

  @override
  State<OcrTest> createState() => _OcrTestState();
}

class _OcrTestState extends State<OcrTest> {
  String? _ocrText;
  Event? _parsedEvent;
  bool _isLoading = false;

  Future<void> _processImageAndCreateEvent() async {
    // Reset state and show loading indicator
    setState(() {
      _isLoading = true;
      _ocrText = null;
      _parsedEvent = null;
    });

    try {
      const rawText = 'Meeting with John tomorrow at 10am';

      setState(() {
        _ocrText = rawText;
      });

      // 4. Parse text with our refactored EventParser
      // This now correctly returns a structured 'Event' object
      final Event parsedEvent = await EventParser.parseEvent(rawText);
      setState(() {
        _parsedEvent = parsedEvent;
      });

      // Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Event "${parsedEvent.title}" created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Show an error message if anything goes wrong
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('An error occurred: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Hide loading indicator
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OCR Event Scanner'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              if (!_isLoading) ...[
                ElevatedButton.icon(
                  onPressed: () => _processImageAndCreateEvent(),
                  icon: const Icon(Icons.add),
                  label: const Text('Create Dummy Event'),
                ),
              ],
              const SizedBox(height: 30),
              if (_ocrText != null) ...[
                const Text('Extracted Text:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_ocrText!),
                ),
                const Divider(height: 40),
              ],
              if (_parsedEvent != null) ...[
                const Text('Parsed Event:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 10),
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: ${_parsedEvent!.title}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text('Start Time: ${DateFormat.yMMMd().add_jm().format(_parsedEvent!.startTime)}'),
                        if(_parsedEvent!.description != null) ...[
                          const SizedBox(height: 5),
                          Text('Description: ${_parsedEvent!.description}'),
                        ]
                      ],
                    ),
                  ),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
