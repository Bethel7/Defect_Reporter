import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MainBottomAppBar extends StatelessWidget {
  const MainBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 38;
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.accent.withOpacity(0.10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10), 
                blurRadius: 32,
                spreadRadius: 2,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Icon
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            Icons.home,
                            size: iconSize,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/home');
                          },
                          tooltip: 'Home',
                        ),
                      ),
                    ),
                  ),
                ),
                // Add Icon
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        width: iconSize + 8,
                        height: iconSize + 8,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.30),
                              blurRadius: 24,
                              spreadRadius: 1,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          iconSize: 28,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            Navigator.pushNamed(context, '/report-form');
                          },
                          tooltip: 'New Report',
                        ),
                      ),
                    ),
                  ),
                ),
                // Assignment Icon
                Expanded(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          icon: const Icon(
                            Icons.assignment,
                            size: iconSize,
                            color: AppColors.primary,
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, '/my-reports');
                          },
                          tooltip: 'My Reports',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}