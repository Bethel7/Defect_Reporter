import 'package:flutter/material.dart';
import '../../report/data/location_model.dart';

class LocationSelector extends StatefulWidget {
  final List<LocationModel> locations;
  final int? selectedLocationId;
  final String? selectedLocationName;
  final void Function(int locationId, String locationName) onLocationSelected;
  final Future<void> Function(String name)? onNewLocationAdded;
  final String? errorText;
  final TextStyle? textStyle;

  const LocationSelector({
    super.key,
    required this.locations,
    required this.selectedLocationId,
    required this.selectedLocationName,
    required this.onLocationSelected,
    this.onNewLocationAdded,
    this.errorText,
    this.textStyle,
  });

  @override
  State<LocationSelector> createState() => _LocationSelectorState();
}

class _LocationSelectorState extends State<LocationSelector> {
  final TextEditingController _controller = TextEditingController();
  List<LocationModel> _filteredLocations = [];
  bool _showDropdown = false;
  bool _loading = false;
  FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.selectedLocationName ?? '';
    _filteredLocations = widget.locations;
    _controller.addListener(_filterLocations);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus &&
          _controller.text.isNotEmpty &&
          _filteredLocations.isNotEmpty) {
        setState(() {
          _showDropdown = true;
        });
      } else if (!_focusNode.hasFocus) {
        setState(() {
          _showDropdown = false;
        });
      }
    });
  }

  void _filterLocations() {
    setState(() {
      _filteredLocations = widget.locations
          .where(
            (loc) => loc.locationName.toLowerCase().contains(
              _controller.text.toLowerCase(),
            ),
          )
          .toList();
      _showDropdown =
          _controller.text.isNotEmpty &&
          _filteredLocations.isNotEmpty &&
          _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputText = _controller.text;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
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
              borderSide: BorderSide(color: Colors.blue),
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
              _showDropdown =
                  val.isNotEmpty &&
                  _filteredLocations.isNotEmpty &&
                  _focusNode.hasFocus;
            });
          },
          onTap: () {
            if (_controller.text.isNotEmpty && _filteredLocations.isNotEmpty) {
              setState(() {
                _showDropdown = true;
              });
            }
          },
          onFieldSubmitted: (val) async {
            final match = widget.locations.firstWhere(
              (loc) => loc.locationName.toLowerCase() == val.toLowerCase(),
              orElse: () => LocationModel(locationId: -1, locationName: ''),
            );
            if (match.locationId != -1) {
              widget.onLocationSelected(match.locationId, match.locationName);
            } else if (val.trim().isNotEmpty &&
                widget.onNewLocationAdded != null) {
              setState(() => _loading = true);
              try {
                await widget.onNewLocationAdded!(val.trim());
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
                final locName = loc.locationName;
                final lowerLoc = locName.toLowerCase();
                final lowerInput = inputText.toLowerCase();
                final matchIndex = lowerLoc.indexOf(lowerInput);
                if (matchIndex >= 0 && lowerInput.isNotEmpty) {
                  // Highlight the matching part
                  return ListTile(
                    title: RichText(
                      text: TextSpan(
                        style:
                            widget.textStyle ??
                            DefaultTextStyle.of(context).style,
                        children: [
                          TextSpan(text: locName.substring(0, matchIndex)),
                          TextSpan(
                            text: locName.substring(
                              matchIndex,
                              matchIndex + lowerInput.length,
                            ),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: locName.substring(
                              matchIndex + lowerInput.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      _controller.text = loc.locationName;
                      widget.onLocationSelected(
                        loc.locationId,
                        loc.locationName,
                      );
                      setState(() {
                        _showDropdown = false;
                      });
                      FocusScope.of(context).unfocus();
                    },
                  );
                } else {
                  return ListTile(
                    title: Text(loc.locationName, style: widget.textStyle),
                    onTap: () {
                      _controller.text = loc.locationName;
                      widget.onLocationSelected(
                        loc.locationId,
                        loc.locationName,
                      );
                      setState(() {
                        _showDropdown = false;
                      });
                      FocusScope.of(context).unfocus();
                    },
                  );
                }
              }).toList(),
            ),
          ),
      ],
    );
  }
}
