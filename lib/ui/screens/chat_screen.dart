import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/message.dart';
import '../../services/llm_service.dart';
import '../../core/routes.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Message> _messages = [];
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final LLMService _llmService = LLMService();
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _llmService.addListener(_onServiceChanged);
  }

  @override
  void dispose() {
    _llmService.removeListener(_onServiceChanged);
    super.dispose();
  }

  void _onServiceChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _initializeService() async {
    await _llmService.initialize();
    if (!_llmService.useRemote) {
      await _llmService.loadModel('cortex-7b-q4');
    }
    setState(() {});
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isGenerating) return;

    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _controller.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
      _isGenerating = true;
    });

    _controller.clear();
    _scrollToBottom();

    final aiMessage = Message(
      id: '${DateTime.now().millisecondsSinceEpoch}_ai',
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(aiMessage);
    });

    try {
      await for (final token in _llmService.generateResponse(userMessage.content)) {
        setState(() {
          _messages.last = Message(
            id: aiMessage.id,
            content: token,
            isUser: false,
            timestamp: aiMessage.timestamp,
          );
        });
        _scrollToBottom();
      }
    } catch (e) {
      setState(() {
        _messages.last = Message(
          id: aiMessage.id,
          content: 'Error: $e\n\nTip: Load a local model in Settings → Models or check your API key.',
          isUser: false,
          timestamp: aiMessage.timestamp,
        );
      });
    }

    setState(() {
      _isGenerating = false;
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _attachDocument() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['txt', 'pdf', 'doc', 'docx', 'md'],
      );

      if (result != null) {
        final file = result.files.first;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Document attached: ${file.name}')),
        );
        // TODO: Process the attached document
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error attaching document: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.psychology, color: Colors.blue),
            const SizedBox(width: 8),
            const Text('Cortex Pocket'),
            const Spacer(),
            Row(
              children: [
                Icon(
                  Icons.offline_bolt,
                  size: 16,
                  color: !_llmService.useRemote ? Colors.green : Colors.grey,
                ),
                const SizedBox(width: 4),
                Switch(
                  value: _llmService.useRemote,
                  onChanged: _llmService.hasApiKey ? (value) {
                    _llmService.setUseRemote(value);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Switched to ${value ? "Remote" : "Local"} mode'
                        ),
                      ),
                    );
                  } : null,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.cloud,
                  size: 16,
                  color: _llmService.useRemote ? Colors.blue : Colors.grey,
                ),
              ],
            ),
          ],
        ),
        actions: [
          if (_llmService.useRemote && _llmService.hasApiKey)
            PopupMenuButton<String>(
              icon: const Icon(Icons.tune),
              onSelected: (model) {
                _llmService.setSelectedModel(model);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Model switched to $model')),
                );
              },
              itemBuilder: (context) => _llmService.availableModels.map((model) => PopupMenuItem(
                value: model['id'],
                child: Text(model['name']!),
              )).toList(),
            ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, Routes.personas),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return MessageBubble(message: _messages[index]);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  offset: const Offset(0, -2),
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: 0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.add_circle_outline),
                  onSelected: (value) {
                    if (value == 'attach') {
                      _attachDocument();
                    } else if (value.startsWith('model:')) {
                      final model = value.substring(6);
                      _llmService.setSelectedModel(model);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Model switched to $model')),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'attach',
                      child: Row(
                        children: [
                          Icon(Icons.attach_file),
                          SizedBox(width: 8),
                          Text('Attach Document'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'models',
                      enabled: false,
                      child: Text('Switch Model', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ..._llmService.availableModels.map((model) => PopupMenuItem(
                      value: 'model:${model['id']}',
                      child: Text(model['name']!),
                    )).toList(),
                  ],
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Ask Cortex anything...',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                    enabled: (_llmService.isModelLoaded || _llmService.useRemote) && !_isGenerating,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: (_llmService.isModelLoaded || _llmService.useRemote) && !_isGenerating ? _sendMessage : null,
                  icon: _isGenerating 
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}