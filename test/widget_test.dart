import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:plant_care/data/models/location.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/models/watering_task.dart';
import 'package:plant_care/data/repositories/location_repository.dart';
import 'package:plant_care/data/repositories/plant_repository.dart';
import 'package:plant_care/data/repositories/repository_providers.dart';
import 'package:plant_care/data/repositories/watering_task_repository.dart';
import 'package:plant_care/core/weather/weather_data.dart';
import 'package:plant_care/features/home/application/weather_notifier.dart';
import 'package:plant_care/features/home/presentation/home_screen.dart';
import 'package:plant_care/features/locations/presentation/locations_screen.dart';
import 'package:plant_care/features/plants/presentation/plants_screen.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('de', null);
    Hive.init('.');
    Hive.registerAdapter(LocationAdapter());
    Hive.registerAdapter(PlantAdapter());
    Hive.registerAdapter(WateringTaskAdapter());
  });

  setUp(() async {
    await Hive.openBox<Location>('widget_test_locations');
    await Hive.openBox<Plant>('widget_test_plants');
    await Hive.openBox<WateringTask>('widget_test_tasks');
    await Hive.openBox('widget_test_settings');
  });

  tearDown(() async {
    await Hive.box<Location>('widget_test_locations').clear();
    await Hive.box<Plant>('widget_test_plants').clear();
    await Hive.box<WateringTask>('widget_test_tasks').clear();
    await Hive.box('widget_test_settings').clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  ProviderContainer buildContainer() => ProviderContainer(
        overrides: [
          locationRepositoryProvider.overrideWithValue(
            LocationRepository(Hive.box<Location>('widget_test_locations')),
          ),
          plantRepositoryProvider.overrideWithValue(
            PlantRepository(Hive.box<Plant>('widget_test_plants')),
          ),
          wateringTaskRepositoryProvider.overrideWithValue(
            WateringTaskRepository(
              Hive.box<WateringTask>('widget_test_tasks'),
            ),
          ),
          settingsBoxProvider
              .overrideWithValue(Hive.box('widget_test_settings')),
          weatherProvider.overrideWith(() => _FakeWeatherNotifier()),
        ],
      );

  testWidgets('HomeScreen rendert korrekt', (WidgetTester tester) async {
    final container = buildContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CupertinoApp(
          home: HomeScreen(),
        ),
      ),
    );
    await tester.pump();
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('PlantsScreen rendert korrekt', (WidgetTester tester) async {
    final container = buildContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CupertinoApp(home: PlantsScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Pflanzen'), findsOneWidget);
  });

  testWidgets('LocationsScreen rendert korrekt', (WidgetTester tester) async {
    final container = buildContainer();
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const CupertinoApp(home: LocationsScreen()),
      ),
    );
    await tester.pump();
    expect(find.text('Standorte'), findsOneWidget);
  });
}

class _FakeWeatherNotifier extends WeatherNotifier {
  @override
  Future<WeatherData> build() async => const WeatherData(
        currentTemp: 18,
        weatherCode: 0,
        isDay: true,
        forecastTemp: 12,
        forecastCode: 1,
      );
}