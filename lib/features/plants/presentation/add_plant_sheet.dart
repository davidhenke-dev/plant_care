import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/location.dart';
import '../../../data/repositories/repository_providers.dart';
import '../application/plant_notifier.dart';
import '../../../shared/widgets/cupertino_stepper.dart';

class AddPlantSheet extends ConsumerStatefulWidget {
  const AddPlantSheet({super.key});

  @override
  ConsumerState<AddPlantSheet> createState() => _AddPlantSheetState();
}

class _AddPlantSheetState extends ConsumerState<AddPlantSheet> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  int _wateringIntervalDays = 7;
  String? _selectedLocationId;
  String? _imagePath;

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked != null) {
      setState(() => _imagePath = picked.path);
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;
    if (_selectedLocationId == null) {
      showCupertinoDialog(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: const Text('Kein Standort'),
          content: const Text('Bitte wähle einen Standort für die Pflanze.'),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    await ref.read(plantNotifierProvider.notifier).addPlant(
          name: _nameController.text.trim(),
          locationId: _selectedLocationId!,
          wateringIntervalDays: _wateringIntervalDays,
          imagePath: _imagePath,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final locations = ref.watch(locationRepositoryProvider).getAll();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Abbrechen'),
        ),
        middle: const Text('Pflanze anlegen'),
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
            // Foto
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey6,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.camera,
                            size: 36,
                            color: CupertinoColors.systemGrey,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Foto hinzufügen',
                            style: TextStyle(
                              color: CupertinoColors.systemGrey,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Name
            CupertinoTextField(
              controller: _nameController,
              placeholder: 'Name der Pflanze',
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 12),

            // Notizen
            CupertinoTextField(
              controller: _notesController,
              placeholder: 'Notizen (optional)',
              padding: const EdgeInsets.all(14),
              maxLines: 3,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey6,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            const SizedBox(height: 24),

            // Standort
            const Text(
              'Standort',
              style: TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Location>>(
              future: locations,
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemGrey6,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Keine Standorte vorhanden – lege zuerst einen Standort an.',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                  );
                }
                final locationList = snapshot.data!;
                return Container(
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: locationList.map((loc) {
                      final isSelected = _selectedLocationId == loc.id;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedLocationId = loc.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF4CAF50).withOpacity(0.1)
                                : CupertinoColors.systemGrey6,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                CupertinoIcons.map_pin_ellipse,
                                size: 18,
                                color: isSelected
                                    ? const Color(0xFF4CAF50)
                                    : CupertinoColors.systemGrey,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                loc.name,
                                style: TextStyle(
                                  color: isSelected
                                      ? const Color(0xFF4CAF50)
                                      : CupertinoColors.label,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                ),
                              ),
                              const Spacer(),
                              if (isSelected)
                                const Icon(
                                  CupertinoIcons.checkmark_alt,
                                  color: Color(0xFF4CAF50),
                                  size: 18,
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Bewässerungsintervall
            const Text(
              'Bewässerungsintervall',
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
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(
                    CupertinoIcons.drop,
                    color: Color(0xFF4CAF50),
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text('Alle $_wateringIntervalDays Tage'),
                  const Spacer(),
                  CupertinoStepper(
                    value: _wateringIntervalDays.toDouble(),
                    min: 1,
                    max: 30,
                    stepValue: 1,
                    onChanged: (v) =>
                        setState(() => _wateringIntervalDays = v.toInt()),
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