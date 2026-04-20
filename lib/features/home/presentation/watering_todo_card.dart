import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../../../data/models/plant.dart';

class WateringTodoCard extends StatelessWidget {
  final Plant plant;
  final String locationName;
  final VoidCallback onWatered;

  const WateringTodoCard({
    super.key,
    required this.plant,
    required this.locationName,
    required this.onWatered,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // Pflanzenbild
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: plant.imagePath != null
                  ? Image.file(
                      File(plant.imagePath!),
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 52,
                      height: 52,
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      child: const Icon(
                        CupertinoIcons.leaf_arrow_circlepath,
                        color: Color(0xFF4CAF50),
                        size: 26,
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
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.map_pin,
                        size: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        locationName,
                        style: const TextStyle(
                          fontSize: 13,
                          color: CupertinoColors.systemGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        CupertinoIcons.drop_fill,
                        size: 12,
                        color: CupertinoColors.systemBlue,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        plant.lastWateredAt == null
                            ? 'Noch nie gegossen'
                            : 'Intervall: alle ${plant.wateringIntervalDays} Tage',
                        style: const TextStyle(
                          fontSize: 12,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Abhaken Button
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onWatered,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  CupertinoIcons.checkmark_alt,
                  color: CupertinoColors.systemBlue,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}