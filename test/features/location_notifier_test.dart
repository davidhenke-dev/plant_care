import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_care/data/models/location.dart';
import 'package:plant_care/data/repositories/location_repository.dart';
import 'package:plant_care/data/repositories/repository_providers.dart';
import 'package:plant_care/features/locations/application/location_notifier.dart';

void main() {
  late ProviderContainer container;

  setUpAll(() async {
    Hive.init('.');
    Hive.registerAdapter(LocationAdapter());
  });

  setUp(() async {
    final box = await Hive.openBox<Location>('notifier_test_locations');
    container = ProviderContainer(
      overrides: [
        locationRepositoryProvider.overrideWithValue(
          LocationRepository(box),
        ),
      ],
    );
  });

  tearDown(() async {
    await Hive.box<Location>('notifier_test_locations').clear();
    container.dispose();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  test('addLocation fügt einen Standort hinzu', () async {
    final notifier = container.read(locationNotifierProvider.notifier);

    await notifier.addLocation(
      name: 'Wohnzimmer',
      lightLevel: LightLevel.fullSun,
      humidityLevel: HumidityLevel.moderate,
    );

    final state = await container.read(locationNotifierProvider.future);
    expect(state.length, 1);
    expect(state.first.name, 'Wohnzimmer');
  });

  test('deleteLocation entfernt einen Standort', () async {
    final notifier = container.read(locationNotifierProvider.notifier);

    await notifier.addLocation(
      name: 'Küche',
      lightLevel: LightLevel.shade,
      humidityLevel: HumidityLevel.dry,
    );

    final locations = await container.read(locationNotifierProvider.future);
    await notifier.deleteLocation(locations.first.id);

    final updated = await container.read(locationNotifierProvider.future);
    expect(updated, isEmpty);
  });
}