import 'package:hive_flutter/hive_flutter.dart';

part 'location.g.dart';

enum LightLevel {
  fullSun,       // Volle Sonne
  partialSun,    // Halbschattig
  shade,         // Schattig
}

enum HumidityLevel {
  dry,           // Trocken
  moderate,      // Moderat
  humid,         // Feucht
}

@HiveType(typeId: 0)
class Location extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  int lightLevel; // Index von LightLevel enum

  @HiveField(3)
  int humidityLevel; // Index von HumidityLevel enum

  @HiveField(4)
  bool isDrafty; // Zugluft

  @HiveField(5)
  bool isHeatedInWinter; // Geheizt im Winter

  @HiveField(6)
  DateTime createdAt;

  Location({
    required this.id,
    required this.name,
    required this.lightLevel,
    required this.humidityLevel,
    this.isDrafty = false,
    this.isHeatedInWinter = true,
    required this.createdAt,
  });

  LightLevel get light => LightLevel.values[lightLevel];
  HumidityLevel get humidity => HumidityLevel.values[humidityLevel];
}