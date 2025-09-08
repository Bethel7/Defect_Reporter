import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

enum FilterDropdownAlignment { left, center, right }

class FilterDropdown extends StatefulWidget {
  final String label;
  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;
  final FilterDropdownAlignment alignment;

  const FilterDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.alignment = FilterDropdownAlignment.center,
  });

  @override
  State<FilterDropdown> createState() => _FilterDropdownState();
}

class _FilterDropdownState extends State<FilterDropdown> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;

  void _showDropdown() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final myColors = theme.extension<MyColors>();
    final isDark = colorScheme.brightness == Brightness.dark;

    // Make dropdown 1.3x the field width for better visibility
    final double dropdownWidth = size.width * 1.3;
    double left = offset.dx;
    if (widget.alignment == FilterDropdownAlignment.center) {
      left = offset.dx + size.width / 2 - dropdownWidth / 2;
    } else if (widget.alignment == FilterDropdownAlignment.right) {
      left = offset.dx + size.width - dropdownWidth;
    }

    // Always use a dark background in dark mode, fallback to theme surface if needed
    Color dropdownBg = isDark
        ? (myColors?.background ?? colorScheme.surface)
        : (myColors?.background ?? Colors.white);
    // Always use white text in dark mode for readability
    Color dropdownText = isDark
        ? Colors.white
        : (myColors?.text ?? Colors.black);
    Color selectedTileColor = isDark
        ? colorScheme.primary.withOpacity(0.18)
        : Colors.grey[200]!;

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: _removeDropdown,
        child: Stack(
          children: [
            Positioned(
              left: left,
              top: offset.dy + size.height + 2,
              width: dropdownWidth,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, 0),
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      color: dropdownBg,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(isDark ? 0.18 : 0.08),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    constraints: BoxConstraints(
                      minWidth: dropdownWidth,
                      maxWidth: dropdownWidth,
                      maxHeight: 300,
                    ),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      children: widget.items.map((item) {
                        final isSelected = item == widget.value;
                        return ListTile(
                          title: Text(
                            item,
                            style: TextStyle(
                              fontSize: 15,
                              color: isSelected
                                  ? colorScheme.primary
                                  : dropdownText,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                          selected: isSelected,
                          selectedTileColor: selectedTileColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          onTap: () {
                            _removeDropdown();
                            if (item != widget.value) {
                              widget.onChanged(item);
                            }
                          },
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(_overlayEntry!);
  }

  void _removeDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _removeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final myColors = theme.extension<MyColors>();
    final isDark = colorScheme.brightness == Brightness.dark;
    Color labelColor = isDark
        ? (myColors?.text ?? Colors.white)
        : (myColors?.primaryDark ?? Colors.black);
    Color valueColor = isDark
        ? (myColors?.text ?? Colors.white)
        : (myColors?.text ?? Colors.black);
    Color borderColor = isDark
        ? (myColors?.primaryDark ?? colorScheme.primary)
        : (myColors?.primary ?? colorScheme.primary);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: () {
          if (_overlayEntry == null) {
            _showDropdown();
          } else {
            _removeDropdown();
          }
        },
        child: InputDecorator(
          decoration: InputDecoration(
            labelText: widget.label,
            labelStyle: TextStyle(
              color: labelColor,
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: borderColor, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(
                color: borderColor.withOpacity(0.7),
                width: 1.2,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide(color: borderColor, width: 1.5),
            ),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.value,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: valueColor),
                ),
              ),
              Icon(Icons.arrow_drop_down, color: valueColor),
            ],
          ),
        ),
      ),
    );
  }
}
