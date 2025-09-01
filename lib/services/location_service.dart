import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class LocationService {
  Future<Position?> getCurrentLocation(BuildContext context) async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Prompt the user to enable location services
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Enable Location Services'),
            content: const Text(
              'Location services are disabled. Please enable them in your device settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
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
        return null;
      }
      if (permission == LocationPermission.deniedForever) {
        return null;
      }
      if (permission == LocationPermission.unableToDetermine) {
        return null;
      }

      // Permissions granted, get location
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      return null;
    }
  }
}
