import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/plant_repository.dart';
import '../../../data/repositories/repository_providers.dart';

class PlantNotifier extends AsyncNotifier<List<Plant>> {
  late PlantRepository _repository;

  @override
  Future<List<Plant>> build() async {
    _repository = ref.read(plantRepositoryProvider);
    return _repository.getAll();
  }

  Future<void> addPlant({
    required String name,
    String? locationId,
    required int wateringIntervalDays,
    String? imagePath,
    String? notes,
    int? fertilizingIntervalWeeks,
  }) async {
    final plant = Plant(
      id: const Uuid().v4(),
      name: name,
      locationId: locationId,
      wateringIntervalDays: wateringIntervalDays,
      imagePath: imagePath,
      notes: notes,
      createdAt: DateTime.now(),
      fertilizingIntervalWeeks: fertilizingIntervalWeeks,
    );
    await _repository.save(plant);
    await _syncCalendarCreate(plant);
    ref.invalidateSelf();
  }

  Future<void> deletePlant(String id) async {
    await _syncCalendarDelete(id);
    await _repository.delete(id);
    ref.invalidateSelf();
  }

  Future<void> markAsWatered(String id) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.lastWateredAt = DateTime.now();
      await plant.save();
      await _syncCalendarUpdate(plant);
      ref.invalidateSelf();
    }
  }

  Future<void> updateImagePath(String id, String imagePath) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.imagePath = imagePath;
      await plant.save();
      ref.invalidateSelf();
    }
  }

  Future<void> markAsFertilized(String id) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.lastFertilizedAt = DateTime.now();
      await plant.save();
      ref.invalidateSelf();
    }
  }

  Future<void> updatePlant({
    required String id,
    required String name,
    String? locationId,
    required int wateringIntervalDays,
    String? notes,
    int? fertilizingIntervalWeeks,
  }) async {
    final plant = await _repository.getById(id);
    if (plant != null) {
      plant.name = name;
      plant.locationId = locationId;
      plant.wateringIntervalDays = wateringIntervalDays;
      plant.notes = notes;
      plant.fertilizingIntervalWeeks = fertilizingIntervalWeeks;
      await plant.save();
      await _syncCalendarUpdate(plant);
      ref.invalidateSelf();
    }
  }

  // ── Kalender-Sync ─────────────────────────────────────────────────────────

  Future<void> _syncCalendarCreate(Plant plant) async {
    try {
      final store = ref.read(calendarEventStoreProvider);
      final service = ref.read(calendarServiceProvider);
      if (!await service.hasPermissions()) return;
      final eventId = await service.createEvent(plant);
      if (eventId != null) await store.setEventId(plant.id, eventId);
    } catch (_) {}
  }

  Future<void> _syncCalendarUpdate(Plant plant) async {
    try {
      final store = ref.read(calendarEventStoreProvider);
      final service = ref.read(calendarServiceProvider);
      if (!await service.hasPermissions()) return;
      final existingId = store.getEventId(plant.id);
      final eventId = existingId != null
          ? await service.updateEvent(existingId, plant)
          : await service.createEvent(plant);
      if (eventId != null) await store.setEventId(plant.id, eventId);
    } catch (_) {}
  }

  Future<void> _syncCalendarDelete(String plantId) async {
    try {
      final store = ref.read(calendarEventStoreProvider);
      final service = ref.read(calendarServiceProvider);
      final eventId = store.getEventId(plantId);
      if (eventId != null) {
        await service.deleteEvent(eventId);
        await store.removeEventId(plantId);
      }
    } catch (_) {}
  }
}

final plantNotifierProvider =
    AsyncNotifierProvider<PlantNotifier, List<Plant>>(
  PlantNotifier.new,
);
