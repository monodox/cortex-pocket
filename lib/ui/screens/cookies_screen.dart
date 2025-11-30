import 'package:flutter/material.dart';

class CookiesScreen extends StatelessWidget {
  const CookiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cookie Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cookie Policy',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: December 19, 2024',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'What Are Cookies?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cookies are small data files stored on your device. Cortex Pocket is a mobile application that uses local storage instead of traditional web cookies.',
            ),
            SizedBox(height: 16),
            Text(
              'Local Storage Usage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cortex Pocket stores data locally on your device for:\n'
              '• App settings and preferences\n'
              '• Chat conversation history\n'
              '• Model configurations\n'
              '• Performance settings',
            ),
            SizedBox(height: 16),
            Text(
              'No Third-Party Cookies',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'By default, Cortex Pocket does not use third-party cookies or tracking. All data processing happens locally on your device.',
            ),
            SizedBox(height: 16),
            Text(
              'Remote Mode Considerations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'When using optional remote API mode, external providers may use their own cookies and tracking. Please review their privacy policies.',
            ),
            SizedBox(height: 16),
            Text(
              'Managing Local Data',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'You can manage your local data through:\n'
              '• Settings → Clear Cache\n'
              '• Settings → Reset Settings\n'
              '• Uninstalling the application',
            ),
          ],
        ),
      ),
    );
  }
}