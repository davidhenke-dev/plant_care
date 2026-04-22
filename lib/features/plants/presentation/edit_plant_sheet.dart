import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/location.dart';
import '../../../data/models/plant.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../l10n/app_localizations.dart';
import '../application/plant_notifier.dart';
import '../../../shared/widgets/cupertino_stepper.dart';
import 'package:flutter/material.dart';

class EditPlantSheet extends ConsumerStatefulWidget {
  final Plant plant;

  const EditPlantSheet({super.key, required this.plant});

  @override
  ConsumerState<EditPlantSheet> createState() => _EditPlantSheetState();
}

class _EditPlantSheetState extends ConsumerState<EditPlantSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _notesController;
  late int _wateringIntervalDays;
  int? _fertilizingIntervalWeeks;
  String? _selectedLocationId;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _notesController = TextEditingController(text: widget.plant.notes ?? '');
    _wateringIntervalDays = widget.plant.wateringIntervalDays;
    _fertilizingIntervalWeeks = widget.plant.fertilizingIntervalWeeks;
    _selectedLocationId = widget.plant.locationId;
    _imagePath = widget.plant.imagePath;
  }

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
    if (picked != null && mounted) {
      final savedPath = await _copyToDocuments(picked.path);
      setState(() => _imagePath = savedPath);
    }
  }

  Future<String> _copyToDocuments(String sourcePath) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final filename = 'plant_img_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final dest = File('${dir.path}/$filename');
      await File(sourcePath).copy(dest.path);
      return dest.path;
    } catch (_) {
      return sourcePath;
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    await ref.read(plantNotifierProvider.notifier).updatePlant(
          id: widget.plant.id,
          name: _nameController.text.trim(),
          locationId: _selectedLocationId,
          wateringIntervalDays: _wateringIntervalDays,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          fertilizingIntervalWeeks: _fertilizingIntervalWeeks,
        );

    if (_imagePath != widget.plant.imagePath && _imagePath != null) {
      await ref
          .read(plantNotifierProvider.notifier)
          .updateImagePath(widget.plant.id, _imagePath!);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locations = ref.watch(locationRepositoryProvider).getAll();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).actionCancel),
        ),
        middle: Text(widget.plant.name),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _save,
          child: Text(
            l.actionSave,
            style: const TextStyle(fontWeight: FontWeight.w600),
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
                  color: kCardBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: _imagePath != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.file(
                          File(_imagePath!),
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 180,
                          errorBuilder: (_, __, ___) => Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(CupertinoIcons.camera,
                                  size: 36, color: CupertinoColors.systemGrey),
                              const SizedBox(height: 8),
                              Text(l.plantDetailNoPhoto,
                                  style: const TextStyle(
                                      color: CupertinoColors.systemGrey)),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            CupertinoIcons.camera,
                            size: 36,
                            color: CupertinoColors.systemGrey,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l.createPlantPhotoLabel,
                            style: const TextStyle(
                                color: CupertinoColors.systemGrey),
                          ),
                        ],
                      ),
              ),
            ),
            const SizedBox(height: 20),

            // Name
            CupertinoTextField(
              controller: _nameController,
              placeholder: l.createPlantNameHint,
              padding: const EdgeInsets.all(14),
              textCapitalization: TextCapitalization.sentences,
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: CupertinoColors.systemGrey4.resolveFrom(context)),
              ),
            ),
            const SizedBox(height: 12),

            // Notes
            CupertinoTextField(
              controller: _notesController,
              placeholder: l.createPlantNotesHint,
              padding: const EdgeInsets.all(14),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: CupertinoColors.systemGrey4.resolveFrom(context)),
              ),
            ),
            const SizedBox(height: 24),

            // Location
            Text(
              l.locationDetailTitle,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            FutureBuilder<List<Location>>(
              future: locations,
              builder: (context, snapshot) {
                final l = AppLocalizations.of(context);
                final locationList = snapshot.data ?? [];
                return Column(
                  children: [
                    _editLocationItem(
                      context: context,
                      icon: CupertinoIcons.xmark_circle,
                      label: l.noLocation,
                      isSelected: _selectedLocationId == null,
                      onTap: () => setState(() => _selectedLocationId = null),
                    ),
                    const SizedBox(height: 8),
                    ...locationList.map((loc) => _editLocationItem(
                          context: context,
                          icon: CupertinoIcons.map_pin_ellipse,
                          label: loc.name,
                          isSelected: _selectedLocationId == loc.id,
                          onTap: () =>
                              setState(() => _selectedLocationId = loc.id),
                        )),
                  ],
                );
              },
            ),
            const SizedBox(height: 24),

            // Watering interval
            Text(
              l.plantDetailWateringInterval,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: CupertinoColors.systemGrey4.resolveFrom(context)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.drop,
                      color: Color(0xFF4CAF50), size: 20),
                  const SizedBox(width: 10),
                  Text('$_wateringIntervalDays ${l.createPlantDaysUnit}'),
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
            const SizedBox(height: 24),

            // Fertilizing interval
            Text(
              l.plantDetailFertilizingInterval,
              style: const TextStyle(
                fontSize: 13,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: CupertinoColors.systemGrey4.resolveFrom(context)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.sparkles,
                          color: CupertinoColors.systemOrange, size: 20),
                      const SizedBox(width: 10),
                      Text(l.createPlantFertilizingToggle),
                      const Spacer(),
                      CupertinoSwitch(
                        value: _fertilizingIntervalWeeks != null,
                        activeTrackColor: CupertinoColors.systemOrange,
                        onChanged: (v) => setState(() {
                          _fertilizingIntervalWeeks = v ? 4 : null;
                        }),
                      ),
                    ],
                  ),
                  if (_fertilizingIntervalWeeks != null) ...[
                    const Divider(height: 16),
                    Row(
                      children: [
                        const SizedBox(width: 30),
                        Text(
                            '$_fertilizingIntervalWeeks ${l.createPlantWeeksUnit}'),
                        const Spacer(),
                        CupertinoStepper(
                          value: _fertilizingIntervalWeeks!.toDouble(),
                          min: 1,
                          max: 12,
                          stepValue: 1,
                          onChanged: (v) => setState(
                            () => _fertilizingIntervalWeeks = v.toInt(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _editLocationItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4CAF50).withValues(alpha: 0.1)
            : kCardBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
              : CupertinoColors.systemGrey4.resolveFrom(context),
        ),
      ),
      child: Row(
        children: [
          Icon(icon,
              size: 18,
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : CupertinoColors.systemGrey),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? const Color(0xFF4CAF50)
                  : CupertinoColors.label.resolveFrom(context),
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          const Spacer(),
          if (isSelected)
            const Icon(CupertinoIcons.checkmark_alt,
                color: Color(0xFF4CAF50), size: 18),
        ],
      ),
    ),
  );
}
