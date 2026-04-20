import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/location.dart';
import '../application/location_notifier.dart';
import 'package:flutter/material.dart' show Divider;

class AddLocationSheet extends ConsumerStatefulWidget {
  const AddLocationSheet({super.key});

  @override
  ConsumerState<AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends ConsumerState<AddLocationSheet> {
  final _nameController = TextEditingController();
  LightLevel _lightLevel = LightLevel.partialSun;
  HumidityLevel _humidityLevel = HumidityLevel.moderate;
  bool _isDrafty = false;
  bool _isHeatedInWinter = true;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    await ref.read(locationNotifierProvider.notifier).addLocation(
          name: _nameController.text.trim(),
          lightLevel: _lightLevel,
          humidityLevel: _humidityLevel,
          isDrafty: _isDrafty,
          isHeatedInWinter: _isHeatedInWinter,
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        middle: const Text('Standort anlegen'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: const Text(
            'Speichern',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Name
            CupertinoTextField(
              controller: _nameController,
              placeholder: 'z.B. Wohnzimmer, Balkon...',
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),

            // Lichtverhältnisse
            const Text(
              'Lichtverhältnisse',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            CupertinoSlidingSegmentedControl<LightLevel>(
              groupValue: _lightLevel,
              onValueChanged: (v) => setState(() => _lightLevel = v!),
              children: const {
                LightLevel.fullSun: Text('☀️ Sonnig'),
                LightLevel.partialSun: Text('⛅ Halbschattig'),
                LightLevel.shade: Text('🌥 Schattig'),
              },
            ),
            const SizedBox(height: 24),

            // Luftfeuchtigkeit
            const Text(
              'Luftfeuchtigkeit',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            CupertinoSlidingSegmentedControl<HumidityLevel>(
              groupValue: _humidityLevel,
              onValueChanged: (v) => setState(() => _humidityLevel = v!),
              children: const {
                HumidityLevel.dry: Text('🏜 Trocken'),
                HumidityLevel.moderate: Text('🌤 Moderat'),
                HumidityLevel.humid: Text('💧 Feucht'),
              },
            ),
            const SizedBox(height: 24),

            // Zusatzoptionen
            const Text(
              'Weitere Eigenschaften',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  CupertinoListTile(
                    title: const Text('Zugluft'),
                    subtitle: const Text('Fenster oder Tür in der Nähe'),
                    trailing: CupertinoSwitch(
                      value: _isDrafty,
                      onChanged: (v) => setState(() => _isDrafty = v),
                    ),
                  ),
                Divider(height: 0, indent: 16),
                  CupertinoListTile(
                    title: const Text('Geheizt im Winter'),
                    subtitle: const Text('Regelmäßige Heizung vorhanden'),
                    trailing: CupertinoSwitch(
                      value: _isHeatedInWinter,
                      onChanged: (v) =>
                          setState(() => _isHeatedInWinter = v),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}