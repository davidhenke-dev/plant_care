import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:plant_care/core/plant_search/plant_search_result.dart';
import 'package:plant_care/core/plant_search/plant_search_service.dart';
import 'package:plant_care/features/plants/application/plant_search_notifier.dart';

class _MockClient extends Mock implements http.Client {}

void main() {
  setUpAll(() {
    registerFallbackValue(Uri());
  });

  group('PlantSearchResult', () {
    test('fromJson parst alle Felder korrekt', () {
      final json = {
        'id': 1,
        'common_name': 'Monstera',
        'scientific_name': ['Monstera deliciosa'],
        'watering': 'Average',
        'default_image': {'thumbnail': 'https://example.com/img.jpg'},
      };
      final result = PlantSearchResult.fromJson(json);
      expect(result.commonName, 'Monstera');
      expect(result.scientificName, 'Monstera deliciosa');
      expect(result.wateringIntervalDays, 7);
      expect(result.thumbnailUrl, 'https://example.com/img.jpg');
    });

    test('wateringIntervalDays: Frequent=2, Average=7, Minimum=14, None=21', () {
      int days(String w) =>
          PlantSearchResult.fromJson({'id': 1, 'common_name': 'x', 'scientific_name': [], 'watering': w})
              .wateringIntervalDays;
      expect(days('Frequent'), 2);
      expect(days('Average'), 7);
      expect(days('Minimum'), 14);
      expect(days('None'), 21);
    });
  });

  group('PlantSearchService', () {
    late _MockClient client;
    late PlantSearchService service;

    setUp(() {
      client = _MockClient();
      service = PlantSearchService(client: client);
    });

    test('gibt Ergebnisliste zurück bei 200', () async {
      final body = jsonEncode({
        'data': [
          {
            'id': 1,
            'common_name': 'Monstera',
            'scientific_name': ['Monstera deliciosa'],
            'watering': 'Average',
            'default_image': null,
          }
        ]
      });
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response(body, 200),
      );
      final results = await service.search('monstera');
      expect(results.length, 1);
      expect(results.first.commonName, 'Monstera');
    });

    test('wirft Exception bei Fehler-Statuscode', () async {
      when(() => client.get(any())).thenAnswer(
        (_) async => http.Response('error', 401),
      );
      expect(() => service.search('x'), throwsException);
    });
  });

  group('PlantSearchNotifier', () {
    test('leere Query → leere Liste, kein Loading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(plantSearchProvider.notifier).search('');
      expect(container.read(plantSearchProvider), const AsyncData(<PlantSearchResult>[]));
    });

    test('nicht-leere Query → AsyncLoading', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.read(plantSearchProvider.notifier).search('Monstera');
      expect(container.read(plantSearchProvider), isA<AsyncLoading>());
    });
  });
}
