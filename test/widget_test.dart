import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plant_care/features/home/presentation/home_screen.dart';
import 'package:plant_care/features/locations/presentation/locations_screen.dart';
import 'package:plant_care/features/plants/presentation/plants_screen.dart';

void main() {
  testWidgets('HomeScreen rendert korrekt', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CupertinoApp(home: HomeScreen()),
      ),
    );
    expect(find.text('Heute'), findsOneWidget);
  });

  testWidgets('PlantsScreen rendert korrekt', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CupertinoApp(home: PlantsScreen()),
      ),
    );
    expect(find.text('Pflanzen'), findsOneWidget);
  });

  testWidgets('LocationsScreen rendert korrekt', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: CupertinoApp(home: LocationsScreen()),
      ),
    );
    expect(find.text('Standorte'), findsOneWidget);
  });
}