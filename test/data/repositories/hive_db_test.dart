import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_care/data/models/location.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/models/watering_task.dart';

void main() {
  late Box<Location> locationBox;
  late Box<Plant> plantBox;
  late Box<WateringTask> taskBox;

  setUpAll(() async {
    // Hive im Test-Modus initialisieren (In-Memory, kein Dateisystem)
    Hive.init('.');
    Hive.registerAdapter(LocationAdapter());
    Hive.registerAdapter(PlantAdapter());
    Hive.registerAdapter(WateringTaskAdapter());
  });

  setUp(() async {
    locationBox = await Hive.openBox<Location>('test_locations');
    plantBox = await Hive.openBox<Plant>('test_plants');
    taskBox = await Hive.openBox<WateringTask>('test_tasks');
  });

  tearDown(() async {
    // Box nach jedem Test leeren damit Tests unabhängig sind
    await locationBox.clear();
    await plantBox.clear();
    await taskBox.clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('Location Box', () {
    test('Location speichern und lesen', () async {
      final location = Location(
        id: 'loc1',
        name: 'Wohnzimmer',
        lightLevel: LightLevel.partialSun.index,
        humidityLevel: HumidityLevel.moderate.index,
        createdAt: DateTime.now(),
      );

      await locationBox.put(location.id, location);

      final result = locationBox.get('loc1');
      expect(result, isNotNull);
      expect(result!.name, 'Wohnzimmer');
      expect(result.light, LightLevel.partialSun);
    });

    test('Location löschen', () async {
      final location = Location(
        id: 'loc2',
        name: 'Schlafzimmer',
        lightLevel: LightLevel.shade.index,
        humidityLevel: HumidityLevel.dry.index,
        createdAt: DateTime.now(),
      );

      await locationBox.put(location.id, location);
      await locationBox.delete('loc2');

      expect(locationBox.get('loc2'), isNull);
    });

    test('Alle Locations abrufen', () async {
      final locations = [
        Location(id: 'loc3', name: 'Küche', lightLevel: 0, humidityLevel: 1, createdAt: DateTime.now()),
        Location(id: 'loc4', name: 'Bad', lightLevel: 1, humidityLevel: 2, createdAt: DateTime.now()),
      ];

      for (final l in locations) {
        await locationBox.put(l.id, l);
      }

      expect(locationBox.values.length, 2);
    });
  });

  group('Plant Box', () {
    test('Plant speichern und lesen', () async {
      final plant = Plant(
        id: 'plant1',
        name: 'Monstera',
        locationId: 'loc1',
        wateringIntervalDays: 7,
        createdAt: DateTime.now(),
      );

      await plantBox.put(plant.id, plant);

      final result = plantBox.get('plant1');
      expect(result, isNotNull);
      expect(result!.name, 'Monstera');
      expect(result.wateringIntervalDays, 7);
    });

    test('Plant aktualisieren', () async {
      final plant = Plant(
        id: 'plant2',
        name: 'Ficus',
        locationId: 'loc1',
        wateringIntervalDays: 5,
        createdAt: DateTime.now(),
      );

      await plantBox.put(plant.id, plant);
      plant.lastWateredAt = DateTime.now();
      await plant.save();

      final result = plantBox.get('plant2');
      expect(result!.lastWateredAt, isNotNull);
    });

    test('Plant löschen', () async {
      final plant = Plant(
        id: 'plant3',
        name: 'Kaktus',
        locationId: 'loc1',
        wateringIntervalDays: 14,
        createdAt: DateTime.now(),
      );

      await plantBox.put(plant.id, plant);
      await plantBox.delete('plant3');

      expect(plantBox.get('plant3'), isNull);
    });
  });

  group('WateringTask Box', () {
    test('Task speichern und als erledigt markieren', () async {
      final task = WateringTask(
        id: 'task1',
        plantId: 'plant1',
        scheduledFor: DateTime.now(),
      );

      await taskBox.put(task.id, task);

      task.isDone = true;
      task.completedAt = DateTime.now();
      await task.save();

      final result = taskBox.get('task1');
      expect(result!.isDone, isTrue);
      expect(result.completedAt, isNotNull);
    });

    test('Offene Tasks filtern', () async {
      final tasks = [
        WateringTask(id: 't1', plantId: 'p1', scheduledFor: DateTime.now(), isDone: false),
        WateringTask(id: 't2', plantId: 'p2', scheduledFor: DateTime.now(), isDone: true),
        WateringTask(id: 't3', plantId: 'p3', scheduledFor: DateTime.now(), isDone: false),
      ];

      for (final t in tasks) {
        await taskBox.put(t.id, t);
      }

      final openTasks = taskBox.values.where((t) => !t.isDone).toList();
      expect(openTasks.length, 2);
    });
  });
}