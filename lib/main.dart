import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/models/location.dart';
import 'package:plant_care/data/models/watering_task.dart';

void main() {
  group('Plant Model', () {
    test('needsWateringToday ist true wenn nie gegossen', () {
      final plant = Plant(
        id: '1',
        name: 'Monstera',
        locationId: 'loc1',
        wateringIntervalDays: 7,
        createdAt: DateTime.now(),
        lastWateredAt: null,
      );
      expect(plant.needsWateringToday, isTrue);
    });

    test('needsWateringToday ist false wenn heute gegossen', () {
      final plant = Plant(
        id: '1',
        name: 'Monstera',
        locationId: 'loc1',
        wateringIntervalDays: 7,
        createdAt: DateTime.now(),
        lastWateredAt: DateTime.now(),
      );
      expect(plant.needsWateringToday, isFalse);
    });

    test('needsWateringToday ist true wenn Intervall überschritten', () {
      final plant = Plant(
        id: '1',
        name: 'Monstera',
        locationId: 'loc1',
        wateringIntervalDays: 7,
        createdAt: DateTime.now(),
        lastWateredAt: DateTime.now().subtract(const Duration(days: 8)),
      );
      expect(plant.needsWateringToday, isTrue);
    });
  });

  group('Location Model', () {
    test('light getter gibt korrekten LightLevel zurück', () {
      final location = Location(
        id: 'loc1',
        name: 'Wohnzimmer',
        lightLevel: LightLevel.partialSun.index,
        humidityLevel: HumidityLevel.moderate.index,
        createdAt: DateTime.now(),
      );
      expect(location.light, LightLevel.partialSun);
      expect(location.humidity, HumidityLevel.moderate);
    });
  });

  group('WateringTask Model', () {
    test('isDone ist standardmäßig false', () {
      final task = WateringTask(
        id: 'task1',
        plantId: 'plant1',
        scheduledFor: DateTime.now(),
      );
      expect(task.isDone, isFalse);
    });
  });
}