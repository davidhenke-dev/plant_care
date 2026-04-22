import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/plant_search/plant_search_result.dart';
import '../../../core/plant_search/plant_search_service.dart';

class PlantSearchNotifier
    extends StateNotifier<AsyncValue<List<PlantSearchResult>>> {
  PlantSearchNotifier(this._service) : super(const AsyncData([]));

  final PlantSearchService _service;
  Timer? _debounce;

  void search(String query) {
    _debounce?.cancel();
    if (query.trim().isEmpty) {
      state = const AsyncData([]);
      return;
    }
    state = const AsyncLoading();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      state = await AsyncValue.guard(() => _service.search(query.trim()));
    });
  }

  void clear() {
    _debounce?.cancel();
    state = const AsyncData([]);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final plantSearchProvider = StateNotifierProvider.autoDispose<PlantSearchNotifier,
    AsyncValue<List<PlantSearchResult>>>(
  (ref) => PlantSearchNotifier(PlantSearchService()),
);
