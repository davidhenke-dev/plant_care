import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/plant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/plant_image.dart';

class WateringTodoCard extends StatelessWidget {
  final Plant plant;
  final String locationName;
  final VoidCallback onWatered;
  final VoidCallback? onTap;

  const WateringTodoCard({
    super.key,
    required this.plant,
    required this.locationName,
    required this.onWatered,
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
                            const Icon(CupertinoIcons.drop_fill,
                                size: 12, color: CupertinoColors.systemBlue),
                            const SizedBox(width: 4),
                            Text(
                              plant.lastWateredAt == null
                                  ? l.wateringCardNeverWatered
                                  : l.wateringCardInterval(
                                      plant.wateringIntervalDays),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: CupertinoColors.systemBlue),
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
              onPressed: onWatered,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(CupertinoIcons.checkmark_alt,
                    color: CupertinoColors.systemBlue, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
