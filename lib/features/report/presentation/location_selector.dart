import 'package:flutter/material.dart';
import '../../../services/location_api_service.dart';
import '../data/location_model.dart';

class LocationSelector extends StatefulWidget {
  final int? selectedLocationId;
  final String? selectedLocationName;
  final void Function(int locationId, String locationName) onLocationSelected;
  final String? errorText;
  final TextStyle? textStyle;

  const LocationSelector({
    Key? key,
    required this.selectedLocationId,
    required this.selectedLocationName,
    required this.onLocationSelected,
    this.errorText,
    this.textStyle,
  }) : super(key: key);

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final TextEditingController _controller = TextEditingController();
  List<LocationModel> _locations = [];
  List<LocationModel> _filteredLocations = [];
  bool _showDropdown = false;
  bool _loading = false;
  final LocationApiService _apiService = LocationApiService();

  @override
  void initState() {
    super.initState();
    _fetchLocations();
    _controller.text = widget.selectedLocationName ?? '';
    _controller.addListener(_filterLocations);
  }

  Future<void> _fetchLocations() async {
    setState(() => _loading = true);
    try {
      final locationsJson = await _apiService.getActiveLocations();
      final locations = locationsJson
          .map<LocationModel>((json) => LocationModel.fromJson(json))
          .toList();
      setState(() {
        _locations = locations;
        _filteredLocations = locations;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  void _filterLocations() {
    setState(() {
      _filteredLocations = _locations
          .where(
            (loc) => loc.locationName.toLowerCase().contains(
              _controller.text.toLowerCase(),
            ),
          )
          .toList();
      _showDropdown =
          _controller.text.isNotEmpty && _filteredLocations.isNotEmpty;
    });
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
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
          ),
          onChanged: (val) {
            _filterLocations();
            setState(() {
              _showDropdown = val.isNotEmpty && _filteredLocations.isNotEmpty;
            });
          },
          onFieldSubmitted: (val) async {
            // Check if the entered location exists
            final match = _locations.firstWhere(
              (loc) => loc.locationName.toLowerCase() == val.toLowerCase(),
              orElse: () => LocationModel(locationId: -1, locationName: ''),
            );
            if (match.locationId != -1) {
              widget.onLocationSelected(match.locationId, match.locationName);
            } else if (val.trim().isNotEmpty) {
              // Create new location
              setState(() => _loading = true);
              try {
                final newId = await _apiService.createLocation(val.trim());
                widget.onLocationSelected(newId, val.trim());
                await _fetchLocations();
                _controller.text = val.trim();
              } catch (e) {
                // Optionally show error
              }
              setState(() => _loading = false);
            }
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
                  title: Text(loc.locationName, style: widget.textStyle),
                  onTap: () {
                    _controller.text = loc.locationName;
                    widget.onLocationSelected(loc.locationId, loc.locationName);
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
