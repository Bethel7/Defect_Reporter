import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => Navigator. popAndPushNamed(context, '/settings'),
            tooltip: 'Back',
          ),
        ),
        title: Semantics(
          label: 'Support Page',
          header: true,
          child: Text(
            'Support',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
      
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              label: 'Need Help?',
              header: true,
              child: Text(
                'Need Help?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              label: 'Support contact information',
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                color: AppColors.primary.withOpacity(0.08),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'For support, please contact the IT helpdesk at:',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 12),
                      SelectableText(
                        'Email: support@ethiopianairlines.com',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 8),
                      SelectableText(
                        'Phone: +251 11 665 6666',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Or visit the HR office for in-person assistance.',
                        style: TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
