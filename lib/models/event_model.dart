import 'package:isar/isar.dart';

// This line is required for Isar to generate the necessary code.
// After adding this file, you will need to run a command in your terminal.
part 'event_model.g.dart';

/// Represents a single event item in the application.
/// The @collection annotation tells Isar to create a table (collection) for this object.
@collection
class Event {
  /// Isar requires a unique Id for each object.
  /// We use `Isar.autoIncrement` to let the database handle this automatically.
  Id id = Isar.autoIncrement;

  /// The main title of the event.
  late String title;

  /// An optional, longer description for the event.
  String? description;

  /// The start date and time of the event.
  /// We use `late` because it will always be assigned.
  late DateTime startTime;

  /// The optional end date and time of the event.
  DateTime? endTime;

  // An empty constructor is needed for Isar to create objects from the database.
  Event();

  @override
  String toString() {
    return 'Event(id: $id, title: "$title", startTime: $startTime)';
  }
}
