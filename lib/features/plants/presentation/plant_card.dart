import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../../data/models/plant.dart';

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
    final needsWater = plant.needsWateringToday;

    return GestureDetector(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.systemGrey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Bild
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: plant.imagePath != null
                  ? Image.file(
                      File(plant.imagePath!),
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 56,
                      height: 56,
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      child: const Icon(
                        CupertinoIcons.leaf_arrow_circlepath,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    plant.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '📍 $locationName',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.drop_fill,
                        size: 12,
                        color: needsWater
                            ? CupertinoColors.systemBlue
                            : CupertinoColors.systemGrey3,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        needsWater
                            ? 'Muss heute gegossen werden'
                            : 'Alle ${plant.wateringIntervalDays} Tage',
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

            // Aktionen
            Column(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: needsWater ? onWatered : null,
                  child: Icon(
                    CupertinoIcons.drop_fill,
                    color: needsWater
                        ? CupertinoColors.systemBlue
                        : CupertinoColors.systemGrey3,
                    size: 22,
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: onDelete,
                  child: const Icon(
                    CupertinoIcons.trash,
                    color: CupertinoColors.systemRed,
                    size: 20,
                  ),
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