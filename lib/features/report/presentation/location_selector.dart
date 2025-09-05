import 'package:flutter/material.dart';
import '../../report/data/location_model.dart';
import '../../../core/theme/input_borders.dart';

class LocationSelector extends StatefulWidget {
  final List<LocationModel> locations;
  final int? selectedLocationId;
  final String? selectedLocationName;
  final void Function(int locationId, String locationName) onLocationSelected;
  final Future<int> Function(String name)? onNewLocationAdded;
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
  final FocusNode _focusNode = FocusNode();

  int? _lastSelectedLocationId;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.selectedLocationName ?? '';
    _filteredLocations = widget.locations;
    _lastSelectedLocationId = widget.selectedLocationId;
    _controller.addListener(_filterLocations);
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          // If input is empty, show all locations
          _filteredLocations = _controller.text.isEmpty
              ? widget.locations
              : widget.locations
                    .where(
                      (loc) => loc.locationName.toLowerCase().contains(
                        _controller.text.toLowerCase(),
                      ),
                    )
                    .toList();
          _showDropdown = _filteredLocations.isNotEmpty;
        });
      } else {
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputText = _controller.text;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    final fieldFillColor = isDark ? colorScheme.surface : Colors.white;
    final dropdownBgColor = isDark ? colorScheme.surfaceVariant : Colors.white;
    final dropdownBorderColor = isDark
        ? colorScheme.outline.withOpacity(0.4)
        : Colors.grey.shade300;
    final textColor = isDark ? colorScheme.onSurface : const Color(0xFF252525);
    final labelColor = isDark
        ? colorScheme.onSurfaceVariant
        : const Color(0xFF717182);

    // Use InputBorders.adaptive for consistency
    final border = InputBorders.adaptive(color: Theme.of(context).dividerColor);
    final focusedBorder = InputBorders.adaptive(color: colorScheme.primary);
    final errorBorder = InputBorders.adaptive(
      color: colorScheme.error,
      isError: true,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          style: widget.textStyle ?? TextStyle(color: textColor, fontSize: 15),
          decoration: InputDecoration(
            labelText: 'Location',
            labelStyle: TextStyle(color: labelColor),
            border: border,
            enabledBorder: border,
            focusedBorder: focusedBorder,
            errorBorder: errorBorder,
            focusedErrorBorder: errorBorder,
            errorText: widget.errorText,
            fillColor: fieldFillColor,
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
              _showDropdown = _filteredLocations.isNotEmpty;
              if (_lastSelectedLocationId != null) {
                _lastSelectedLocationId = null;
              }
            });
          },
          onFieldSubmitted: (val) async {
            final match = widget.locations.firstWhere(
              (loc) => loc.locationName.toLowerCase() == val.toLowerCase(),
              orElse: () => LocationModel(locationID: -1, locationName: ''),
            );
            if (match.locationID != -1) {
              widget.onLocationSelected(match.locationID, match.locationName);
              setState(() {
                _lastSelectedLocationId = match.locationID;
                _controller.text = match.locationName;
                _showDropdown = false;
              });
            } else if (val.trim().isNotEmpty &&
                widget.onNewLocationAdded != null) {
              setState(() => _loading = true);
              try {
                final newId = await widget.onNewLocationAdded!(val.trim());
                _controller.text = val.trim();
                widget.onLocationSelected(newId, val.trim());
                setState(() {
                  _lastSelectedLocationId = newId;
                });
              } catch (e) {
                // Optionally show error
              }
              setState(() => _loading = false);
              setState(() {
                _showDropdown = false;
              });
            } else {
              setState(() {
                _showDropdown = false;
              });
            }
          },
        ),
        if (_showDropdown)
          Container(
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(
              color: dropdownBgColor,
              border: Border.all(color: dropdownBorderColor),
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
                    tileColor: dropdownBgColor,
                    title: RichText(
                      text: TextSpan(
                        style:
                            (widget.textStyle ??
                                    DefaultTextStyle.of(context).style)
                                .copyWith(color: textColor),
                        children: [
                          TextSpan(text: locName.substring(0, matchIndex)),
                          TextSpan(
                            text: locName.substring(
                              matchIndex,
                              matchIndex + lowerInput.length,
                            ),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
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
                        loc.locationID,
                        loc.locationName,
                      );
                      setState(() {
                        _lastSelectedLocationId = loc.locationID;
                        _showDropdown = false;
                      });
                      FocusScope.of(context).unfocus();
                    },
                  );
                } else {
                  return ListTile(
                    tileColor: dropdownBgColor,
                    title: Text(
                      loc.locationName,
                      style:
                          (widget.textStyle ??
                                  DefaultTextStyle.of(context).style)
                              .copyWith(color: textColor),
                    ),
                    onTap: () {
                      _controller.text = loc.locationName;
                      widget.onLocationSelected(
                        loc.locationID,
                        loc.locationName,
                      );
                      setState(() {
                        _lastSelectedLocationId = loc.locationID;
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
