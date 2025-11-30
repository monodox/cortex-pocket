import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('About Cortex Pocket')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  Icon(Icons.psychology, size: 80, color: Colors.blue),
                  SizedBox(height: 16),
                  Text('Cortex Pocket', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('Version 1.0.0', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 32),
            _buildSection('Privacy First', 'Cortex processes everything locally on your device. No data is sent to external servers, ensuring complete privacy and security.'),
            _buildSection('Open Source Models', 'Built on open-source LLM models with proper licensing and attribution.'),
            _buildSection('Developer Credits', 'Created with Flutter and optimized for on-device AI inference.'),
            Spacer(),
            Center(
              child: Column(
                children: [
                  Text('© 2024 Cortex Pocket', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () {}, child: Text('Privacy Policy')),
                      TextButton(onPressed: () {}, child: Text('Licenses')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(content, style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }
}