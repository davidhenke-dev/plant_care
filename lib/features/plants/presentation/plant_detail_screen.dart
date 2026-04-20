import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../../data/models/location.dart';
import '../../../data/repositories/repository_providers.dart';
import '../application/plant_notifier.dart';

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
                children: const {
                  0: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Info'),
                  ),
                  1: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Standort'),
                  ),
                  2: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text('Fotos'),
                  ),
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: switch (_selectedTab) {
                0 => _InfoTab(plant: plant),
                1 => _StandortTab(locationId: plant.locationId),
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
    final dateFormat = DateFormat('dd.MM.yyyy');
    final nextWatering = plant.lastWateredAt
        ?.add(Duration(days: plant.wateringIntervalDays as int));

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
      children: [
        if (plant.imagePath != null) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.file(
              File(plant.imagePath as String),
              height: 220,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 20),
        ],
        _infoCard([
          _InfoRow(
            label: 'Gießintervall',
            value: 'Alle ${plant.wateringIntervalDays} Tage',
          ),
          _InfoRow(
            label: 'Zuletzt gegossen',
            value: plant.lastWateredAt != null
                ? dateFormat.format(plant.lastWateredAt as DateTime)
                : 'Noch nie',
          ),
          if (nextWatering != null)
            _InfoRow(
              label: 'Nächste Bewässerung',
              value: dateFormat.format(nextWatering as DateTime),
            ),
          if ((plant.notes as String?)?.isNotEmpty == true)
            _InfoRow(label: 'Notizen', value: plant.notes as String),
        ]),
        if (plant.needsWateringToday as bool) ...[
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton.filled(
              onPressed: () => ref
                  .read(plantNotifierProvider.notifier)
                  .markAsWatered(plant.id as String),
              child: const Text('Als gegossen markieren 💧'),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Standort Tab ──────────────────────────────────────────────────────────────

class _StandortTab extends ConsumerWidget {
  final String locationId;

  const _StandortTab({required this.locationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Location?>(
      future: ref.read(locationRepositoryProvider).getById(locationId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CupertinoActivityIndicator());
        }
        final loc = snapshot.data;
        if (loc == null) {
          return const Center(child: Text('Standort nicht gefunden'));
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
          children: [
            _infoCard([
              _InfoRow(label: 'Name', value: loc.name),
              _InfoRow(label: 'Licht', value: _lightLabel(loc.light)),
              _InfoRow(
                  label: 'Feuchtigkeit', value: _humidityLabel(loc.humidity)),
              _InfoRow(
                  label: 'Zugluft', value: loc.isDrafty ? 'Ja' : 'Nein'),
              _InfoRow(
                  label: 'Geheizt im Winter',
                  value: loc.isHeatedInWinter ? 'Ja' : 'Nein'),
            ]),
          ],
        );
      },
    );
  }

  String _lightLabel(LightLevel l) => switch (l) {
        LightLevel.fullSun => '☀️ Sonnig',
        LightLevel.partialSun => '⛅ Halbschattig',
        LightLevel.shade => '🌥 Schattig',
      };

  String _humidityLabel(HumidityLevel h) => switch (h) {
        HumidityLevel.dry => '🏜 Trocken',
        HumidityLevel.moderate => '🌤 Moderat',
        HumidityLevel.humid => '💧 Feucht',
      };
}

// ── Fotos Tab ─────────────────────────────────────────────────────────────────

class _FotosTab extends ConsumerWidget {
  final String plantId;

  const _FotosTab({required this.plantId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                  ? Image.file(
                      File(plant!.imagePath!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.camera,
                              size: 48, color: CupertinoColors.systemGrey),
                          SizedBox(height: 12),
                          Text(
                            'Kein Foto vorhanden',
                            style:
                                TextStyle(color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CupertinoButton(
              color: CupertinoColors.systemGrey6,
              onPressed: () async {
                final picker = ImagePicker();
                final picked = await picker.pickImage(
                  source: ImageSource.gallery,
                  maxWidth: 1024,
                  imageQuality: 85,
                );
                if (picked != null) {
                  await ref
                      .read(plantNotifierProvider.notifier)
                      .updateImagePath(plantId, picked.path);
                }
              },
              child: const Text(
                'Foto ändern',
                style: TextStyle(color: CupertinoColors.label),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Shared Helpers ────────────────────────────────────────────────────────────

Widget _infoCard(List<Widget> rows) {
  return Container(
    decoration: BoxDecoration(
      color: CupertinoColors.systemBackground,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: CupertinoColors.systemGrey.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: rows
          .map((r) => r)
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
          Text(
            label,
            style: const TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
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
      color: CupertinoColors.separator,
    );
  }
}
