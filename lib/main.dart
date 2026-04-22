import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'data/models/location.dart';
import 'data/models/plant.dart';
import 'data/models/watering_task.dart';
import 'data/repositories/repository_providers.dart';
import 'core/notifications/notification_service.dart';
import 'app.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // Adapter registrieren
  Hive.registerAdapter(LocationAdapter());
  Hive.registerAdapter(PlantAdapter());
  Hive.registerAdapter(WateringTaskAdapter());

  // Boxen öffnen
  await Hive.openBox<Location>('locations');
  await Hive.openBox<Plant>('plants');
  await Hive.openBox<WateringTask>('watering_tasks');
  await Hive.openBox('settings');
  await Hive.openBox<String>('calendar_events');

  await initializeDateFormatting('de', null);

  // Zeitzonen initialisieren
  tz.initializeTimeZones();
  final timeZone = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZone));

  // NotificationService initialisieren
  final notificationService = NotificationService();
  await notificationService.initialize();

  runApp(
    ProviderScope(
      overrides: [
        notificationServiceProvider.overrideWithValue(notificationService),
      ],
      child: const PlantCareApp(),
    ),
  );
}