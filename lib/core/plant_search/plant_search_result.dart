class PlantSearchResult {
  final int id;
  final String commonName;
  final List<String> scientificNames;
  final String watering; // "Frequent" | "Average" | "Minimum" | "None"
  final String? maintenance; // "Low" | "Moderate" | "High"
  final String? thumbnailUrl;

  const PlantSearchResult({
    required this.id,
    required this.commonName,
    required this.scientificNames,
    required this.watering,
    this.maintenance,
    this.thumbnailUrl,
  });

  /// Gießintervall in Tagen basierend auf dem Perenual watering-Wert.
  int get wateringIntervalDays => switch (watering.toLowerCase()) {
        'frequent' => 2,
        'average' => 7,
        'minimum' => 14,
        _ => 21,
      };

  /// Düngeintervall in Wochen basierend auf maintenance-Level.
  /// Gibt null zurück wenn kein maintenance-Wert vorhanden.
  int? get fertilizingIntervalWeeks =>
      switch (maintenance?.toLowerCase()) {
        'low' => 6,
        'moderate' || 'medium' => 4,
        'high' => 2,
        _ => null,
      };

  String get scientificName =>
      scientificNames.isNotEmpty ? scientificNames.first : '';

  factory PlantSearchResult.fromJson(Map<String, dynamic> json) {
    // default_image kann null, Map oder anderer Typ sein (free-plan Eigenheit)
    final raw = json['default_image'];
    final image = raw is Map<String, dynamic> ? raw : null;
    final thumbnailUrl = (image?['thumbnail'] as String?)
        ?? (image?['small_url'] as String?)
        ?? (image?['medium_url'] as String?);

    return PlantSearchResult(
      id: json['id'] as int,
      commonName: json['common_name'] as String? ?? 'Unbekannt',
      scientificNames: (json['scientific_name'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      watering: json['watering'] as String? ?? 'Average',
      maintenance: json['maintenance'] as String?,
      thumbnailUrl: thumbnailUrl,
    );
  }
}
