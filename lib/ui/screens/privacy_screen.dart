import 'package:flutter/material.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: December 19, 2024',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'Data Collection',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cortex Pocket is designed with privacy as a core principle. By default, all processing happens locally on your device with no data transmission.',
            ),
            SizedBox(height: 16),
            Text(
              'Local Processing',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• Chat conversations are stored locally on your device\n'
              '• AI processing happens entirely on-device\n'
              '• No data is sent to external servers by default\n'
              '• All data remains under your control',
            ),
            SizedBox(height: 16),
            Text(
              'Optional Remote Mode',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'When you explicitly enable remote mode:\n'
              '• Your messages are sent to the configured API provider\n'
              '• API keys are stored encrypted on your device\n'
              '• You can disable remote mode anytime\n'
              '• Remote providers may have their own privacy policies',
            ),
            SizedBox(height: 16),
            Text(
              'Data Security',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• All local data is encrypted\n'
              '• API keys use secure storage\n'
              '• No analytics or tracking\n'
              '• Open source and auditable',
            ),
          ],
        ),
      ),
    );
  }
}