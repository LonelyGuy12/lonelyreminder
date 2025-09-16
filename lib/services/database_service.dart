import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminderapp/event_parser.dart';

class DatabaseService {
  late Future<Isar> db;

  DatabaseService() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [EventSchema],
        directory: dir.path,
        inspector: true,
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<void> saveEvent(Event event) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.events.put(event);
    });
  }

  Future<List<Event>> getEvents() async {
    final isar = await db;
    return await isar.events.where().findAll();
  }
}
