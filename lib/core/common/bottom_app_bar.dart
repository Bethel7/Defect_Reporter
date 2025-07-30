import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MainBottomAppBar extends StatelessWidget {
  const MainBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 38;
    return BottomAppBar(
      color: Colors.white,
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
        child: Row(
          children: [
            // Home Icon
            IconButton(
              icon: const Icon(
                Icons.home,
                size: 42,
                color: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            const Spacer(),
            // Add Icon 
            Container(
              width: iconSize,
              height: iconSize,
              decoration:  BoxDecoration(
                color: AppColors.primary,
                
                borderRadius : BorderRadius.circular(10),
                boxShadow : [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
            ],
        ),
              child: IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                iconSize: 24,
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pushNamed(context, '/report-form');
                },
              ),
            ),
            const Spacer(),
            // Assignment Icon
            IconButton(
              icon: const Icon(
                Icons.assignment,
                size: iconSize,
                color: AppColors.primary,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/my-reports');
              },
            ),
          ],
        ),
      ),
    );
  }
}