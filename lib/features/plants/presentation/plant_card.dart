import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/plant.dart';
import '../../../l10n/app_localizations.dart';
import '../../../shared/widgets/plant_image.dart';

class PlantCard extends StatelessWidget {
  final Plant plant;
  final String locationName;
  final VoidCallback onDelete;
  final VoidCallback onWatered;
  final VoidCallback? onTap;

  const PlantCard({
    super.key,
    required this.plant,
    required this.locationName,
    required this.onDelete,
    required this.onWatered,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final needsWater = plant.needsWateringToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child:
                    PlantImage(imagePath: plant.imagePath, width: 56, height: 56),
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
                    Text('📍 $locationName',
                        style: const TextStyle(
                            fontSize: 13,
                            color: CupertinoColors.systemGrey)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(CupertinoIcons.drop_fill,
                            size: 12,
                            color: needsWater
                                ? CupertinoColors.systemBlue
                                : CupertinoColors.systemGrey3),
                        const SizedBox(width: 4),
                        Text(
                          needsWater
                              ? l.plantsNeedsWateringToday
                              : l.plantsWateringInterval(
                                  plant.wateringIntervalDays),
                          style: TextStyle(
                            fontSize: 12,
                            color: needsWater
                                ? CupertinoColors.systemBlue
                                : CupertinoColors.systemGrey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: needsWater ? onWatered : null,
                    child: Icon(CupertinoIcons.drop_fill,
                        color: needsWater
                            ? CupertinoColors.systemBlue
                            : CupertinoColors.systemGrey3,
                        size: 22),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: onDelete,
                    child: const Icon(CupertinoIcons.trash,
                        color: CupertinoColors.systemRed, size: 20),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
