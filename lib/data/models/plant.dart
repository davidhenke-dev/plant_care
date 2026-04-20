import 'package:hive_flutter/hive_flutter.dart';

part 'plant.g.dart';

@HiveType(typeId: 1)
class Plant extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String locationId; // Referenz auf Location

  @HiveField(3)
  int wateringIntervalDays; // Alle X Tage gießen

  @HiveField(4)
  String? imagePath; // Lokaler Pfad zum Foto

  @HiveField(5)
  String? notes;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  DateTime? lastWateredAt;

  Plant({
    required this.id,
    required this.name,
    required this.locationId,
    required this.wateringIntervalDays,
    this.imagePath,
    this.notes,
    required this.createdAt,
    this.lastWateredAt,
  });

  bool get needsWateringToday {
    if (lastWateredAt == null) return true;
    final nextWatering = lastWateredAt!.add(
      Duration(days: wateringIntervalDays),
    );
    return DateTime.now().isAfter(nextWatering);
  }
}