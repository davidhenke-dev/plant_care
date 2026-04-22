import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart' show Color;
import '../../data/models/plant.dart';

class CalendarService {
  CalendarService({DeviceCalendarPlugin? plugin})
      : _plugin = plugin ?? DeviceCalendarPlugin();

  final DeviceCalendarPlugin _plugin;
  String? _calendarId;

  Future<bool> requestPermissions() async {
    final result = await _plugin.requestPermissions();
    return result.data == true;
  }

  Future<bool> hasPermissions() async {
    final result = await _plugin.hasPermissions();
    return result.data == true;
  }

  /// Gibt die ID des PlantCare-Kalenders zurück (erstellt ihn falls nötig).
  Future<String?> _getOrCreateCalendarId() async {
    if (_calendarId != null) return _calendarId;

    final result = await _plugin.retrieveCalendars();
    final calendars = result.data;
    if (calendars == null) return null;

    final existing = calendars.where((c) => c.name == 'PlantCare').firstOrNull;
    if (existing != null) {
      _calendarId = existing.id;
      return _calendarId;
    }

    final created = await _plugin.createCalendar(
      'PlantCare',
      calendarColor: const Color(0xFF4CAF50),
    );
    _calendarId = created.data;
    return _calendarId;
  }

  Future<String?> createEvent(Plant plant) async {
    final calendarId = await _getOrCreateCalendarId();
    if (calendarId == null) return null;

    final event = _buildEvent(calendarId, null, plant);
    final result = await _plugin.createOrUpdateEvent(event);
    return result?.data;
  }

  Future<String?> updateEvent(String eventId, Plant plant) async {
    final calendarId = await _getOrCreateCalendarId();
    if (calendarId == null) return null;

    final event = _buildEvent(calendarId, eventId, plant);
    final result = await _plugin.createOrUpdateEvent(event);
    return result?.data;
  }

  Future<void> deleteEvent(String eventId) async {
    final calendarId = await _getOrCreateCalendarId();
    if (calendarId == null) return;
    await _plugin.deleteEvent(calendarId, eventId);
  }

  Event _buildEvent(String calendarId, String? eventId, Plant plant) {
    final nextWatering = _nextWateringDate(plant);

    return Event(
      calendarId,
      eventId: eventId,
      title: '💧 ${plant.name} gießen',
      start: nextWatering,
      end: nextWatering.add(const Duration(minutes: 30)),
      allDay: false,
      reminders: [Reminder(minutes: 60)],
      recurrenceRule: RecurrenceRule(
        RecurrenceFrequency.Daily,
        interval: plant.wateringIntervalDays,
      ),
    );
  }

  DateTime _nextWateringDate(Plant plant) {
    final now = DateTime.now();
    if (plant.lastWateredAt == null) {
      return DateTime(now.year, now.month, now.day, 8);
    }
    var next = plant.lastWateredAt!
        .add(Duration(days: plant.wateringIntervalDays))
        .copyWith(hour: 8, minute: 0, second: 0, millisecond: 0);
    while (next.isBefore(now)) {
      next = next.add(Duration(days: plant.wateringIntervalDays));
    }
    return next;
  }
}
