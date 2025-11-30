import 'package:flutter/material.dart';

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  String? selectedModel;
  String selectedQuantization = 'Q4';

  final List<Map<String, dynamic>> models = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Model Selection')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Quantization: '),
                DropdownButton<String>(
                  value: selectedQuantization,
                  items: ['Q8', 'Q6', 'Q4', 'Q3'].map((q) => 
                    DropdownMenuItem(value: q, child: Text(q))
                  ).toList(),
                  onChanged: (value) => setState(() => selectedQuantization = value!),
                ),
              ],
            ),
          ),
          Expanded(
            child: models.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.memory, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No models available', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      SizedBox(height: 8),
                      Text('Add model files to assets/models/ directory', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    final model = models[index];
                    return ListTile(
                      leading: Icon(model['loaded'] ? Icons.check_circle : Icons.download),
                      title: Text(model['name']),
                      subtitle: Text('Size: ${model['size']} ($selectedQuantization)'),
                      trailing: model['loaded'] 
                        ? TextButton(onPressed: () {}, child: Text('Unload'))
                        : TextButton(onPressed: () {}, child: Text('Load')),
                      onTap: () => setState(() => selectedModel = model['name']),
                      selected: selectedModel == model['name'],
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}