import 'package:flutter/material.dart';
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: _llmService.useRemote ? Colors.blue : 
                       _llmService.isModelLoaded ? Colors.green : Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Mode: ${_llmService.mode}',
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
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
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'gemini-2.5-flash',
                  child: Text('Gemini 2.5 Flash'),
                ),
                const PopupMenuItem(
                  value: 'gemini-1.5-pro',
                  child: Text('Gemini 1.5 Pro'),
                ),
                const PopupMenuItem(
                  value: 'gpt-3.5-turbo',
                  child: Text('GPT-3.5 Turbo'),
                ),
                const PopupMenuItem(
                  value: 'gpt-4',
                  child: Text('GPT-4'),
                ),
              ],
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