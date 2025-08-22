import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MainBottomAppBar extends StatelessWidget {
  const MainBottomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 28;

    String? currentRoute = ModalRoute.of(context)?.settings.name;
    // Fallback for MaterialPageRoute
    if (currentRoute == null) {
      final route = ModalRoute.of(context);
      if (route != null &&
          route.settings.arguments is Map &&
          (route.settings.arguments as Map).containsKey('routeName')) {
        currentRoute =
            (route.settings.arguments as Map)['routeName'] as String?;
      }
    }

    Widget navIcon({
      required IconData icon,
      required String route,
      required String tooltip,
    }) {
      return Container(
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
        ),
        child: IconButton(
          icon: Icon(
            icon,
            size: iconSize,
            color: Colors.white, 
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, route);
          },
          tooltip: tooltip,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
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
                    child: navIcon(
                      icon: FontAwesomeIcons.house,
                      route: '/home',
                      tooltip: 'Home',
                    ),
                  ),
                ),
                // New Report Icon
                Expanded(
                  child: Center(
                    child: navIcon(
                      icon: FontAwesomeIcons.plus,
                      route: '/report-form',
                      tooltip: 'New Report',
                    ),
                  ),
                ),
                // Cached Reports Icon
                Expanded(
                  child: Center(
                    child: navIcon(
                      icon: FontAwesomeIcons.database,
                      route: '/cached-reports',
                      tooltip: 'Cached Reports',
                    ),
                  ),
                ),
                // My Reports Icon
                Expanded(
                  child: Center(
                    child: navIcon(
                      icon: FontAwesomeIcons.clockRotateLeft,
                      route: '/my-reports',
                      tooltip: 'My Reports',
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
