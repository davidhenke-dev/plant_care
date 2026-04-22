import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../application/plant_notifier.dart';
import 'create_plant_flow.dart';
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
    final l = AppLocalizations.of(context);
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l.plantsDeleteTitle),
        content: Text(l.plantsDeleteMessage(name)),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.actionCancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(plantNotifierProvider.notifier).deletePlant(id);
              Navigator.of(ctx).pop();
            },
            child: Text(l.actionDelete),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final plantsAsync = ref.watch(plantNotifierProvider);
    final locationRepo = ref.read(locationRepositoryProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l.plantsTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).push(
            CupertinoPageRoute(builder: (_) => const CreatePlantFlow()),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: plantsAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text(l.errorPrefix(e.toString()))),
          data: (plants) => plants.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.leaf_arrow_circlepath,
                          size: 48, color: CupertinoColors.systemGrey3),
                      const SizedBox(height: 12),
                      Text(l.plantsEmpty,
                          style: const TextStyle(
                              color: CupertinoColors.systemGrey, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(l.plantsEmptyHint,
                          style: const TextStyle(
                              color: CupertinoColors.systemGrey3, fontSize: 14)),
                    ],
                  ),
                )
              : FutureBuilder(
                  future: locationRepo.getAll(),
                  builder: (context, snapshot) {
                    final locationMap = {
                      for (final loc in snapshot.data ?? []) loc.id: loc.name
                    };
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                      itemCount: plants.length,
                      itemBuilder: (context, index) {
                        final plant = plants[index];
                        return PlantCard(
                          plant: plant,
                          locationName: plant.locationId == null
                              ? l.noLocation
                              : (locationMap[plant.locationId] ??
                                  l.unknownLocation),
                          onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plantId: plant.id),
                            ),
                          ),
                          onDelete: () => _confirmDelete(
                              context, ref, plant.id, plant.name),
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
