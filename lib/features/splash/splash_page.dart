import '../../core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/presentation/login_provider.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> {
  bool _navigated = false;
  bool _hasSession = false;

  @override
  void initState() {
    super.initState();
    _restoreSession();
  }

  Future<void> _restoreSession() async {
    await ref.read(loginProvider.notifier).restoreUserSession(ref);
    final user = ref.read(currentUserProvider);
    if (!mounted) return;
    setState(() {
      _hasSession = user != null;
    });
    if (!_navigated && _hasSession) {
      _navigated = true;
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

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
            if (!_hasSession)
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
