class Event {
  /// The main title of the event.
  String title;

  /// An optional, longer description for the event.
  String? description;

  /// The start date and time of the event.
  DateTime startTime;

  /// The optional end date and time of the event.
  DateTime? endTime;

  Event({
    required this.title,
    this.description,
    required this.startTime,
    this.endTime,
  });

  @override
  String toString() {
    return 'Event(title: "$title", startTime: $startTime)';
  }
}
