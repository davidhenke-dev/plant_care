import 'package:flutter/cupertino.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/location.dart';
import '../../../l10n/app_localizations.dart';
import 'location_detail_screen.dart';

class LocationCard extends StatelessWidget {
  final Location location;
  final VoidCallback onDelete;

  const LocationCard({
    super.key,
    required this.location,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    final lightLabel = switch (location.light) {
      LightLevel.fullSun => l.locationLightFull,
      LightLevel.partialSun => l.locationLightPartial,
      LightLevel.shade => l.locationLightShade,
    };

    final humidityLabel = switch (location.humidity) {
      HumidityLevel.dry => l.locationHumidityDry,
      HumidityLevel.moderate => l.locationHumidityModerate,
      HumidityLevel.humid => l.locationHumidityHumid,
    };

    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        CupertinoPageRoute(
          builder: (_) => LocationDetailScreen(locationId: location.id),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: kCardBackground.resolveFrom(context),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey
                  .resolveFrom(context)
                  .withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(CupertinoIcons.map_pin_ellipse,
                    color: Color(0xFF4CAF50), size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(location.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      '$lightLabel · $humidityLabel',
                      style: const TextStyle(
                          fontSize: 13, color: CupertinoColors.systemGrey),
                    ),
                    if (location.isDrafty || !location.isHeatedInWinter) ...[
                      const SizedBox(height: 4),
                      Text(
                        [
                          if (location.isDrafty) l.locationDrafty,
                          if (!location.isHeatedInWinter) l.locationUnheated,
                        ].join(' · '),
                        style: const TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.systemOrange),
                      ),
                    ],
                  ],
                ),
              ),
              CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: onDelete,
                child: const Icon(CupertinoIcons.trash,
                    color: CupertinoColors.systemRed, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
