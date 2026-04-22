import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import '../../../core/weather/position_service.dart';
import '../../../l10n/app_localizations.dart';

class PickedLocation {
  final double lat;
  final double lon;
  final String? cityName;
  const PickedLocation(this.lat, this.lon, this.cityName);
}

class MapPickerScreen extends StatefulWidget {
  final double? initialLat;
  final double? initialLon;

  const MapPickerScreen({super.key, this.initialLat, this.initialLon});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  late final MapController _mapController;
  late LatLng _center;
  String? _cityName;
  bool _isGeocoding = false;
  bool _isLocating = false;
  Timer? _geocodeTimer;

  // Fallback center while GPS is loading
  static const _fallback = LatLng(48.1351, 11.5820);

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _center = widget.initialLat != null
        ? LatLng(widget.initialLat!, widget.initialLon!)
        : _fallback;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triggerGeocode(_center);
      // If no initial coords given → jump to GPS automatically
      if (widget.initialLat == null) _goToMyLocation(initial: true);
    });
  }

  @override
  void dispose() {
    _geocodeTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  Future<void> _goToMyLocation({bool initial = false}) async {
    if (_isLocating) return;
    setState(() => _isLocating = true);
    try {
      final pos = await PositionService().getCurrentPosition();
      if (!mounted) return;
      final gps = LatLng(pos.latitude, pos.longitude);
      _mapController.move(gps, 12);
      setState(() => _center = gps);
      _triggerGeocode(gps);
    } catch (_) {
      // GPS unavailable – stay on current center
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  void _triggerGeocode(LatLng position) {
    _geocodeTimer?.cancel();
    setState(() => _isGeocoding = true);
    _geocodeTimer = Timer(const Duration(milliseconds: 700), () async {
      final city = await _reverseGeocode(position.latitude, position.longitude);
      if (mounted) {
        setState(() {
          _cityName = city;
          _isGeocoding = false;
        });
      }
    });
  }

  Future<String?> _reverseGeocode(double lat, double lon) async {
    try {
      final uri =
          Uri.parse('https://nominatim.openstreetmap.org/reverse').replace(
        queryParameters: {
          'lat': lat.toStringAsFixed(6),
          'lon': lon.toStringAsFixed(6),
          'format': 'json',
          'accept-language': 'de',
        },
      );
      final response = await http.get(
        uri,
        headers: {'User-Agent': 'PlantCareApp/1.0'},
      );
      if (response.statusCode != 200) return null;
      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final address = json['address'] as Map<String, dynamic>?;
      return address?['city'] as String? ??
          address?['town'] as String? ??
          address?['village'] as String? ??
          address?['county'] as String? ??
          json['display_name'] as String?;
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l.mapPickerTitle),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(CupertinoIcons.xmark),
        ),
      ),
      child: Stack(
        children: [
          // ── Map ────────────────────────────────────────────────────────────
          Positioned.fill(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _center,
                initialZoom: 11,
                onMapEvent: (event) {
                  if (event is MapEventMoveEnd ||
                      event is MapEventDoubleTapZoom) {
                    final newCenter = _mapController.camera.center;
                    setState(() => _center = newCenter);
                    _triggerGeocode(newCenter);
                  }
                },
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.plant_care',
                ),
              ],
            ),
          ),

          // ── Center pin (tip aligned to map center) ─────────────────────────
          IgnorePointer(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drop shadow via container
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      // Shadow ellipse under pin tip
                      Padding(
                        padding: const EdgeInsets.only(top: 36),
                        child: Container(
                          width: 12,
                          height: 6,
                          decoration: BoxDecoration(
                            color: CupertinoColors.black.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ),
                      const Icon(
                        CupertinoIcons.map_pin,
                        size: 44,
                        color: Color(0xFF4CAF50),
                      ),
                    ],
                  ),
                  // This SizedBox makes the Column center sit at pin tip:
                  // icon height = 44, so spacing = 44 puts tip at Column center
                  const SizedBox(height: 44),
                ],
              ),
            ),
          ),

          // ── My location button ─────────────────────────────────────────────
          Positioned(
            right: 16,
            bottom: 200,
            child: GestureDetector(
              onTap: () => _goToMyLocation(),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: _isLocating
                    ? const Center(
                        child: CupertinoActivityIndicator(radius: 10))
                    : const Icon(
                        CupertinoIcons.location_fill,
                        size: 20,
                        color: Color(0xFF4CAF50),
                      ),
              ),
            ),
          ),

          // ── Bottom card ────────────────────────────────────────────────────
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              top: false,
              child: Container(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemBackground.resolveFrom(context),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: CupertinoColors.black.withValues(alpha: 0.15),
                      blurRadius: 16,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.map_pin,
                            size: 16, color: Color(0xFF4CAF50)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _isGeocoding
                              ? Text(
                                  l.mapPickerSearching,
                                  style: const TextStyle(
                                    color: CupertinoColors.systemGrey,
                                    fontSize: 14,
                                  ),
                                )
                              : Text(
                                  _cityName ??
                                      '${_center.latitude.toStringAsFixed(4)}, '
                                          '${_center.longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_center.latitude.toStringAsFixed(5)}, '
                      '${_center.longitude.toStringAsFixed(5)}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        color: const Color(0xFF4CAF50),
                        borderRadius: BorderRadius.circular(14),
                        onPressed: _isGeocoding
                            ? null
                            : () => Navigator.of(context).pop(
                                  PickedLocation(
                                    _center.latitude,
                                    _center.longitude,
                                    _cityName,
                                  ),
                                ),
                        child: Text(
                          l.mapPickerConfirm,
                          style: const TextStyle(
                            color: CupertinoColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
