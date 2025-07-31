import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class LocationSelector extends StatelessWidget {
  final String selectedLocation;
  final ValueChanged<String> onLocationSelected;

  const LocationSelector({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final locations = ['HQ', 'Terminal A', 'Maintenance Facility', 'IT'];
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        icon: const Icon(Icons.location_on, color: AppColors.primary),
        label: Text(selectedLocation.isEmpty ? 'Location' : selectedLocation),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.primary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () async {
          final selected = await showDialog<String>(
            context: context,
            builder: (context) => SimpleDialog(
              title: const Text('Select Location'),
              children: locations
                  .map((loc) => SimpleDialogOption(
                        child: Text(loc),
                        onPressed: () => Navigator.pop(context, loc),
                      ))
                  .toList(),
            ),
          );
          if (selected != null) {
            onLocationSelected(selected);
          }
        },
      ),
    );
  }
}