import 'package:geolocator/geolocator.dart';

Future<Position> getUserLocation() async {
  // Check if location service is enabled
  bool serviceEnabled =
      await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    throw Exception('Please enable location services.');
  }

  // Check permission
  LocationPermission permission =
      await Geolocator.checkPermission();

  // Request permission if not granted
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
  }

  // User denied permission
  if (permission == LocationPermission.denied) {
    throw Exception('Location permission denied.');
  }

  // User permanently denied permission
  if (permission == LocationPermission.deniedForever) {
    throw Exception(
      'Location permission permanently denied. Please enable it from Settings.',
    );
  }

  // Get GPS coordinates
  return await Geolocator.getCurrentPosition();
}