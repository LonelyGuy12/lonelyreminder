import 'package:isar/isar.dart';
import 'package:lonelyreminder/models/event_model.dart'; // Import the new Event model
import 'package/path_provider/path_provider.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = _initDB();
  }

  Future<Isar> _initDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      // Open an Isar instance and tell it about our Event collection.
      return await Isar.open(
        [EventSchema], // We now use the generated EventSchema
        directory: dir.path,
        name: 'lonely_reminder_db',
      );
    }
    return Future.value(Isar.getInstance());
  }

  /// Adds a new Event object to the database.
  /// This is now type-safe. You can only pass in an Event object.
  Future<void> addEvent(Event newEvent) async {
    final isar = await db;
    // Use a transaction to write the new event to the 'events' collection.
    await isar.writeTxn(() async {
      await isar.events.put(newEvent);
    });
  }

  /// Retrieves all events from the database.
  /// The return type is a Future that resolves to a List of Event objects.
  Future<List<Event>> getAllEvents() async {
    final isar = await db;
    // Query the 'events' collection to find all records.
    return await isar.events.where().findAll();
  }

  /// Deletes an event from the database based on its unique Id.
  Future<void> deleteEvent(int eventId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.events.delete(eventId);
    });
  }

  /// Updates an existing event in the database.
  /// Isar is smart enough to find the event by its Id and update it.
  Future<void> updateEvent(Event eventToUpdate) async {
    final isar = await db;
     await isar.writeTxn(() async {
      await isar.events.put(eventToUpdate);
    });
  }

  // You can add more specific query methods here as your app grows.
  // For example:
  // Future<List<Event>> getEventsForDate(DateTime date) async { ... }
}

