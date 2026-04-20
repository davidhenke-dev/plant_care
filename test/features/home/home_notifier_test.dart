import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/repositories/plant_repository.dart';
import 'package:plant_care/data/repositories/repository_providers.dart';
import 'package:plant_care/features/home/application/home_notifier.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() async {
    Hive.init('.');
    Hive.registerAdapter(PlantAdapter());
  });

  setUp(() async {
    final box = await Hive.openBox<Plant>('home_notifier_test_plants');
    container = ProviderContainer(
      overrides: [
        plantRepositoryProvider.overrideWithValue(
          PlantRepository(box),
        ),
      ],
    );
  });

  tearDown(() async {
    await Hive.box<Plant>('home_notifier_test_plants').clear();
    container.dispose();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('zeigt nur Pflanzen die heute gegossen werden müssen', () async {
    final repo = container.read(plantRepositoryProvider);

    final brauchtWasser = Plant(
      id: 'p1',
      name: 'Monstera',
      locationId: 'loc1',
      wateringIntervalDays: 7,
      createdAt: DateTime.now(),
      lastWateredAt: DateTime.now().subtract(const Duration(days: 8)),
    );
    final frischGegossen = Plant(
      id: 'p2',
      name: 'Kaktus',
      locationId: 'loc1',
      wateringIntervalDays: 14,
      createdAt: DateTime.now(),
      lastWateredAt: DateTime.now(),
    );

    await repo.save(brauchtWasser);
    await repo.save(frischGegossen);

    final state = await container.read(homeNotifierProvider.future);
    expect(state.length, 1);
    expect(state.first.name, 'Monstera');
  });

  test('markAsWatered entfernt Pflanze aus der Liste', () async {
    final repo = container.read(plantRepositoryProvider);

    final plant = Plant(
      id: 'p3',
      name: 'Ficus',
      locationId: 'loc1',
      wateringIntervalDays: 7,
      createdAt: DateTime.now(),
      lastWateredAt: null,
    );

    await repo.save(plant);

    final notifier = container.read(homeNotifierProvider.notifier);
    await notifier.markAsWatered('p3');

    final updated = await container.read(homeNotifierProvider.future);
    expect(updated, isEmpty);
  });
}