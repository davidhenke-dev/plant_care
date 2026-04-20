import 'package:hive_flutter/hive_flutter.dart';

part 'watering_task.g.dart';

@HiveType(typeId: 2)
class WateringTask extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String plantId; // Referenz auf Plant

  @HiveField(2)
  DateTime scheduledFor;

  @HiveField(3)
  bool isDone;

  @HiveField(4)
  DateTime? completedAt;

  WateringTask({
    required this.id,
    required this.plantId,
    required this.scheduledFor,
    this.isDone = false,
    this.completedAt,
  });
}