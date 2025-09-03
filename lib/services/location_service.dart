import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showMessage(
          context,
          'Location services are disabled. Please enable them in your device settings.',
        );
        return null;
      }

      // Check permission status
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      // Handle all possible permission states
      if (permission == LocationPermission.denied) {
        _showMessage(
          context,
          'Location permission denied. Please allow access in your device settings.',
        );
        return null;
      }
      if (permission == LocationPermission.deniedForever) {
        _showMessage(
          context,
          'Location permission permanently denied. Please enable it in your device settings.',
        );
        return null;
      }
      if (permission == LocationPermission.unableToDetermine) {
        _showMessage(context, 'Unable to determine location permission.');
        return null;
      }

      // Permissions granted, get location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _showMessage(context, 'Failed to get location. Please try again.');
      return null;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
