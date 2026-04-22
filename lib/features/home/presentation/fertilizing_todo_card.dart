import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/plant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/plant_image.dart';

class FertilizingTodoCard extends StatelessWidget {
  final Plant plant;
  final String locationName;
  final VoidCallback onFertilized;
  final VoidCallback? onTap;

  const FertilizingTodoCard({
    super.key,
    required this.plant,
    required this.locationName,
    required this.onFertilized,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: PlantImage(
                          imagePath: plant.imagePath, width: 52, height: 52),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(plant.name,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(CupertinoIcons.map_pin,
                                size: 12, color: CupertinoColors.systemGrey),
                            const SizedBox(width: 4),
                            Text(locationName,
                                style: const TextStyle(
                                    fontSize: 13,
                                    color: CupertinoColors.systemGrey)),
                          ]),
                          const SizedBox(height: 4),
                          Row(children: [
                            const Icon(CupertinoIcons.sparkles,
                                size: 12,
                                color: CupertinoColors.systemOrange),
                            const SizedBox(width: 4),
                            Text(
                              plant.lastFertilizedAt == null
                                  ? l.fertilizingCardNeverFertilized
                                  : l.fertilizingCardInterval(
                                      plant.fertilizingIntervalWeeks ?? 0),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemOrange),
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onFertilized,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemOrange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(CupertinoIcons.checkmark_alt,
                    color: CupertinoColors.systemOrange, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
