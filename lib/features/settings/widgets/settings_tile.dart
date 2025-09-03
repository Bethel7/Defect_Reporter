import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingsTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = colorScheme.brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
            child: Row(
              children: [
                FaIcon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style:
                        theme.textTheme.bodyLarge?.copyWith(
                          fontSize: 16,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ) ??
                        TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurface,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                FaIcon(
                  FontAwesomeIcons.chevronRight,
                  color: colorScheme.onSurface,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
