import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../application/home_notifier.dart';
import '../application/weather_notifier.dart';
import '../../../features/settings/presentation/settings_screen.dart';
import '../../plants/presentation/plant_detail_screen.dart';
import 'watering_todo_card.dart';
import 'fertilizing_todo_card.dart';
import 'weather_widget.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final homeAsync = ref.watch(homeNotifierProvider);
    final locationRepo = ref.read(locationRepositoryProvider);
    final locale = Localizations.localeOf(context).languageCode;
    final today = DateFormat('EEEE, d. MMMM', locale).format(DateTime.now());

    return CupertinoPageScaffold(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(l.homeTodayTitle),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute(builder: (_) => const SettingsScreen()),
              ),
              child: const Icon(CupertinoIcons.settings, size: 22),
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
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              await ref.read(weatherProvider.notifier).refresh();
              ref.invalidate(homeNotifierProvider);
            },
            builder: (context, mode, pulledExtent, refreshTriggerPullDistance,
                    refreshIndicatorExtent) =>
                const Center(
              child: CupertinoActivityIndicator(
                color: Color(0xFF4CAF50),
                radius: 14,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: WeatherWidget()),

          // ── Zu gießen ──────────────────────────────────────────────────────
          homeAsync.maybeWhen(
            data: (state) => state.needsWatering.isEmpty
                ? const SliverToBoxAdapter(child: SizedBox.shrink())
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.drop_fill,
                              color: CupertinoColors.systemBlue, size: 18),
                          const SizedBox(width: 8),
                          Text(l.homeNeedsWatering,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          _CountBadge(
                              count: state.needsWatering.length,
                              color: CupertinoColors.systemBlue),
                        ],
                      ),
                    ),
                  ),
            orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          homeAsync.when(
            loading: () => const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 24),
                child: Center(child: CupertinoActivityIndicator()),
              ),
            ),
            error: (e, _) => SliverFillRemaining(
              child: Center(child: Text(l.errorPrefix(e.toString()))),
            ),
            data: (state) {
              if (state.needsWatering.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final plant = state.needsWatering[index];
                      return FutureBuilder(
                        future: plant.locationId != null
                            ? locationRepo.getById(plant.locationId!)
                            : Future.value(null),
                        builder: (context, snapshot) => WateringTodoCard(
                          plant: plant,
                          locationName: snapshot.data?.name ?? '',
                          onWatered: () => ref
                              .read(homeNotifierProvider.notifier)
                              .markAsWatered(plant.id),
                          onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plantId: plant.id),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.needsWatering.length,
                  ),
                ),
              );
            },
          ),

          // ── Zu düngen ──────────────────────────────────────────────────────
          homeAsync.maybeWhen(
            data: (state) => state.needsFertilizing.isEmpty
                ? const SliverToBoxAdapter(child: SizedBox.shrink())
                : SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.sparkles,
                              color: CupertinoColors.systemOrange, size: 18),
                          const SizedBox(width: 8),
                          Text(l.homeNeedsFertilizing,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700)),
                          const Spacer(),
                          _CountBadge(
                              count: state.needsFertilizing.length,
                              color: CupertinoColors.systemOrange),
                        ],
                      ),
                    ),
                  ),
            orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          homeAsync.maybeWhen(
            data: (state) {
              if (state.needsFertilizing.isEmpty) {
                return const SliverToBoxAdapter(child: SizedBox.shrink());
              }
              return SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final plant = state.needsFertilizing[index];
                      return FutureBuilder(
                        future: plant.locationId != null
                            ? locationRepo.getById(plant.locationId!)
                            : Future.value(null),
                        builder: (context, snapshot) => FertilizingTodoCard(
                          plant: plant,
                          locationName: snapshot.data?.name ?? '',
                          onFertilized: () => ref
                              .read(homeNotifierProvider.notifier)
                              .markAsFertilized(plant.id),
                          onTap: () => Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) =>
                                  PlantDetailScreen(plantId: plant.id),
                            ),
                          ),
                        ),
                      );
                    },
                    childCount: state.needsFertilizing.length,
                  ),
                ),
              );
            },
            orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),

          // ── Alles erledigt ─────────────────────────────────────────────────
          homeAsync.maybeWhen(
            data: (state) =>
                state.needsWatering.isEmpty && state.needsFertilizing.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(CupertinoIcons.checkmark_seal_fill,
                                  size: 56, color: Color(0xFF4CAF50)),
                              const SizedBox(height: 16),
                              Text(l.homeAllDone,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(height: 8),
                              Text(
                                l.homeNothingToDo,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: CupertinoColors.systemGrey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SliverToBoxAdapter(child: SizedBox(height: 100)),
            orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final int count;
  final Color color;

  const _CountBadge({required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        '$count',
        style: TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: color),
      ),
    );
  }
}
