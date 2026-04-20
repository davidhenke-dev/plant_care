import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';
import '../application/plant_notifier.dart';
import 'add_plant_sheet.dart';
import 'plant_card.dart';
import 'plant_detail_screen.dart';

class PlantsScreen extends ConsumerWidget {
  const PlantsScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Pflanze löschen'),
        content: Text('Möchtest du "$name" wirklich löschen?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(plantNotifierProvider.notifier).deletePlant(id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsync = ref.watch(plantNotifierProvider);
    final locationRepo = ref.read(locationRepositoryProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Pflanzen'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => showCupertinoModalPopup(
            context: context,
            builder: (_) => AddPlantSheet(),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: plantsAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          data: (plants) => plants.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.leaf_arrow_circlepath,
                        size: 48,
                        color: CupertinoColors.systemGrey3,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Noch keine Pflanzen',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tippe auf + um eine anzulegen',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey3,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : FutureBuilder(
                  future: locationRepo.getAll(),
                  builder: (context, snapshot) {
                    final locationMap = {
                      for (final l in snapshot.data ?? []) l.id: l.name
                    };
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return PlantCard(
                          plant: plant,
                          locationName:
                              locationMap[plant.locationId] ?? 'Unbekannt',
                          onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plantId: plant.id),
                            ),
                          ),
                          onDelete: () => _confirmDelete(
                            context,
                            ref,
                            plant.id,
                            plant.name,
                          ),
                          onWatered: () => ref
                              .read(plantNotifierProvider.notifier)
                              .markAsWatered(plant.id),
                        );
                      },
                    );
                  },
                ),
        ),
      ),
    );
  }
}