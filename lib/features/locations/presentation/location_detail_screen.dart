import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/location.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/plant_image.dart';
import '../../plants/application/plant_notifier.dart';
import '../application/location_notifier.dart';
import 'edit_location_sheet.dart';

class LocationDetailScreen extends ConsumerWidget {
  final String locationId;

  const LocationDetailScreen({super.key, required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final location = ref
        .watch(locationNotifierProvider)
        .valueOrNull
        ?.where((loc) => loc.id == locationId)
        .firstOrNull;

    if (location == null) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    final allPlants = ref.watch(plantNotifierProvider).valueOrNull ?? [];
    final plantsHere =
        allPlants.where((p) => p.locationId == locationId).toList();

    final lightLabel = switch (location.light) {
      LightLevel.fullSun => l.locationLightFull,
      LightLevel.partialSun => l.locationLightPartial,
      LightLevel.shade => l.locationLightShade,
    };
    final humidityLabel = switch (location.humidity) {
      HumidityLevel.dry => l.locationHumidityDry,
      HumidityLevel.moderate => l.locationHumidityModerate,
      HumidityLevel.humid => l.locationHumidityHumid,
    };

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(location.name),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(
              builder: (_) => EditLocationSheet(location: location),
            ),
          ),
          child: const Icon(CupertinoIcons.pencil, size: 22),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
          children: [
            // ── Location info card ───────────────────────────────────────────
            _infoCard(context, [
              _InfoRow(label: l.locationFieldName, value: location.name),
              _InfoRow(label: l.locationFieldLight, value: lightLabel),
              _InfoRow(label: l.locationFieldHumidity, value: humidityLabel),
              _InfoRow(
                  label: l.locationFieldDraft,
                  value: location.isDrafty ? l.yes : l.no),
              _InfoRow(
                  label: l.locationFieldHeated,
                  value: location.isHeatedInWinter ? l.yes : l.no),
            ]),

            // ── Recommendations ──────────────────────────────────────────────
            const SizedBox(height: 24),
            _RecommendationsCard(location: location),

            // ── Plants section ───────────────────────────────────────────────
            const SizedBox(height: 28),
            Text(
              l.locationDetailPlantsTitle,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            if (plantsHere.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kCardBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: CupertinoColors.systemGrey4.resolveFrom(context)),
                ),
                child: Row(
                  children: [
                    const Icon(CupertinoIcons.leaf_arrow_circlepath,
                        size: 20, color: CupertinoColors.systemGrey),
                    const SizedBox(width: 10),
                    Text(l.locationDetailNoPlantsHint,
                        style: const TextStyle(
                            color: CupertinoColors.systemGrey, fontSize: 14)),
                  ],
                ),
              )
            else
              ...plantsHere.map((plant) => _PlantRow(
                    plant: plant,
                    currentLocationId: locationId,
                  )),
          ],
        ),
      ),
    );
  }
}

// ── Location plant recommendations ────────────────────────────────────────────

class _RecommendationsCard extends StatelessWidget {
  final Location location;

  const _RecommendationsCard({required this.location});

  List<String> _getSuggestions() {
    final light = location.light;
    final humidity = location.humidity;

    if (light == LightLevel.fullSun && humidity == HumidityLevel.dry) {
      return ['Kakteen & Sukkulenten', 'Lavendel', 'Rosmarin', 'Salbei'];
    }
    if (light == LightLevel.fullSun && humidity == HumidityLevel.moderate) {
      return ['Tomaten', 'Rosen', 'Pelargonien', 'Basilikum'];
    }
    if (light == LightLevel.fullSun && humidity == HumidityLevel.humid) {
      return ['Hibiskus', 'Strelitzie', 'Bougainvillea'];
    }
    if (light == LightLevel.partialSun && humidity == HumidityLevel.dry) {
      return ['Aloe Vera', 'Sansevieria', 'Geranien'];
    }
    if (light == LightLevel.partialSun && humidity == HumidityLevel.moderate) {
      return ['Monstera', 'Pothos', 'Einblatt', 'Drachenbäume'];
    }
    if (light == LightLevel.partialSun && humidity == HumidityLevel.humid) {
      return ['Orchideen', 'Bromelien', 'Anthurien'];
    }
    if (light == LightLevel.shade && humidity == HumidityLevel.dry) {
      return ['Schusterpalme', 'Sansevieria', 'Zamioculcas'];
    }
    if (light == LightLevel.shade && humidity == HumidityLevel.moderate) {
      return ['Farne', 'Calathea', 'Efeu'];
    }
    return ['Fittonia', 'Maidenhaar-Farn', 'Selaginella'];
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final suggestions = _getSuggestions();

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF4CAF50).withValues(alpha: 0.2),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                CupertinoIcons.sparkles,
                size: 18,
                color: Color(0xFF4CAF50),
              ),
              const SizedBox(width: 8),
              Text(
                l.locationRecommendationsTitle,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4CAF50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l.locationRecommendationsSubtitle,
            style: const TextStyle(
              fontSize: 13,
              color: CupertinoColors.systemGrey,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        s,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF4CAF50),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }
}

// ── Plant row with reassign button ────────────────────────────────────────────

class _PlantRow extends ConsumerWidget {
  final Plant plant;
  final String currentLocationId;

  const _PlantRow({
    required this.plant,
    required this.currentLocationId,
  });

  Future<void> _showReassignSheet(BuildContext context, WidgetRef ref) async {
    final l = AppLocalizations.of(context);
    final allLocations =
        await ref.read(locationRepositoryProvider).getAll();
    final otherLocations =
        allLocations.where((loc) => loc.id != currentLocationId).toList();

    if (!context.mounted) return;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => _ReassignSheet(
        plant: plant,
        locations: otherLocations,
        l: l,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: kCardBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey
                .resolveFrom(context)
                .withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child:
                  PlantImage(imagePath: plant.imagePath, width: 48, height: 48),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(CupertinoIcons.drop_fill,
                          size: 11,
                          color: plant.needsWateringToday
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemGrey3),
                      const SizedBox(width: 4),
                      Text(
                        plant.needsWateringToday
                            ? l.plantsNeedsWateringToday
                            : l.plantsWateringInterval(
                                plant.wateringIntervalDays),
                        style: TextStyle(
                          fontSize: 12,
                          color: plant.needsWateringToday
                              ? CupertinoColors.systemBlue
                              : CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              onPressed: () => _showReassignSheet(context, ref),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(CupertinoIcons.arrow_right_arrow_left,
                      size: 14, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 4),
                  Text(
                    l.locationDetailReassignButton,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4CAF50),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reassign bottom sheet ─────────────────────────────────────────────────────

class _ReassignSheet extends ConsumerWidget {
  final Plant plant;
  final List<Location> locations;
  final AppLocalizations l;

  const _ReassignSheet({
    required this.plant,
    required this.locations,
    required this.l,
  });

  Future<void> _reassign(
      BuildContext context, WidgetRef ref, String? newLocationId) async {
    await ref.read(plantNotifierProvider.notifier).updatePlant(
          id: plant.id,
          name: plant.name,
          locationId: newLocationId,
          wateringIntervalDays: plant.wateringIntervalDays,
          notes: plant.notes,
          fertilizingIntervalWeeks: plant.fertilizingIntervalWeeks,
        );
    if (context.mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground.resolveFrom(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey4.resolveFrom(context),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l.locationDetailReassignTitle,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            plant.name,
            style: const TextStyle(
                fontSize: 14, color: CupertinoColors.systemGrey),
          ),
          const SizedBox(height: 16),
          // "No location" option
          _sheetItem(
            context: context,
            icon: CupertinoIcons.xmark_circle,
            label: l.noLocation,
            isCurrentLocation: plant.locationId == null,
            onTap: () => _reassign(context, ref, null),
          ),
          const SizedBox(height: 8),
          ...locations.map(
            (loc) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _sheetItem(
                context: context,
                icon: CupertinoIcons.map_pin_ellipse,
                label: loc.name,
                isCurrentLocation: false,
                onTap: () => _reassign(context, ref, loc.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _sheetItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required bool isCurrentLocation,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: isCurrentLocation ? null : onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isCurrentLocation
            ? CupertinoColors.systemGrey5.resolveFrom(context)
            : kCardBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CupertinoColors.systemGrey4.resolveFrom(context),
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 20,
              color: isCurrentLocation
                  ? CupertinoColors.systemGrey3
                  : CupertinoColors.systemGrey),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isCurrentLocation
                    ? CupertinoColors.systemGrey3.resolveFrom(context)
                    : CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
          if (isCurrentLocation)
            Text(
              '✓',
              style: TextStyle(
                color: CupertinoColors.systemGrey3.resolveFrom(context),
                fontSize: 16,
              ),
            ),
        ],
      ),
    ),
  );
}

// ── Info card + helpers ───────────────────────────────────────────────────────

Widget _infoCard(BuildContext context, List<Widget> rows) {
  return Container(
    decoration: BoxDecoration(
      color: kCardBackground.resolveFrom(context),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.systemGrey
              .resolveFrom(context)
              .withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: rows
          .expand((r) => [r, const _Divider()])
          .toList()
        ..removeLast(),
    ),
  );
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Text(label,
              style: const TextStyle(
                  color: CupertinoColors.systemGrey, fontSize: 14)),
          const Spacer(),
          Text(value,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5,
      margin: const EdgeInsets.only(left: 16),
      color: CupertinoColors.separator.resolveFrom(context),
    );
  }
}
