import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Use')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Use',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: December 19, 2024',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'Acceptance of Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By using Cortex Pocket, you agree to these terms. If you do not agree, please do not use the application.',
            ),
            SizedBox(height: 16),
            Text(
              'Use License',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cortex Pocket is licensed under the MIT License. You may use, modify, and distribute the software according to the license terms.',
            ),
            SizedBox(height: 16),
            Text(
              'Acceptable Use',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You agree to use Cortex Pocket responsibly:\n'
              '• Do not use for illegal activities\n'
              '• Do not attempt to harm or exploit the system\n'
              '• Respect intellectual property rights\n'
              '• Use AI-generated content responsibly',
            ),
            SizedBox(height: 16),
            Text(
              'AI Content Disclaimer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'AI-generated content may be inaccurate, biased, or inappropriate. Users are responsible for verifying and using AI outputs appropriately.',
            ),
            SizedBox(height: 16),
            Text(
              'Limitation of Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cortex Pocket is provided "as is" without warranties. We are not liable for any damages arising from use of the application.',
            ),
          ],
        ),
      ),
    );
  }
}