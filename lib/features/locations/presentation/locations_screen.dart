import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/location_notifier.dart';
import 'add_location_sheet.dart';
import 'location_card.dart';

class LocationsScreen extends ConsumerWidget {
  const LocationsScreen({super.key});

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    String id,
    String name,
  ) async {
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Standort löschen'),
        content: Text('Möchtest du "$name" wirklich löschen?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Abbrechen'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(locationNotifierProvider.notifier).deleteLocation(id);
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
    final locationsAsync = ref.watch(locationNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Standorte'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => showCupertinoModalPopup(
            context: context,
            builder: (_) => const AddLocationSheet(),
          ),
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: locationsAsync.when(
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (e, _) => Center(child: Text('Fehler: $e')),
          data: (locations) => locations.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        CupertinoIcons.map,
                        size: 48,
                        color: CupertinoColors.systemGrey3,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Noch keine Standorte',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Tippe auf + um einen anzulegen',
                        style: TextStyle(
                          color: CupertinoColors.systemGrey3,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    final location = locations[index];
                    return LocationCard(
                      location: location,
                      onDelete: () => _confirmDelete(
                        context,
                        ref,
                        location.id,
                        location.name,
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}