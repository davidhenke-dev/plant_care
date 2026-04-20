import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'data/models/location.dart';
import 'data/models/plant.dart';
import 'data/models/watering_task.dart';
import 'app.dart';

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

  runApp(
    const ProviderScope(
      child: PlantCareApp(),
    ),
  );
}