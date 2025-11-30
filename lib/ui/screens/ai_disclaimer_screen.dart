import 'package:flutter/material.dart';

class AiDisclaimerScreen extends StatelessWidget {
  const AiDisclaimerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Disclaimer')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AI Disclaimer',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'Last updated: December 19, 2024',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Text(
              'AI-Generated Content',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Cortex Pocket uses artificial intelligence to generate responses. All AI-generated content should be considered as suggestions and may contain inaccuracies.',
            ),
            SizedBox(height: 16),
            Text(
              'Accuracy Limitations',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '• AI responses may be factually incorrect\n'
              '• Information may be outdated or incomplete\n'
              '• Always verify important information independently\n'
              '• Do not rely solely on AI for critical decisions',
            ),
            SizedBox(height: 16),
            Text(
              'Bias and Fairness',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'AI models may exhibit biases present in training data. Responses may reflect cultural, social, or other biases. Use critical thinking when evaluating AI outputs.',
            ),
            SizedBox(height: 16),
            Text(
              'Professional Advice',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'AI responses are not a substitute for professional advice in:\n'
              '• Medical or health matters\n'
              '• Legal issues\n'
              '• Financial decisions\n'
              '• Safety-critical situations',
            ),
            SizedBox(height: 16),
            Text(
              'User Responsibility',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              'Users are responsible for:\n'
              '• Verifying AI-generated information\n'
              '• Using outputs appropriately\n'
              '• Complying with applicable laws\n'
              '• Respecting intellectual property rights',
            ),
          ],
        ),
      ),
    );
  }
}