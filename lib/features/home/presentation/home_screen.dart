import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../features/settings/application/notification_settings_notifier.dart';
import '../application/home_notifier.dart';
import 'watering_todo_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plantsAsync = ref.watch(homeNotifierProvider);
    final locationRepo = ref.read(locationRepositoryProvider);
    final settingsAsync = ref.watch(notificationSettingsProvider);
    final today = DateFormat('EEEE, d. MMMM', 'de').format(DateTime.now());

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: const Text('Heute'),
            trailing: settingsAsync.maybeWhen(
              data: (settings) => CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => ref
                    .read(notificationSettingsProvider.notifier)
                    .setEnabled(!settings.isEnabled),
                child: Icon(
                  settings.isEnabled
                      ? CupertinoIcons.bell_fill
                      : CupertinoIcons.bell,
                  color: settings.isEnabled
                      ? const Color(0xFF4CAF50)
                      : CupertinoColors.systemGrey,
                ),
              ),
              orElse: () => const SizedBox.shrink(),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Text(
                today,
                style: const TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.drop_fill,
                    color: CupertinoColors.systemBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Zu gießen',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  plantsAsync.when(
                    data: (plants) => Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: plants.isEmpty
                            ? const Color(0xFF4CAF50).withOpacity(0.1)
                            : CupertinoColors.systemBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${plants.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: plants.isEmpty
                              ? const Color(0xFF4CAF50)
                              : CupertinoColors.systemBlue,
                        ),
                      ),
                    ),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),

          // Todo Liste
          plantsAsync.when(
            loading: () => const SliverFillRemaining(
              child: Center(child: CupertinoActivityIndicator()),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text('Fehler: $e')),
            ),
            data: (plants) {
              if (plants.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          CupertinoIcons.checkmark_seal_fill,
                          size: 56,
                          color: Color(0xFF4CAF50),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Alles erledigt! 🎉',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Heute müssen keine Pflanzen gegossen werden.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final plant = plants[index];
                      return FutureBuilder(
                        future: locationRepo.getById(plant.locationId),
                        builder: (context, snapshot) {
                          return WateringTodoCard(
                            plant: plant,
                            locationName: snapshot.data?.name ?? '...',
                            onWatered: () => ref
                                .read(homeNotifierProvider.notifier)
                                .markAsWatered(plant.id),
                          );
                        },
                      );
                    },
                    childCount: plants.length,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}