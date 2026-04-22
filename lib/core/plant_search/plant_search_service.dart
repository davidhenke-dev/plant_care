import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import 'plant_care_details.dart';
import 'plant_search_result.dart';

class PlantSearchService {
  static const _base = 'https://perenual.com/api/species-list';
  static const _detailsBase = 'https://perenual.com/api/species/details';

  final http.Client _client;

  PlantSearchService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<PlantSearchResult>> search(String query) async {
    final uri = Uri.parse(_base).replace(queryParameters: {
      'key': AppConfig.perenualApiKey,
      'q': query,
      'page': '1',
    });

    final response = await _client.get(uri);

    if (response.statusCode != 200) {
      throw Exception('Perenual API Fehler: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>? ?? [];

    return data
        .map((e) => PlantSearchResult.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<PlantCareDetails?> getCareDetails(String plantName) async {
    if (AppConfig.perenualApiKey.isEmpty) return null;
    try {
      final results = await search(plantName);
      if (results.isEmpty) return null;

      final id = results.first.id;
      final uri = Uri.parse('$_detailsBase/$id').replace(
        queryParameters: {'key': AppConfig.perenualApiKey},
      );

      final response = await _client.get(uri);
      if (response.statusCode != 200) return null;

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return PlantCareDetails.fromJson(json);
    } catch (_) {
      return null;
    }
  }
}
