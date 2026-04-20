import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:plant_care/data/models/location.dart';
import 'package:plant_care/data/models/plant.dart';
import 'package:plant_care/data/repositories/location_repository.dart';
import 'package:plant_care/data/repositories/plant_repository.dart';
import 'package:plant_care/data/repositories/repository_providers.dart';
import 'package:plant_care/features/plants/application/plant_notifier.dart';
import 'package:plant_care/features/plants/presentation/plant_detail_screen.dart';

void main() {
  late Box<Plant> plantBox;
  late Box<Location> locationBox;
  late Plant testPlant;
  late Location testLocation;

  setUpAll(() async {
    Hive.init('.');
    Hive.registerAdapter(PlantAdapter());
    Hive.registerAdapter(LocationAdapter());
  });

  setUp(() async {
    plantBox = await Hive.openBox<Plant>('detail_test_plants');
    locationBox = await Hive.openBox<Location>('detail_test_locations');

    testLocation = Location(
      id: 'loc1',
      name: 'Wohnzimmer',
      lightLevel: LightLevel.fullSun.index,
      humidityLevel: HumidityLevel.moderate.index,
      createdAt: DateTime.now(),
    );
    await locationBox.put(testLocation.id, testLocation);

    testPlant = Plant(
      id: 'p1',
      name: 'Monstera',
      locationId: 'loc1',
      wateringIntervalDays: 7,
      createdAt: DateTime.now(),
      lastWateredAt: DateTime.now().subtract(const Duration(days: 8)),
    );
    await plantBox.put(testPlant.id, testPlant);
  });

  tearDown(() async {
    await plantBox.clear();
    await locationBox.clear();
  });

  tearDownAll(() async {
    await Hive.close();
  });

  ProviderContainer buildContainer() => ProviderContainer(
        overrides: [
          plantRepositoryProvider
              .overrideWithValue(PlantRepository(plantBox)),
          locationRepositoryProvider
              .overrideWithValue(LocationRepository(locationBox)),
        ],
      );

  testWidgets('Info-Tab zeigt Pflanzenname und Gießintervall',
      (tester) async {
    final container = buildContainer();
    await container.read(plantNotifierProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: CupertinoApp(
          home: PlantDetailScreen(plantId: testPlant.id),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Monstera'), findsOneWidget);
    expect(find.text('Alle 7 Tage'), findsOneWidget);
  });

  testWidgets('Segmented Control wechselt zu Standort-Tab', (tester) async {
    final container = buildContainer();
    await container.read(plantNotifierProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: CupertinoApp(
          home: PlantDetailScreen(plantId: testPlant.id),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Standort'));
    await tester.pumpAndSettle();

    expect(find.text('Wohnzimmer'), findsOneWidget);
  });

  testWidgets('Segmented Control wechselt zu Fotos-Tab', (tester) async {
    final container = buildContainer();
    await container.read(plantNotifierProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: CupertinoApp(
          home: PlantDetailScreen(plantId: testPlant.id),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Fotos'));
    await tester.pump();

    expect(find.text('Kein Foto vorhanden'), findsOneWidget);
  });

  testWidgets('Gegossen-Button sichtbar wenn Pflanze Wasser braucht',
      (tester) async {
    final container = buildContainer();
    await container.read(plantNotifierProvider.future);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: CupertinoApp(
          home: PlantDetailScreen(plantId: testPlant.id),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Als gegossen markieren 💧'), findsOneWidget);
  });
}
