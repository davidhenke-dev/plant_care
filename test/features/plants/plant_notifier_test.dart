import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/repositories/plant_repository.dart';
import 'package:plant_care/data/repositories/repository_providers.dart';
import 'package:plant_care/features/plants/application/plant_notifier.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() async {
    Hive.init('.');
    Hive.registerAdapter(PlantAdapter());
  });

  setUp(() async {
    final box = await Hive.openBox<Plant>('notifier_test_plants');
    container = ProviderContainer(
      overrides: [
        plantRepositoryProvider.overrideWithValue(
          PlantRepository(box),
        ),
      ],
    );
  });

  tearDown(() async {
    await Hive.box<Plant>('notifier_test_plants').clear();
    container.dispose();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('addPlant fügt eine Pflanze hinzu', () async {
    final notifier = container.read(plantNotifierProvider.notifier);

    await notifier.addPlant(
      name: 'Monstera',
      locationId: 'loc1',
      wateringIntervalDays: 7,
    );

    final state = await container.read(plantNotifierProvider.future);
    expect(state.length, 1);
    expect(state.first.name, 'Monstera');
  });

  test('deletePlant entfernt eine Pflanze', () async {
    final notifier = container.read(plantNotifierProvider.notifier);

    await notifier.addPlant(
      name: 'Ficus',
      locationId: 'loc1',
      wateringIntervalDays: 5,
    );

    final plants = await container.read(plantNotifierProvider.future);
    await notifier.deletePlant(plants.first.id);

    final updated = await container.read(plantNotifierProvider.future);
    expect(updated, isEmpty);
  });

  test('markAsWatered setzt lastWateredAt', () async {
    final notifier = container.read(plantNotifierProvider.notifier);

    await notifier.addPlant(
      name: 'Kaktus',
      locationId: 'loc1',
      wateringIntervalDays: 14,
    );

    final plants = await container.read(plantNotifierProvider.future);
    await notifier.markAsWatered(plants.first.id);

    final updated = await container.read(plantNotifierProvider.future);
    expect(updated.first.lastWateredAt, isNotNull);
    expect(updated.first.needsWateringToday, isFalse);
  });

  test('updatePlant aktualisiert Name und Gießintervall', () async {
    final notifier = container.read(plantNotifierProvider.notifier);

    await notifier.addPlant(
      name: 'Monstera',
      locationId: 'loc1',
      wateringIntervalDays: 7,
    );

    final plants = await container.read(plantNotifierProvider.future);
    await notifier.updatePlant(
      id: plants.first.id,
      name: 'Monstera Deliciosa',
      locationId: 'loc2',
      wateringIntervalDays: 10,
      notes: 'Liebt Wasser',
    );

    final updated = await container.read(plantNotifierProvider.future);
    expect(updated.first.name, 'Monstera Deliciosa');
    expect(updated.first.locationId, 'loc2');
    expect(updated.first.wateringIntervalDays, 10);
    expect(updated.first.notes, 'Liebt Wasser');
  });
}