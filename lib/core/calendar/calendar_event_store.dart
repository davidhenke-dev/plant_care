import 'package:hive_flutter/hive_flutter.dart';

/// Speichert die Zuordnung plantId → calendarEventId in einer Hive-Box.
class CalendarEventStore {
  CalendarEventStore(this._box);

  final Box<String> _box;

  String? getEventId(String plantId) => _box.get(plantId);

  Future<void> setEventId(String plantId, String eventId) =>
      _box.put(plantId, eventId);

  Future<void> removeEventId(String plantId) => _box.delete(plantId);

  bool hasEvent(String plantId) => _box.containsKey(plantId);
}
