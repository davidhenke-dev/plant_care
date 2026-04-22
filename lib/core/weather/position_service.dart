import 'package:geolocator/geolocator.dart';

class PositionService {
  Future<Position> getCurrentPosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Ortungsdienste deaktiviert');

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Standortberechtigung verweigert');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('Standortberechtigung dauerhaft verweigert');
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.low,
      ),
    );
  }
}
