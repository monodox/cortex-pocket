import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../models/message.dart';
import '../../services/llm_service.dart';
import '../../core/routes.dart';
import '../widgets/message_bubble.dart';
import '../../data/storage/chat_store.dart';

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
  final ChatStore _chatStore = ChatStore();
  bool _isGenerating = false;
  String? _currentSessionId;

  @override
  void initState() {
    super.initState();
    _initializeService();
    _llmService.addListener(_onServiceChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadSessionFromArguments();
  }

  void _loadSessionFromArguments() async {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null && args['sessionId'] != null) {
      final sessionId = args['sessionId'] as String;
      await _loadChatSession(sessionId);
    } else {
      _startNewSession();
    }
  }

  void _startNewSession() {
    _currentSessionId = _chatStore.generateSessionId();
    _chatStore.setCurrentSessionId(_currentSessionId);
  }

  Future<void> _loadChatSession(String sessionId) async {
    _currentSessionId = sessionId;
    await _chatStore.setCurrentSessionId(sessionId);
    final messages = await _chatStore.loadChat(sessionId);
    setState(() {
      _messages.clear();
      _messages.addAll(messages);
    });
    _scrollToBottom();
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
    await _chatStore.initialize();
    await _llmService.initialize();
    if (!_llmService.useRemote) {
      await _llmService.loadModel('cortex-7b-q4');
    }
    
    // Load current session if exists
    final currentSessionId = _chatStore.getCurrentSessionId();
    if (currentSessionId != null) {
      await _loadChatSession(currentSessionId);
    } else {
      _startNewSession();
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

    // Save chat after each exchange
    if (_currentSessionId != null) {
      await _chatStore.saveChat(_currentSessionId!, _messages);
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
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Document attached: ${file.name}')),
          );
        }
        // Process the attached document
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error attaching document: $e')),
        );
      }
    }
  }

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
            icon: const Icon(Icons.add),
            onPressed: () {
              _startNewSession();
              setState(() {
                _messages.clear();
              });
            },
            tooltip: 'New Chat',
          ),
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
                    )),
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