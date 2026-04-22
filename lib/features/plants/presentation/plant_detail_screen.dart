import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/plant_search/plant_care_details.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/location.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/plant_image.dart';
import '../application/plant_notifier.dart';
import 'edit_plant_sheet.dart';

class PlantDetailScreen extends ConsumerStatefulWidget {
  final String plantId;

  const PlantDetailScreen({super.key, required this.plantId});

  @override
  ConsumerState<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends ConsumerState<PlantDetailScreen> {
  int _selectedTab = 0;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final plant = ref
        .watch(plantNotifierProvider)
        .valueOrNull
        ?.where((p) => p.id == widget.plantId)
        .firstOrNull;

    if (plant == null) {
      return const CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(),
        child: Center(child: CupertinoActivityIndicator()),
      );
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(plant.name),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => EditPlantSheet(plant: plant)),
          ),
          child: const Icon(CupertinoIcons.pencil, size: 22),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: _selectedTab,
                onValueChanged: (val) {
                  if (val != null) setState(() => _selectedTab = val);
                },
                children: {
                  0: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(l.plantDetailInfoTab),
                  ),
                  1: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(l.plantDetailLocationTab),
                  ),
                  2: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(l.plantDetailCareTab),
                  ),
                  3: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(l.plantDetailPhotosTab),
                  ),
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (_selectedTab) {
                0 => _InfoTab(plant: plant),
                1 => _StandortTab(locationId: plant.locationId),
                2 => _CareTab(plantName: plant.name),
                _ => _FotosTab(plantId: plant.id),
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── Info Tab ──────────────────────────────────────────────────────────────────

class _InfoTab extends ConsumerWidget {
  final dynamic plant;

  const _InfoTab({required this.plant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateFormat = DateFormat('dd.MM.yyyy', locale);
    final nextWatering = plant.lastWateredAt
        ?.add(Duration(days: plant.wateringIntervalDays as int));
    final fertilizingWeeks = plant.fertilizingIntervalWeeks as int?;
    final nextFertilizing = plant.lastFertilizedAt
        ?.add(Duration(days: (fertilizingWeeks ?? 0) * 7));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      children: [
        if (plant.imagePath != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: PlantImage(
              imagePath: plant.imagePath as String?,
              height: 220,
              width: double.infinity,
            ),
          ),
          const SizedBox(height: 20),
        ],
        _infoCard(context, [
          _InfoRow(
            label: l.plantDetailWateringInterval,
            value: l.plantDetailEveryNDays(plant.wateringIntervalDays as int),
          ),
          _InfoRow(
            label: l.plantDetailLastWatered,
            value: plant.lastWateredAt != null
                ? dateFormat.format(plant.lastWateredAt as DateTime)
                : l.plantDetailNeverWatered,
          ),
          if (nextWatering != null)
            _InfoRow(
              label: l.plantDetailNextWatering,
              value: dateFormat.format(nextWatering as DateTime),
            ),
          if ((plant.notes as String?)?.isNotEmpty == true)
            _InfoRow(label: l.plantDetailNotes, value: plant.notes as String),
        ]),
        if (fertilizingWeeks != null) ...[
          const SizedBox(height: 16),
          _infoCard(context, [
            _InfoRow(
              label: l.plantDetailFertilizingInterval,
              value: l.plantDetailEveryNWeeks(fertilizingWeeks),
            ),
            _InfoRow(
              label: l.plantDetailLastFertilized,
              value: plant.lastFertilizedAt != null
                  ? dateFormat.format(plant.lastFertilizedAt as DateTime)
                  : l.plantDetailNeverWatered,
            ),
            if (nextFertilizing != null)
              _InfoRow(
                label: l.plantDetailNextFertilizing,
                value: dateFormat.format(nextFertilizing),
              ),
          ]),
        ],
        if (plant.needsWateringToday as bool) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () => ref
                  .read(plantNotifierProvider.notifier)
                  .markAsWatered(plant.id as String),
              child: Text(l.plantDetailMarkWatered),
            ),
          ),
        ],
        if (plant.needsFertilizingToday as bool) ...[
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: CupertinoColors.systemOrange.withValues(alpha: 0.15),
              onPressed: () => ref
                  .read(plantNotifierProvider.notifier)
                  .markAsFertilized(plant.id as String),
              child: Text(
                l.plantDetailMarkFertilized,
                style: const TextStyle(color: CupertinoColors.systemOrange),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Standort Tab ──────────────────────────────────────────────────────────────

class _StandortTab extends ConsumerWidget {
  final String? locationId;

  const _StandortTab({required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);

    if (locationId == null) {
      return Center(child: Text(l.noLocation));
    }

    return FutureBuilder<Location?>(
      future: ref.read(locationRepositoryProvider).getById(locationId!),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final loc = snapshot.data;
        if (loc == null) {
          return Center(child: Text(l.plantDetailLocationNotFound));
        }

        final lightLabel = switch (loc.light) {
          LightLevel.fullSun => l.locationLightFull,
          LightLevel.partialSun => l.locationLightPartial,
          LightLevel.shade => l.locationLightShade,
        };
        final humidityLabel = switch (loc.humidity) {
          HumidityLevel.dry => l.locationHumidityDry,
          HumidityLevel.moderate => l.locationHumidityModerate,
          HumidityLevel.humid => l.locationHumidityHumid,
        };

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          children: [
            _infoCard(context, [
              _InfoRow(label: l.locationFieldName, value: loc.name),
              _InfoRow(label: l.locationFieldLight, value: lightLabel),
              _InfoRow(label: l.locationFieldHumidity, value: humidityLabel),
              _InfoRow(
                  label: l.locationFieldDraft,
                  value: loc.isDrafty ? l.yes : l.no),
              _InfoRow(
                  label: l.locationFieldHeated,
                  value: loc.isHeatedInWinter ? l.yes : l.no),
            ]),
          ],
        );
      },
    );
  }
}

// ── Care Tips Tab ─────────────────────────────────────────────────────────────

class _CareTab extends ConsumerWidget {
  final String plantName;

  const _CareTab({required this.plantName});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    return FutureBuilder<PlantCareDetails?>(
      future: ref
          .read(plantSearchServiceProvider)
          .getCareDetails(plantName),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CupertinoActivityIndicator(),
                const SizedBox(height: 12),
                Text(l.plantDetailCareLoading,
                    style: const TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
          );
        }

        final details = snapshot.data;
        if (details == null) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(CupertinoIcons.info_circle,
                    size: 44, color: CupertinoColors.systemGrey3),
                const SizedBox(height: 12),
                Text(l.plantDetailCareError,
                    style: const TextStyle(color: CupertinoColors.systemGrey)),
              ],
            ),
          );
        }

        final rows = <Widget>[];

        if (details.description != null && details.description!.isNotEmpty) {
          rows.add(_InfoRow(
            label: l.plantDetailCareDescription,
            value: details.description!,
          ));
        }
        if (details.sunlight.isNotEmpty) {
          rows.add(_InfoRow(
            label: l.plantDetailCareSunlight,
            value: details.sunlight.join(', '),
          ));
        }
        if (details.careLevel != null) {
          rows.add(_InfoRow(
            label: l.plantDetailCareMaintenance,
            value: details.careLevel!,
          ));
        }
        if (details.pruningMonths.isNotEmpty) {
          rows.add(_InfoRow(
            label: l.plantDetailCarePruning,
            value: details.pruningMonths.join(', '),
          ));
        }

        if (rows.isEmpty) {
          return Center(
            child: Text(l.plantDetailCareError,
                style: const TextStyle(color: CupertinoColors.systemGrey)),
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          children: [_infoCard(context, rows)],
        );
      },
    );
  }
}

// ── Fotos Tab ─────────────────────────────────────────────────────────────────

class _FotosTab extends ConsumerWidget {
  final String plantId;

  const _FotosTab({required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final plant = ref
        .watch(plantNotifierProvider)
        .valueOrNull
        ?.where((p) => p.id == plantId)
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: plant?.imagePath != null
                  ? PlantImage(
                      imagePath: plant!.imagePath,
                      width: double.infinity,
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kCardBackground.resolveFrom(context),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(CupertinoIcons.camera,
                              size: 48, color: CupertinoColors.systemGrey),
                          const SizedBox(height: 12),
                          Text(l.plantDetailNoPhoto,
                              style: const TextStyle(
                                  color: CupertinoColors.systemGrey)),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: kCardBackground.resolveFrom(context),
              onPressed: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1024,
                  imageQuality: 85,
                );
                if (picked != null) {
                  final savedPath = await _copyToDocuments(picked.path);
                  await ref
                      .read(plantNotifierProvider.notifier)
                      .updateImagePath(plantId, savedPath);
                }
              },
              child: Text(
                l.plantDetailChangePhoto,
                style: const TextStyle(color: CupertinoColors.label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> _copyToDocuments(String sourcePath) async {
  try {
    final dir = await getApplicationDocumentsDirectory();
    final filename = 'plant_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final dest = File('${dir.path}/$filename');
    await File(sourcePath).copy(dest.path);
    return dest.path;
  } catch (_) {
    return sourcePath;
  }
}

// ── Shared Helpers ────────────────────────────────────────────────────────────

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
