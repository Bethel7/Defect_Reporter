import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import 'profile_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Navigator.pop(context),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Profile Page',
          header: true,
          child: Text(
            'User Profile',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            Center(
              child: CircleAvatar(
                radius: 54,
                backgroundColor: AppColors.primary.withOpacity(0.15),
                child: const Icon(
                  Icons.person,
                  size: 64,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(height: 32),
            _ProfileInfoRow(label: 'Name', value: profile.name),
            const SizedBox(height: 18),
            _ProfileInfoRow(label: 'Employee ID', value: profile.employeeId),
            const SizedBox(height: 18),
            _ProfileInfoRow(label: 'Email', value: profile.email),
          ],
        ),
      ),
    );
  }
}

class _ProfileInfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _ProfileInfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: '$label: $value',
      child: Row(
        children: [
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
