import 'package:flutter/material.dart';

class FileReasoningScreen extends StatefulWidget {
  const FileReasoningScreen({super.key});

  @override
  State<FileReasoningScreen> createState() => _FileReasoningScreenState();
}

class _FileReasoningScreenState extends State<FileReasoningScreen> {
  final TextEditingController _textController = TextEditingController();
  String _analysis = '';
  bool _isAnalyzing = false;

  void _analyzeText() async {
    if (_textController.text.trim().isEmpty) return;
    
    setState(() => _isAnalyzing = true);
    
    await Future.delayed(Duration(seconds: 2));
    
    setState(() {
      _analysis = 'Analysis: This appears to be ${_textController.text.length > 100 ? 'a complex document' : 'a simple text'}. Key insights: Structure is well-organized, contains technical content.';
      _isAnalyzing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Reasoning'),
        actions: [
          IconButton(
            icon: Icon(Icons.file_upload),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: TextField(
                controller: _textController,
                maxLines: null,
                expands: true,
                decoration: InputDecoration(
                  hintText: 'Paste your text, code, or logs here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isAnalyzing ? null : _analyzeText,
                child: _isAnalyzing 
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                        SizedBox(width: 8),
                        Text('Analyzing...'),
                      ],
                    )
                  : Text('Analyze'),
              ),
            ),
            SizedBox(height: 16),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SingleChildScrollView(
                  child: Text(_analysis.isEmpty ? 'Analysis will appear here...' : _analysis),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}