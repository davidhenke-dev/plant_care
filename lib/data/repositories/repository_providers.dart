import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/location.dart';
import '../models/plant.dart';
import '../models/watering_task.dart';
import '../../core/notifications/notification_service.dart';
import '../../core/calendar/calendar_event_store.dart';
import '../../core/calendar/calendar_service.dart';
import '../../core/plant_search/plant_search_service.dart';
import 'location_repository.dart';
import 'plant_repository.dart';
import 'watering_task_repository.dart';

final locationRepositoryProvider = Provider<LocationRepository>((ref) {
  return LocationRepository(Hive.box<Location>('locations'));
});

final plantRepositoryProvider = Provider<PlantRepository>((ref) {
  return PlantRepository(Hive.box<Plant>('plants'));
});

final wateringTaskRepositoryProvider = Provider<WateringTaskRepository>((ref) {
  return WateringTaskRepository(Hive.box<WateringTask>('watering_tasks'));
});

final settingsBoxProvider = Provider<Box>((ref) => Hive.box('settings'));

final notificationServiceProvider =
    Provider<NotificationService>((ref) => NotificationService());

final calendarEventStoreProvider = Provider<CalendarEventStore>(
  (ref) => CalendarEventStore(Hive.box<String>('calendar_events')),
);

final calendarServiceProvider =
    Provider<CalendarService>((ref) => CalendarService());

final plantSearchServiceProvider =
    Provider<PlantSearchService>((ref) => PlantSearchService());