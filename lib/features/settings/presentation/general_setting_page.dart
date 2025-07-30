import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class GeneralSettingPage extends StatefulWidget {
  const GeneralSettingPage({super.key});

  @override
  State<GeneralSettingPage> createState() => _GeneralSettingPageState();
}

class _GeneralSettingPageState extends State<GeneralSettingPage> {
  bool notificationsEnabled = true;
  String selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('General Setting', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle, color: AppColors.accent),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text('Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Enable notifications', style: TextStyle(fontSize: 16)),
                  Switch(
                    value: notificationsEnabled,
                    activeColor: AppColors.primary,
                    onChanged: (val) {
                      setState(() {
                        notificationsEnabled = val;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Language selection', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: DropdownButtonFormField<String>(
                value: selectedLanguage,
                decoration: const InputDecoration(
                  labelText: 'Language',
                  border: InputBorder.none,
                ),
                items: const [
                  DropdownMenuItem(value: 'English', child: Text('English')),
                  DropdownMenuItem(value: 'Amharic', child: Text('Amharic')),
                ],
                onChanged: (val) {
                  setState(() {
                    selectedLanguage = val!;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            const Text('About the App', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: const Text(
                'Ethiopian Airlines Issue Reporter is designed to facilitate smooth communication between employees and internal support teams by enabling quick and efficient reporting of workplace issues. The app ensures timely handling of safety, maintenance, and technical problems, helping maintain operational excellence and employee safety across all locations, including regional airports.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}