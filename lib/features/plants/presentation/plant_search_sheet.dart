import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/plant_search/plant_search_result.dart';
import '../application/plant_search_notifier.dart';

class PlantSearchSheet extends ConsumerStatefulWidget {
  const PlantSearchSheet({super.key});

  @override
  ConsumerState<PlantSearchSheet> createState() => _PlantSearchSheetState();
}

class _PlantSearchSheetState extends ConsumerState<PlantSearchSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final searchState = ref.watch(plantSearchProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        middle: const Text('Pflanze suchen'),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: CupertinoSearchTextField(
                controller: _controller,
                placeholder: 'z.B. Monstera, Ficus, Orchidee...',
                autofocus: true,
                onChanged: (q) =>
                    ref.read(plantSearchProvider.notifier).search(q),
                onSuffixTap: () {
                  _controller.clear();
                  ref.read(plantSearchProvider.notifier).clear();
                },
              ),
            ),
            Expanded(
              child: searchState.when(
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Fehler bei der Suche.\nBitte API-Key prüfen.',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  ),
                ),
                data: (results) {
                  if (_controller.text.isEmpty) {
                    return const _EmptyHint();
                  }
                  if (results.isEmpty) {
                    return const Center(
                      child: Text(
                        'Keine Ergebnisse gefunden.',
                        style: TextStyle(color: CupertinoColors.systemGrey),
                      ),
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 40),
                    itemCount: results.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 1),
                    itemBuilder: (context, index) =>
                        _ResultTile(result: results[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final PlantSearchResult result;

  const _ResultTile({required this.result});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pop(result),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: result.thumbnailUrl != null
                  ? CachedNetworkImage(
                      imageUrl: result.thumbnailUrl!,
                      width: 52,
                      height: 52,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                          _InitialPlaceholder(name: result.commonName),
                      errorWidget: (_, __, ___) =>
                          _InitialPlaceholder(name: result.commonName),
                    )
                  : _InitialPlaceholder(name: result.commonName),
            ),
            const SizedBox(width: 12),

            // Namen
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    result.commonName,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (result.scientificName.isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      result.scientificName,
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Gießindikator
            _WateringBadge(label: result.watering),
          ],
        ),
      ),
    );
  }
}

class _WateringBadge extends StatelessWidget {
  final String label;
  const _WateringBadge({required this.label});

  @override
  Widget build(BuildContext context) {
    final (text, color) = switch (label.toLowerCase()) {
      'frequent' => ('💧💧', const Color(0xFF1565C0)),
      'average' => ('💧', const Color(0xFF4CAF50)),
      'minimum' => ('🌵', const Color(0xFFFF8F00)),
      _ => ('☁️', CupertinoColors.systemGrey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 13)),
    );
  }
}

class _InitialPlaceholder extends StatelessWidget {
  final String name;
  const _InitialPlaceholder({required this.name});

  static const _colors = [
    Color(0xFF4CAF50),
    Color(0xFF2E7D32),
    Color(0xFF81C784),
    Color(0xFF388E3C),
    Color(0xFF66BB6A),
  ];

  @override
  Widget build(BuildContext context) {
    final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
    final color = _colors[name.codeUnitAt(0) % _colors.length];
    return Container(
      width: 52,
      height: 52,
      color: color.withValues(alpha: 0.2),
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ),
    );
  }
}

class _EmptyHint extends StatelessWidget {
  const _EmptyHint();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            CupertinoIcons.search,
            size: 48,
            color: CupertinoColors.systemGrey3,
          ),
          SizedBox(height: 12),
          Text(
            'Pflanzennamen eingeben',
            style: TextStyle(
              color: CupertinoColors.systemGrey,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'z.B. Monstera oder Ficus',
            style: TextStyle(
              color: CupertinoColors.systemGrey3,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
