import 'package:flutter/material.dart';

class BenchmarkScreen extends StatelessWidget {
  const BenchmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Performance Benchmark')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildMetricCard('Tokens/Second', '45.2', Icons.speed),
            _buildMetricCard('Latency', '22ms', Icons.timer),
            _buildMetricCard('Model Load Time', '1.8s', Icons.hourglass_bottom),
            _buildMetricCard('RAM Usage', '2.1GB', Icons.memory),
            _buildMetricCard('CPU Usage', '68%', Icons.memory),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantization Comparison', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    _buildQuantRow('Q8', '52.1 t/s', '4.2GB'),
                    _buildQuantRow('Q6', '48.7 t/s', '3.1GB'),
                    _buildQuantRow('Q4', '45.2 t/s', '2.1GB'),
                    _buildQuantRow('Q3', '41.8 t/s', '1.6GB'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        trailing: Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildQuantRow(String quant, String speed, String memory) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(quant, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(speed),
          Text(memory),
        ],
      ),
    );
  }
}