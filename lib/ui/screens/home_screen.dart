import 'package:flutter/material.dart';
import '../../core/routes.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            Icon(Icons.psychology, color: Colors.blue),
            SizedBox(width: 8),
            Text('Cortex Pocket'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, Routes.settings),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(context, 'Chat', Icons.chat, Routes.chat, Colors.blue),
            _buildCard(context, 'Models', Icons.memory, Routes.models, Colors.green),
            _buildCard(context, 'File Analysis', Icons.description, Routes.fileReasoning, Colors.orange),
            _buildCard(context, 'Personas', Icons.person, Routes.personas, Colors.purple),
            _buildCard(context, 'Benchmark', Icons.speed, Routes.benchmark, Colors.red),
            _buildCard(context, 'History', Icons.history, Routes.history, Colors.teal),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, String title, IconData icon, String route, Color color) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, route),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}