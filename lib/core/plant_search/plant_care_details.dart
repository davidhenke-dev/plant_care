class PlantCareDetails {
  final String commonName;
  final String? description;
  final List<String> sunlight;
  final String? careLevel;
  final List<String> pruningMonths;
  final String? watering;

  const PlantCareDetails({
    required this.commonName,
    this.description,
    required this.sunlight,
    this.careLevel,
    required this.pruningMonths,
    this.watering,
  });

  factory PlantCareDetails.fromJson(Map<String, dynamic> json) {
    return PlantCareDetails(
      commonName: json['common_name'] as String? ?? '',
      description: json['description'] as String?,
      sunlight: (json['sunlight'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      careLevel: json['care_level'] as String?,
      pruningMonths: (json['pruning_month'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      watering: json['watering'] as String?,
    );
  }
}
