







class Event {
  String title;
  DateTime? date;
  String? time;

  Event({required this.title, this.date, this.time});
}

class EventParser {
  Event parse(String text) {
    // Simple regex for date (e.g., 2025-09-16, 09/16/2025)
    final dateRegex = RegExp(r'(\d{4}-\d{2}-\d{2})|(\d{2}/\d{2}/\d{4})');
    // Simple regex for time (e.g., 10:30 AM, 14:00)
    final timeRegex = RegExp(r'(\d{1,2}:\d{2}\s?(AM|PM)?)|' r'(\d{2}:\d{2})');

    final dateMatch = dateRegex.firstMatch(text);
    final timeMatch = timeRegex.firstMatch(text);

    DateTime? eventDate;
    if (dateMatch != null) {
      eventDate = DateTime.parse(dateMatch.group(0)!);
    }

    String? eventTime;
    if (timeMatch != null) {
      eventTime = timeMatch.group(0);
    }

    // For simplicity, the first line is the title
    final title = text.split('\n').first;

    return Event(title: title, date: eventDate, time: eventTime);
  }
}

