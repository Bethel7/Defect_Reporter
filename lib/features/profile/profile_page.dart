import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Example user data
  String name = 'John Doe';
  String employeeId = 'ET12345';
  String jobTitle = 'Maintenance Engineer';
  String department = 'Engineering';
  String email = 'unknown@ethiopianairlines.com';
  String phone = '+251 911 123456';

  bool isUpdating = false;

  // Simulate fetching email from backend using employee ID
  Future<void> updateEmailFromEmployeeId() async {
    setState(() => isUpdating = true);
    await Future.delayed(const Duration(seconds: 1)); // Simulate network delay
    setState(() {
      email = '$employeeId@ethiopianairlines.com'; // Example logic
      isUpdating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Profile', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            // Profile picture
            Center(
              child: CircleAvatar(
                radius: 48,
                backgroundColor: AppColors.primary.withOpacity(0.2),
                child: const Icon(Icons.person, size: 64, color: AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),
            // Name
            Center(
              child: Text(
                name,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            // Employee ID
            Center(
              child: Text(
                'Employee ID: $employeeId',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 24),
            // Job Title & Department
            ListTile(
              leading: const Icon(Icons.badge, color: AppColors.primary),
              title: Text(jobTitle),
              subtitle: Text(department),
            ),
            // Email
            ListTile(
              leading: const Icon(Icons.email, color: AppColors.primary),
              title: Text(email),
              trailing: isUpdating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.refresh, color: AppColors.primary),
                      tooltip: 'Update Email',
                      onPressed: updateEmailFromEmployeeId,
                    ),
            ),
            // Phone
            ListTile(
              leading: const Icon(Icons.phone, color: AppColors.primary),
              title: Text(phone),
            ),
          ],
        ),
      ),
    );
  }
}