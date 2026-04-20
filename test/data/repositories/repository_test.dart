import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_care/data/models/location.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/models/watering_task.dart';
import 'package:plant_care/data/repositories/location_repository.dart';
import 'package:plant_care/data/repositories/plant_repository.dart';
import 'package:plant_care/data/repositories/watering_task_repository.dart';

void main() {
  late LocationRepository locationRepo;
  late PlantRepository plantRepo;
  late WateringTaskRepository taskRepo;

  setUpAll(() async {
    Hive.init('.');
    Hive.registerAdapter(LocationAdapter());
    Hive.registerAdapter(PlantAdapter());
    Hive.registerAdapter(WateringTaskAdapter());
  });

  setUp(() async {
    locationRepo = LocationRepository(
      await Hive.openBox<Location>('repo_test_locations'),
    );
    plantRepo = PlantRepository(
      await Hive.openBox<Plant>('repo_test_plants'),
    );
    taskRepo = WateringTaskRepository(
      await Hive.openBox<WateringTask>('repo_test_tasks'),
    );
  });

  tearDown(() async {
    await locationRepo.deleteAll();
    await plantRepo.deleteAll();
    await taskRepo.deleteAll();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  group('LocationRepository', () {
    test('save und getAll', () async {
      final location = Location(
        id: 'loc1',
        name: 'Wohnzimmer',
        lightLevel: LightLevel.fullSun.index,
        humidityLevel: HumidityLevel.moderate.index,
        createdAt: DateTime.now(),
      );

      await locationRepo.save(location);
      final all = await locationRepo.getAll();

      expect(all.length, 1);
      expect(all.first.name, 'Wohnzimmer');
    });

    test('getById gibt null zurück wenn nicht vorhanden', () async {
      final result = await locationRepo.getById('nicht_vorhanden');
      expect(result, isNull);
    });

    test('delete entfernt Location', () async {
      final location = Location(
        id: 'loc2',
        name: 'Küche',
        lightLevel: 0,
        humidityLevel: 0,
        createdAt: DateTime.now(),
      );

      await locationRepo.save(location);
      await locationRepo.delete('loc2');

      expect(await locationRepo.getById('loc2'), isNull);
    });
  });

  group('PlantRepository', () {
    test('getByLocation filtert korrekt', () async {
      final p1 = Plant(id: 'p1', name: 'Monstera', locationId: 'loc1', wateringIntervalDays: 7, createdAt: DateTime.now());
      final p2 = Plant(id: 'p2', name: 'Ficus', locationId: 'loc2', wateringIntervalDays: 5, createdAt: DateTime.now());
      final p3 = Plant(id: 'p3', name: 'Kaktus', locationId: 'loc1', wateringIntervalDays: 14, createdAt: DateTime.now());

      await plantRepo.save(p1);
      await plantRepo.save(p2);
      await plantRepo.save(p3);

      final result = await plantRepo.getByLocation('loc1');
      expect(result.length, 2);
      expect(result.map((p) => p.name), containsAll(['Monstera', 'Kaktus']));
    });

    test('getPlantsNeedingWater gibt nur fällige Pflanzen zurück', () async {
      final p1 = Plant(
        id: 'p4', name: 'Braucht Wasser', locationId: 'loc1',
        wateringIntervalDays: 7, createdAt: DateTime.now(),
        lastWateredAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      final p2 = Plant(
        id: 'p5', name: 'Frisch gegossen', locationId: 'loc1',
        wateringIntervalDays: 7, createdAt: DateTime.now(),
        lastWateredAt: DateTime.now(),
      );

      await plantRepo.save(p1);
      await plantRepo.save(p2);

      final result = await plantRepo.getPlantsNeedingWater();
      expect(result.length, 1);
      expect(result.first.name, 'Braucht Wasser');
    });
  });

  group('WateringTaskRepository', () {
    test('getTasksForToday gibt nur heutige Tasks zurück', () async {
      final today = WateringTask(
        id: 't1', plantId: 'p1',
        scheduledFor: DateTime.now(),
      );
      final tomorrow = WateringTask(
        id: 't2', plantId: 'p2',
        scheduledFor: DateTime.now().add(const Duration(days: 1)),
      );

      await taskRepo.save(today);
      await taskRepo.save(tomorrow);

      final result = await taskRepo.getTasksForToday();
      expect(result.length, 1);
      expect(result.first.id, 't1');
    });

    test('markAsDone setzt isDone und completedAt', () async {
      final task = WateringTask(
        id: 't3', plantId: 'p1',
        scheduledFor: DateTime.now(),
      );

      await taskRepo.save(task);
      await taskRepo.markAsDone('t3');

      final result = await taskRepo.getById('t3');
      expect(result!.isDone, isTrue);
      expect(result.completedAt, isNotNull);
    });

    test('getOpenTasks filtert erledigte Tasks heraus', () async {
      final open = WateringTask(id: 't4', plantId: 'p1', scheduledFor: DateTime.now());
      final done = WateringTask(id: 't5', plantId: 'p2', scheduledFor: DateTime.now(), isDone: true);

      await taskRepo.save(open);
      await taskRepo.save(done);

      final result = await taskRepo.getOpenTasks();
      expect(result.length, 1);
      expect(result.first.id, 't4');
    });
  });
}