import '../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';

//import 'package:flutter_riverpod/flutter_riverpod.dart';
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logo.png', height: 150),
            const SizedBox(height: 16),
            const Text(
              'Issue Reporter',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Ethiopian Airlines', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.primary,
              child: IconButton(
                icon: const Icon(Icons.arrow_forward, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
