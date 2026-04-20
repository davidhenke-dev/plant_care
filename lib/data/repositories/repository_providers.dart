import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/location.dart';
import '../models/plant.dart';
import '../models/watering_task.dart';
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