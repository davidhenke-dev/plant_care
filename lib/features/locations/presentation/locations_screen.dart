import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../l10n/app_localizations.dart';
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
    final l = AppLocalizations.of(context);
    await showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l.locationsDeleteTitle),
        content: Text(l.locationsDeleteMessage(name)),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l.actionCancel),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              ref.read(locationNotifierProvider.notifier).deleteLocation(id);
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
    final locationsAsync = ref.watch(locationNotifierProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l.locationsTitle),
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
          error: (e, _) => Center(child: Text(l.errorPrefix(e.toString()))),
          data: (locations) => locations.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(CupertinoIcons.map,
                          size: 48, color: CupertinoColors.systemGrey3),
                      const SizedBox(height: 12),
                      Text(l.locationsEmpty,
                          style: const TextStyle(
                              color: CupertinoColors.systemGrey, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(l.locationsEmptyHint,
                          style: const TextStyle(
                              color: CupertinoColors.systemGrey3, fontSize: 14)),
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
                          context, ref, location.id, location.name),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
