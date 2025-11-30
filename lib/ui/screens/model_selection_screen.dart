import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ModelSelectionScreen extends StatefulWidget {
  const ModelSelectionScreen({super.key});

  @override
  State<ModelSelectionScreen> createState() => _ModelSelectionScreenState();
}

class _ModelSelectionScreenState extends State<ModelSelectionScreen> {
  String? selectedModel;
  String selectedQuantization = 'Q4';
  bool _showDownloadable = false;

  final List<Map<String, dynamic>> models = [];
  
  final List<Map<String, dynamic>> downloadableModels = [
    {
      'name': 'Llama 3.2 3B',
      'size': '2.0GB',
      'url': 'https://huggingface.co/meta-llama/Llama-3.2-3B-Instruct-GGUF',
      'description': 'Meta\'s latest 3B parameter model, optimized for mobile',
      'license': 'Llama 3.2 Community License',
    },
    {
      'name': 'Phi-3.5 Mini',
      'size': '2.2GB',
      'url': 'https://huggingface.co/microsoft/Phi-3.5-mini-instruct-gguf',
      'description': 'Microsoft\'s efficient 3.8B parameter model',
      'license': 'MIT License',
    },
    {
      'name': 'Qwen2.5 3B',
      'size': '1.9GB',
      'url': 'https://huggingface.co/Qwen/Qwen2.5-3B-Instruct-GGUF',
      'description': 'Alibaba\'s multilingual 3B model with strong coding abilities',
      'license': 'Apache 2.0',
    },
    {
      'name': 'Gemma 2 2B',
      'size': '1.6GB',
      'url': 'https://huggingface.co/google/gemma-2-2b-it-GGUF',
      'description': 'Google\'s lightweight 2B parameter model',
      'license': 'Gemma Terms of Use',
    },
    {
      'name': 'CodeLlama 7B',
      'size': '3.8GB',
      'url': 'https://huggingface.co/codellama/CodeLlama-7b-Instruct-hf',
      'description': 'Meta\'s specialized code generation model',
      'license': 'Llama 2 Community License',
    },
  ];

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Model Management'),
        actions: [
          IconButton(
            icon: Icon(_showDownloadable ? Icons.storage : Icons.download),
            onPressed: () => setState(() => _showDownloadable = !_showDownloadable),
            tooltip: _showDownloadable ? 'Show Local Models' : 'Browse Models',
          ),
        ],
      ),
      body: Column(
        children: [
          if (!_showDownloadable)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('Quantization: '),
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
            child: _showDownloadable
              ? _buildDownloadableModels()
              : _buildLocalModels(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocalModels() {
    return models.isEmpty
      ? Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.memory, size: 64, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('No local models available', style: TextStyle(fontSize: 18, color: Colors.grey)),
              const SizedBox(height: 8),
              Text('Download models or add files to assets/models/', style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => setState(() => _showDownloadable = true),
                icon: const Icon(Icons.download),
                label: const Text('Browse Models'),
              ),
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
                ? TextButton(onPressed: () {}, child: const Text('Unload'))
                : TextButton(onPressed: () {}, child: const Text('Load')),
              onTap: () => setState(() => selectedModel = model['name']),
              selected: selectedModel == model['name'],
            );
          },
        );
  }

  Widget _buildDownloadableModels() {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: Colors.blue.withValues(alpha: 0.1),
          child: const Text(
            'Open-Weight Models Available for Download',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: downloadableModels.length,
            itemBuilder: (context, index) {
              final model = downloadableModels[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.download_for_offline, color: Colors.blue),
                  title: Text(model['name']),
                  subtitle: Text('${model['size']} • ${model['license']}'),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            model['description'],
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => _launchUrl(model['url']),
                                  icon: const Icon(Icons.open_in_new),
                                  label: const Text('Download from HuggingFace'),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'After downloading, place the .gguf file in assets/models/',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}