import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSelector extends StatefulWidget {
  final String? selectedLocation;
  final ValueChanged<String> onLocationSelected;
  final String? errorText;

  const LocationSelector({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
    this.errorText,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final TextEditingController _controller = TextEditingController();
  List<String> _locations = [];
  List<String> _filteredLocations = [];

  @override
  void initState() {
    super.initState();
    _loadLocations();
    _controller.text = widget.selectedLocation ?? '';
    _controller.addListener(_filterLocations);
  }

  Future<void> _loadLocations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _locations = prefs.getStringList('locations') ?? ['HQ', 'Terminal A', 'Maintenance Facility'];
      _filteredLocations = _locations;
    });
  }

  Future<void> _saveLocation(String location) async {
    final prefs = await SharedPreferences.getInstance();
    if (!_locations.contains(location)) {
      setState(() {
        _locations.add(location);
        _filteredLocations = _locations;
      });
      await prefs.setStringList('locations', _locations);
    }
  }

  void _filterLocations() {
    setState(() {
      _filteredLocations = _locations
          .where((loc) => loc.toLowerCase().contains(_controller.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
            labelText: 'Location',
            border: const OutlineInputBorder(),
            errorText: widget.errorText,
          ),
          onChanged: (val) {
            widget.onLocationSelected(val);
            _filterLocations();
          },
          onFieldSubmitted: (val) async {
            await _saveLocation(val);
            widget.onLocationSelected(val);
            _filterLocations();
          },
        ),
        if (_filteredLocations.isNotEmpty && _controller.text.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            constraints: const BoxConstraints(maxHeight: 180),
            child: ListView(
              shrinkWrap: true,
              children: _filteredLocations.map((loc) {
                return ListTile(
                  title: Text(loc),
                  onTap: () async {
                    _controller.text = loc;
                    widget.onLocationSelected(loc);
                    await _saveLocation(loc);
                    FocusScope.of(context).unfocus();
                  },
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}