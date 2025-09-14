import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/text_styles.dart';

class NotificationToggleTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? description;

  const NotificationToggleTile({
    super.key,
    required this.label,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = isDark ? theme.cardColor : Colors.white;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.18)
        : Colors.black.withOpacity(0.03);
    final textColor = isDark
        ? theme.textTheme.bodyLarge?.color ?? Colors.white
        : AppColors.text;
    final descColor = isDark ? Colors.white70 : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary, size: 22),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    label,
                    style: TextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ),
                Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            if (description != null) ...[
              const SizedBox(height: 6),
              Text(
                description!,
                style: TextStyle(fontSize: 13, color: descColor),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
