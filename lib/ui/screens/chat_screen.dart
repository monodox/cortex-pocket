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
      _addWelcomeMessages();
    }
    
    setState(() {});
  }

  void _addWelcomeMessages() {
    if (!_llmService.isModelLoaded && !(_llmService.useRemote && _llmService.hasApiKey)) {
      final welcomeMessages = [
        Message(
          id: 'welcome_1',
          content: '👋 **Welcome to Cortex Pocket!**\n\nI\'m your AI assistant, but I need to be configured first.',
          isUser: false,
          timestamp: DateTime.now(),
        ),
        Message(
          id: 'welcome_2', 
          content: '🔧 **Setup Options:**\n\n'
                  '**Option 1: Local AI (Private)**\n'
                  '• Go to Models → Download a model\n'
                  '• Complete privacy, works offline\n\n'
                  '**Option 2: Remote API**\n'
                  '• Go to Settings → Add API key\n'
                  '• Use OpenAI or Google Gemini',
          isUser: false,
          timestamp: DateTime.now().add(const Duration(seconds: 1)),
        ),
        Message(
          id: 'welcome_3',
          content: '💡 **Quick Start:**\n\n'
                  'Try typing "help" or "setup" for guidance, or use the buttons above to navigate to Models or Settings.',
          isUser: false,
          timestamp: DateTime.now().add(const Duration(seconds: 2)),
        ),
      ];
      
      setState(() {
        _messages.addAll(welcomeMessages);
      });
    }
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty || _isGenerating) return;

    final userInput = _controller.text.trim().toLowerCase();
    
    // Handle setup guidance commands
    if (!_llmService.isModelLoaded && !(_llmService.useRemote && _llmService.hasApiKey)) {
      _handleSetupCommands(userInput);
      return;
    }

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
      String fullResponse = '';
      await for (final token in _llmService.generateResponse(userMessage.content)) {
        fullResponse = token;
        setState(() {
          _messages.last = Message(
            id: aiMessage.id,
            content: fullResponse,
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
          content: '❌ **Error**: ${e.toString()}\n\n'
                  '**To fix this:**\n'
                  '• **Local AI**: Go to Models → Download a model\n'
                  '• **Remote API**: Go to Settings → Add API key\n'
                  '• **Check connection** if using remote mode',
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

  void _handleSetupCommands(String input) {
    final userMessage = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: _controller.text.trim(),
      isUser: true,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(userMessage);
    });
    _controller.clear();

    String response = '';
    
    if (input.contains('help') || input.contains('guide')) {
      response = '🆘 **Help & Setup Guide**\n\n'
                '**Available Commands:**\n'
                '• "setup" - Show setup options\n'
                '• "models" - Learn about local models\n'
                '• "api" - Learn about remote API\n'
                '• "features" - See what I can do\n\n'
                '**Quick Actions:**\n'
                '• Tap Models in bottom nav → Download AI models\n'
                '• Tap Settings in bottom nav → Add API key';
    } else if (input.contains('setup')) {
      response = '⚙️ **Setup Options**\n\n'
                '**Option 1: Local AI (Recommended)**\n'
                '• 100% private and offline\n'
                '• Go to Models → Browse Models → Download\n'
                '• Recommended: Gemma 2B for most devices\n\n'
                '**Option 2: Remote API**\n'
                '• More powerful models\n'
                '• Go to Settings → Add your API key\n'
                '• Supports OpenAI (sk-...) and Gemini (AIza...)';
    } else if (input.contains('model')) {
      response = '🤖 **Local AI Models**\n\n'
                '**Benefits:**\n'
                '• Complete privacy - data never leaves device\n'
                '• Works offline anywhere\n'
                '• No subscription costs\n\n'
                '**Recommended Models:**\n'
                '• **Gemma 2B** - Fast, lightweight (2-4GB RAM)\n'
                '• **Llama 3.2 3B** - Balanced performance (4-6GB RAM)\n'
                '• **Phi-3.5 Mini** - Great for coding (4GB+ RAM)\n\n'
                '**Setup:** Models → Browse Models → Download';
    } else if (input.contains('api')) {
      response = '☁️ **Remote API Setup**\n\n'
                '**Supported Providers:**\n'
                '• **OpenAI** - GPT-3.5, GPT-4 (key starts with sk-)\n'
                '• **Google Gemini** - Gemini 2.5 Flash/Pro (key starts with AIza)\n\n'
                '**Setup Steps:**\n'
                '1. Go to Settings → Remote API\n'
                '2. Enter your API key\n'
                '3. Tap "Save & Test"\n'
                '4. Enable "Use Remote API"\n\n'
                '**Note:** Your API key is stored encrypted on device';
    } else if (input.contains('feature')) {
      response = '✨ **Cortex Pocket Features**\n\n'
                '**AI Capabilities:**\n'
                '• Real-time chat with AI models\n'
                '• Specialized personas (Developer, Security, Writer)\n'
                '• Document analysis and file reasoning\n'
                '• Code assistance and debugging\n\n'
                '**Privacy & Performance:**\n'
                '• 100% offline local AI (when using local models)\n'
                '• Arm-optimized for mobile devices\n'
                '• Performance benchmarking tools\n'
                '• Encrypted chat history';
    } else {
      response = '🤔 **I\'m not configured yet!**\n\n'
                'I can help you get started though. Try typing:\n'
                '• "help" - for setup guidance\n'
                '• "setup" - for configuration options\n'
                '• "models" - to learn about local AI\n'
                '• "api" - to learn about remote API\n\n'
                'Or use the navigation buttons to go to Models or Settings.';
    }

    final aiMessage = Message(
      id: '${DateTime.now().millisecondsSinceEpoch}_ai',
      content: response,
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      _messages.add(aiMessage);
    });
    _scrollToBottom();
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
          // Mode switch toggle
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.offline_bolt,
                size: 16,
                color: !_llmService.useRemote ? Colors.green : Colors.grey,
              ),
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
              Icon(
                Icons.cloud,
                size: 16,
                color: _llmService.useRemote ? Colors.blue : Colors.grey,
              ),
            ],
          ),
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
                          enabled: !_isGenerating,
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.send,
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        onPressed: !_isGenerating ? _sendMessage : null,
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