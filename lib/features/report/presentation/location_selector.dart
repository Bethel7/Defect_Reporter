import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationSelector extends StatefulWidget {
  final String? selectedLocation;
  final ValueChanged<String> onLocationSelected;
  final String? errorText;
  final TextStyle? textStyle;

  const LocationSelector({
    super.key,
    required this.selectedLocation,
    required this.onLocationSelected,
    this.errorText,
    this.textStyle,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final TextEditingController _controller = TextEditingController();
  List<String> _locations = [];
  List<String> _filteredLocations = [];

  bool _showDropdown = false;

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
      _locations =
          prefs.getStringList('locations') ??
          [
            'Main Hub',
            'Headquarters',
            'Aviation Academy',
            'Cargo & Logistics Center',
            'MRO Facility',
          ];
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
          .where(
            (loc) => loc.toLowerCase().contains(_controller.text.toLowerCase()),
          )
          .toList();
      _showDropdown =
          _controller.text.isNotEmpty && _filteredLocations.isNotEmpty;
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
          style: widget.textStyle,
          decoration: InputDecoration(
            labelText: 'Location',
            labelStyle: const TextStyle(color: Color(0xFF717182)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            errorText: widget.errorText,
            fillColor: Colors.white,
            filled: true,
          ),
          onChanged: (val) {
            widget.onLocationSelected(val);
            _filterLocations();
            setState(() {
              _showDropdown = val.isNotEmpty && _filteredLocations.isNotEmpty;
            });
          },
          onFieldSubmitted: (val) async {
            await _saveLocation(val);
            widget.onLocationSelected(val);
            setState(() {
              _showDropdown = false;
            });
          },
        ),
        if (_showDropdown)
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
                  title: Text(loc, style: widget.textStyle),
                  onTap: () async {
                    _controller.text = loc;
                    widget.onLocationSelected(loc);
                    await _saveLocation(loc);
                    setState(() {
                      _showDropdown = false;
                    });
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
