import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/plant_search/plant_search_result.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../data/models/location.dart';
import '../../../data/repositories/repository_providers.dart';
import '../../../shared/widgets/cupertino_stepper.dart';
import '../application/plant_notifier.dart';
import 'plant_search_sheet.dart';

class CreatePlantFlow extends ConsumerStatefulWidget {
  const CreatePlantFlow({super.key});

  @override
  ConsumerState<CreatePlantFlow> createState() => _CreatePlantFlowState();
}

class _CreatePlantFlowState extends ConsumerState<CreatePlantFlow> {
  final _pageController = PageController();
  int _currentStep = 0;
  static const int _totalSteps = 5;

  // Step 0 – Name
  final _nameController = TextEditingController();

  // Step 1 – Watering
  int _wateringIntervalDays = 7;
  DateTime? _lastWateredAt;

  // Step 2 – Fertilizing
  bool _fertilizingEnabled = false;
  int _fertilizingIntervalWeeks = 4;
  DateTime? _lastFertilizedAt;

  // Step 3 – Location
  String? _selectedLocationId;

  // Step 4 – Details
  String? _imagePath;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _next() {
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _Toast(
        message: message,
        onDone: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }

  void _back() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pop();
    }
  }

  Future<void> _save() async {
    if (_nameController.text.trim().isEmpty) return;

    final notifier = ref.read(plantNotifierProvider.notifier);
    await notifier.addPlant(
      name: _nameController.text.trim(),
      locationId: _selectedLocationId,
      wateringIntervalDays: _wateringIntervalDays,
      imagePath: _imagePath,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      fertilizingIntervalWeeks:
          _fertilizingEnabled ? _fertilizingIntervalWeeks : null,
    );

    // Set last watered / last fertilized after creation
    if (_lastWateredAt != null || _lastFertilizedAt != null) {
      final plants = await ref.read(plantNotifierProvider.future);
      final plant = plants
          .where((p) => p.name == _nameController.text.trim())
          .lastOrNull;
      if (plant != null) {
        if (_lastWateredAt != null) {
          plant.lastWateredAt = _lastWateredAt;
          await plant.save();
        }
        if (_lastFertilizedAt != null) {
          plant.lastFertilizedAt = _lastFertilizedAt;
          await plant.save();
        }
        ref.invalidate(plantNotifierProvider);
      }
    }

    if (mounted) Navigator.of(context).pop();
  }

  Future<void> _openSearch() async {
    final result = await Navigator.of(context).push<PlantSearchResult>(
      CupertinoPageRoute(builder: (_) => const PlantSearchSheet()),
    );
    if (result == null) return;

    setState(() {
      _nameController.text = result.commonName;
      _wateringIntervalDays = result.wateringIntervalDays;
      _fertilizingEnabled = result.fertilizingIntervalWeeks != null;
      if (result.fertilizingIntervalWeeks != null) {
        _fertilizingIntervalWeeks = result.fertilizingIntervalWeeks!;
      }
      if (_notesController.text.isEmpty && result.scientificName.isNotEmpty) {
        _notesController.text = result.scientificName;
      }
    });

    _next();

    if (result.thumbnailUrl != null) {
      final path = await _downloadThumbnail(result.thumbnailUrl!);
      if (path != null && mounted) setState(() => _imagePath = path);
    }
  }

  Future<String?> _downloadThumbnail(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode != 200) return null;
      final dir = await getApplicationDocumentsDirectory();
      final file = File(
        '${dir.path}/plant_thumb_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      await file.writeAsBytes(response.bodyBytes);
      return file.path;
    } catch (_) {
      return null;
    }
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

  Future<void> _pickDate({
    required DateTime? current,
    required void Function(DateTime) onSelected,
  }) async {
    DateTime temp = current ?? DateTime.now();
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => Container(
        height: 300,
        color: CupertinoColors.systemBackground.resolveFrom(ctx),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  child: Text(AppLocalizations.of(ctx).actionCancel),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                CupertinoButton(
                  child: Text(
                    AppLocalizations.of(ctx).actionDone,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onPressed: () {
                    onSelected(temp);
                    Navigator.of(ctx).pop();
                  },
                ),
              ],
            ),
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: temp,
                maximumDate: DateTime.now(),
                onDateTimeChanged: (d) => temp = d,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      child: SafeArea(
        child: Column(
          children: [
            _TopBar(
              currentStep: _currentStep,
              totalSteps: _totalSteps,
              onBack: _back,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => setState(() => _currentStep = i),
                children: [
                  _StepName(
                    nameController: _nameController,
                    onSearch: _openSearch,
                    onNext: () {
                      if (_nameController.text.trim().isNotEmpty) {
                        _next();
                      } else {
                        _showToast(l.createPlantToastName);
                      }
                    },
                  ),
                  _StepWatering(
                    intervalDays: _wateringIntervalDays,
                    lastWatered: _lastWateredAt,
                    onIntervalChanged: (v) =>
                        setState(() => _wateringIntervalDays = v),
                    onPickDate: () => _pickDate(
                      current: _lastWateredAt,
                      onSelected: (d) => setState(() => _lastWateredAt = d),
                    ),
                    onClearDate: () => setState(() => _lastWateredAt = null),
                    onNext: _next,
                  ),
                  _StepFertilizing(
                    enabled: _fertilizingEnabled,
                    intervalWeeks: _fertilizingIntervalWeeks,
                    lastFertilized: _lastFertilizedAt,
                    onToggle: (v) => setState(() => _fertilizingEnabled = v),
                    onIntervalChanged: (v) =>
                        setState(() => _fertilizingIntervalWeeks = v),
                    onPickDate: () => _pickDate(
                      current: _lastFertilizedAt,
                      onSelected: (d) =>
                          setState(() => _lastFertilizedAt = d),
                    ),
                    onClearDate: () =>
                        setState(() => _lastFertilizedAt = null),
                    onNext: _next,
                  ),
                  _StepLocation(
                    selectedLocationId: _selectedLocationId,
                    onSelected: (id) =>
                        setState(() => _selectedLocationId = id),
                    onDeselect: () =>
                        setState(() => _selectedLocationId = null),
                    onNext: _next,
                  ),
                  _StepDetails(
                    imagePath: _imagePath,
                    notesController: _notesController,
                    onPickImage: _pickImage,
                    onSave: _save,
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

// ── Top bar with progress dots ────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final VoidCallback onBack;

  const _TopBar({
    required this.currentStep,
    required this.totalSteps,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: onBack,
            child: const Icon(CupertinoIcons.chevron_left, size: 22),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(totalSteps, (i) {
                final active = i == currentStep;
                final done = i < currentStep;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 20 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: done || active
                        ? const Color(0xFF4CAF50)
                        : CupertinoColors.systemGrey4.resolveFrom(context),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 44),
        ],
      ),
    );
  }
}

// ── Bottom navigation buttons ─────────────────────────────────────────────────

class _BottomButtons extends StatelessWidget {
  final String primaryLabel;
  final VoidCallback onPrimary;

  const _BottomButtons({
    required this.primaryLabel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      child: SizedBox(
        width: double.infinity,
        child: CupertinoButton(
          color: const Color(0xFF4CAF50),
          borderRadius: BorderRadius.circular(14),
          onPressed: onPrimary,
          child: Text(
            primaryLabel,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: CupertinoColors.white,
            ),
          ),
        ),
      ),
    );
  }
}

// ── Step scaffold helper ──────────────────────────────────────────────────────

class _StepScaffold extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  const _StepScaffold({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(emoji, style: const TextStyle(fontSize: 48)),
                const SizedBox(height: 16),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.systemGrey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),
                body,
              ],
            ),
          ),
        ),
        _BottomButtons(
          primaryLabel: primaryLabel,
          onPrimary: onPrimary,
        ),
      ],
    );
  }
}

// ── Step 0: Name ──────────────────────────────────────────────────────────────

class _StepName extends StatelessWidget {
  final TextEditingController nameController;
  final VoidCallback onSearch;
  final VoidCallback onNext;

  const _StepName({
    required this.nameController,
    required this.onSearch,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _StepScaffold(
      emoji: '🌱',
      title: l.createPlantStep1Title,
      subtitle: l.createPlantStep1Subtitle,
      primaryLabel: l.actionNext,
      onPrimary: onNext,
      body: Column(
        children: [
          GestureDetector(
            onTap: onSearch,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF4CAF50).withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.search,
                      color: Color(0xFF4CAF50), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.createPlantSearchButton,
                      style: const TextStyle(
                        color: Color(0xFF4CAF50),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(CupertinoIcons.chevron_right,
                      color: Color(0xFF4CAF50), size: 16),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
  child: Container(height: 0.5, color: CupertinoColors.systemGrey4.resolveFrom(context)),
),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  l.createPlantOrManualLabel,
                  style: TextStyle(
                    fontSize: 13,
                    color: CupertinoColors.systemGrey.withValues(alpha: 0.8),
                  ),
                ),
              ),
              Expanded(
  child: Container(height: 0.5, color: CupertinoColors.systemGrey4.resolveFrom(context)),
),
            ],
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: nameController,
            placeholder: l.createPlantNameHint,
            padding: const EdgeInsets.all(14),
            autofocus: false,
            textCapitalization: TextCapitalization.sentences,
            decoration: BoxDecoration(
              color: kCardBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CupertinoColors.systemGrey4.resolveFrom(context)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 1: Watering ──────────────────────────────────────────────────────────

class _StepWatering extends StatelessWidget {
  final int intervalDays;
  final DateTime? lastWatered;
  final ValueChanged<int> onIntervalChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onNext;

  const _StepWatering({
    required this.intervalDays,
    required this.lastWatered,
    required this.onIntervalChanged,
    required this.onPickDate,
    required this.onClearDate,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fmt = DateFormat('dd. MMM yyyy', locale);

    return _StepScaffold(
      emoji: '💧',
      title: l.createPlantStep2Title,
      subtitle: l.createPlantStep2Subtitle,
      primaryLabel: l.actionNext,
      onPrimary: onNext,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date picker row
          GestureDetector(
            onTap: onPickDate,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: lastWatered != null
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.5)
                      : CupertinoColors.systemGrey4.resolveFrom(context),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    size: 20,
                    color: lastWatered != null
                        ? const Color(0xFF4CAF50)
                        : CupertinoColors.systemGrey,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      lastWatered != null
                          ? fmt.format(lastWatered!)
                          : l.createPlantPickDate,
                      style: TextStyle(
                        color: lastWatered != null
                            ? CupertinoColors.label
                            : CupertinoColors.systemGrey,
                      ),
                    ),
                  ),
                  if (lastWatered != null)
                    GestureDetector(
                      onTap: onClearDate,
                      child: const Icon(
                        CupertinoIcons.xmark_circle_fill,
                        size: 18,
                        color: CupertinoColors.systemGrey3,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),
          Text(
            l.createPlantWateringIntervalLabel,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kCardBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CupertinoColors.systemGrey4.resolveFrom(context)),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.drop,
                    color: Color(0xFF4CAF50), size: 20),
                const SizedBox(width: 10),
                Text('$intervalDays ${l.createPlantDaysUnit}'),
                const Spacer(),
                CupertinoStepper(
                  value: intervalDays.toDouble(),
                  min: 1,
                  max: 30,
                  stepValue: 1,
                  onChanged: (v) => onIntervalChanged(v.toInt()),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Step 2: Fertilizing ───────────────────────────────────────────────────────

class _StepFertilizing extends StatelessWidget {
  final bool enabled;
  final int intervalWeeks;
  final DateTime? lastFertilized;
  final ValueChanged<bool> onToggle;
  final ValueChanged<int> onIntervalChanged;
  final VoidCallback onPickDate;
  final VoidCallback onClearDate;
  final VoidCallback onNext;

  const _StepFertilizing({
    required this.enabled,
    required this.intervalWeeks,
    required this.lastFertilized,
    required this.onToggle,
    required this.onIntervalChanged,
    required this.onPickDate,
    required this.onClearDate,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final fmt = DateFormat('dd. MMM yyyy', locale);

    return _StepScaffold(
      emoji: '🌿',
      title: l.createPlantStep3Title,
      subtitle: l.createPlantStep3Subtitle,
      primaryLabel: l.actionNext,
      onPrimary: onNext,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: kCardBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: enabled
                    ? CupertinoColors.systemOrange.withValues(alpha: 0.4)
                    : CupertinoColors.systemGrey4.resolveFrom(context),
              ),
            ),
            child: Row(
              children: [
                const Icon(CupertinoIcons.sparkles,
                    color: CupertinoColors.systemOrange, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l.createPlantFertilizingToggle,
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
                CupertinoSwitch(
                  value: enabled,
                  activeTrackColor: CupertinoColors.systemOrange,
                  onChanged: onToggle,
                ),
              ],
            ),
          ),
          if (enabled) ...[
            const SizedBox(height: 20),
            Text(
              l.createPlantFertilizingIntervalLabel,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey4.resolveFrom(context)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.calendar,
                      color: CupertinoColors.systemOrange, size: 20),
                  const SizedBox(width: 10),
                  Text('$intervalWeeks ${l.createPlantWeeksUnit}'),
                  const Spacer(),
                  CupertinoStepper(
                    value: intervalWeeks.toDouble(),
                    min: 1,
                    max: 12,
                    stepValue: 1,
                    onChanged: (v) => onIntervalChanged(v.toInt()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l.createPlantLastFertilizedLabel,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onPickDate,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: kCardBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: lastFertilized != null
                        ? CupertinoColors.systemOrange
                            .withValues(alpha: 0.5)
                        : CupertinoColors.systemGrey4.resolveFrom(context),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 20,
                      color: lastFertilized != null
                          ? CupertinoColors.systemOrange
                          : CupertinoColors.systemGrey,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        lastFertilized != null
                            ? fmt.format(lastFertilized!)
                            : l.createPlantPickDate,
                        style: TextStyle(
                          color: lastFertilized != null
                              ? CupertinoColors.label
                              : CupertinoColors.systemGrey,
                        ),
                      ),
                    ),
                    if (lastFertilized != null)
                      GestureDetector(
                        onTap: onClearDate,
                        child: const Icon(
                          CupertinoIcons.xmark_circle_fill,
                          size: 18,
                          color: CupertinoColors.systemGrey3,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Step 3: Location ──────────────────────────────────────────────────────────

class _StepLocation extends ConsumerWidget {
  final String? selectedLocationId;
  final ValueChanged<String> onSelected;
  final VoidCallback onDeselect;
  final VoidCallback onNext;

  const _StepLocation({
    required this.selectedLocationId,
    required this.onSelected,
    required this.onDeselect,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l = AppLocalizations.of(context);
    final locationsFuture = ref.read(locationRepositoryProvider).getAll();

    return _StepScaffold(
      emoji: '📍',
      title: l.createPlantStep4Title,
      subtitle: l.createPlantStep4Subtitle,
      primaryLabel: l.actionNext,
      onPrimary: onNext,
      body: FutureBuilder<List<Location>>(
        future: locationsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }
          final locations = snapshot.data!;
          if (locations.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: CupertinoColors.systemGrey4.resolveFrom(context)),
              ),
              child: Row(
                children: [
                  const Icon(CupertinoIcons.info_circle,
                      color: CupertinoColors.systemGrey, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l.createPlantNoLocations,
                      style: const TextStyle(
                          color: CupertinoColors.systemGrey, fontSize: 14),
                    ),
                  ),
                ],
              ),
            );
          }
          return Column(
            children: [
              _locationItem(
                context: context,
                icon: CupertinoIcons.xmark_circle,
                label: l.noLocation,
                isSelected: selectedLocationId == null,
                onTap: onDeselect,
              ),
              const SizedBox(height: 10),
              ...locations.map((loc) => _locationItem(
                    context: context,
                    icon: CupertinoIcons.map_pin_ellipse,
                    label: loc.name,
                    isSelected: selectedLocationId == loc.id,
                    onTap: () => onSelected(loc.id),
                  )),
            ],
          );
        },
      ),
    );
  }
}

// ── Location item helper ──────────────────────────────────────────────────────

Widget _locationItem({
  required BuildContext context,
  required IconData icon,
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isSelected
            ? const Color(0xFF4CAF50).withValues(alpha: 0.12)
            : kCardBackground.resolveFrom(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected
              ? const Color(0xFF4CAF50).withValues(alpha: 0.5)
              : CupertinoColors.systemGrey4.resolveFrom(context),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: isSelected
                ? const Color(0xFF4CAF50)
                : CupertinoColors.systemGrey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 15,
                fontWeight:
                    isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? const Color(0xFF4CAF50)
                    : CupertinoColors.label.resolveFrom(context),
              ),
            ),
          ),
          if (isSelected)
            const Icon(
              CupertinoIcons.checkmark_alt,
              size: 18,
              color: Color(0xFF4CAF50),
            ),
        ],
      ),
    ),
  );
}

// ── Step 4: Details ───────────────────────────────────────────────────────────

class _StepDetails extends StatelessWidget {
  final String? imagePath;
  final TextEditingController notesController;
  final VoidCallback onPickImage;
  final VoidCallback onSave;

  const _StepDetails({
    required this.imagePath,
    required this.notesController,
    required this.onPickImage,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return _StepScaffold(
      emoji: '🎉',
      title: l.createPlantStep5Title,
      subtitle: l.createPlantStep5Subtitle,
      primaryLabel: l.createPlantSaveButton,
      onPrimary: onSave,
      body: Column(
        children: [
          GestureDetector(
            onTap: onPickImage,
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                color: kCardBackground.resolveFrom(context),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: imagePath != null
                      ? const Color(0xFF4CAF50).withValues(alpha: 0.4)
                      : CupertinoColors.systemGrey4.resolveFrom(context),
                ),
              ),
              child: imagePath != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.file(
                        File(imagePath!),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
                      ),
                    )
                  : const _ImagePlaceholder(),
            ),
          ),
          const SizedBox(height: 16),
          CupertinoTextField(
            controller: notesController,
            placeholder: l.createPlantNotesHint,
            padding: const EdgeInsets.all(14),
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            decoration: BoxDecoration(
              color: kCardBackground.resolveFrom(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CupertinoColors.systemGrey4.resolveFrom(context)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Toast ─────────────────────────────────────────────────────────────────────

class _Toast extends StatefulWidget {
  final String message;
  final VoidCallback onDone;

  const _Toast({required this.message, required this.onDone});

  @override
  State<_Toast> createState() => _ToastState();
}

class _ToastState extends State<_Toast> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 220),
  );
  late final Animation<double> _anim = CurvedAnimation(
    parent: _ctrl,
    curve: Curves.easeOut,
  );

  @override
  void initState() {
    super.initState();
    _ctrl.forward();
    Future.delayed(const Duration(milliseconds: 1800), () async {
      if (mounted) await _ctrl.reverse();
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 120,
      left: 32,
      right: 32,
      child: FadeTransition(
        opacity: _anim,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.4),
            end: Offset.zero,
          ).animate(_anim),
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: CupertinoColors.black.withValues(alpha: 0.78),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: CupertinoColors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Image placeholder ─────────────────────────────────────────────────────────

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(CupertinoIcons.camera, size: 32, color: CupertinoColors.systemGrey),
        const SizedBox(height: 8),
        Text(
          l.createPlantPhotoLabel,
          style: const TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
        ),
      ],
    );
  }
}
