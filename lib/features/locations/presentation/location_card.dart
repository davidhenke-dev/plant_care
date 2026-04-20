import 'package:flutter/cupertino.dart';
import '../../../data/models/location.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onDelete;

  const LocationCard({
    super.key,
    required this.location,
    required this.onDelete,
  });

  String get _lightLabel => switch (location.light) {
        LightLevel.fullSun => '☀️ Sonnig',
        LightLevel.partialSun => '⛅ Halbschattig',
        LightLevel.shade => '🌥 Schattig',
      };

  String get _humidityLabel => switch (location.humidity) {
        HumidityLevel.dry => '🏜 Trocken',
        HumidityLevel.moderate => '🌤 Moderat',
        HumidityLevel.humid => '💧 Feucht',
      };

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
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                CupertinoIcons.map_pin_ellipse,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            const SizedBox(width: 14),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    location.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$_lightLabel · $_humidityLabel',
                    style: const TextStyle(
                      fontSize: 13,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  if (location.isDrafty || !location.isHeatedInWinter) ...[
                    const SizedBox(height: 4),
                    Text(
                      [
                        if (location.isDrafty) 'Zugluft',
                        if (!location.isHeatedInWinter) 'Ungeheizt',
                      ].join(' · '),
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemOrange,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Delete Button
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
      ),
    );
  }
}