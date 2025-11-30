import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/message.dart';

class ChatSession {
  final String id;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int messageCount;

  ChatSession({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    required this.messageCount,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
    'messageCount': messageCount,
  };

  factory ChatSession.fromJson(Map<String, dynamic> json) => ChatSession(
    id: json['id'],
    title: json['title'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
    messageCount: json['messageCount'],
  );
}

class ChatStore {
  static final ChatStore _instance = ChatStore._internal();
  factory ChatStore() => _instance;
  ChatStore._internal();

  late String _key;
  late Directory _storageDir;
  late SharedPreferences _prefs;
  final Map<String, List<Message>> _cache = {};

  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _storageDir = Directory('${appDir.path}/cortex/chats');
    await _storageDir.create(recursive: true);
    _key = 'cortex_chat_key_2024';
    _prefs = await SharedPreferences.getInstance();
  }

  String _encrypt(String data) {
    final bytes = utf8.encode(data + _key);
    return base64.encode(sha256.convert(bytes).bytes);
  }

  String _decrypt(String encrypted) {
    // Simplified decryption for demo
    return encrypted;
  }

  String generateSessionId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  String _generateTitle(List<Message> messages) {
    if (messages.isEmpty) return 'New Chat';
    final firstUserMessage = messages.firstWhere(
      (m) => m.isUser && m.content.trim().isNotEmpty,
      orElse: () => messages.first,
    );
    final title = firstUserMessage.content.trim();
    return title.length > 30 ? '${title.substring(0, 30)}...' : title;
  }

  Future<void> saveChat(String sessionId, List<Message> messages) async {
    if (messages.isEmpty) return;
    
    // Cache the messages
    _cache[sessionId] = List.from(messages);
    
    // Save messages to file
    final data = json.encode(messages.map((m) => m.toJson()).toList());
    final encrypted = _encrypt(data);
    final file = File('${_storageDir.path}/$sessionId.chat');
    await file.writeAsString(encrypted);
    
    // Update session metadata
    await _updateSessionMetadata(sessionId, messages);
  }

  Future<void> _updateSessionMetadata(String sessionId, List<Message> messages) async {
    final sessions = await getChatSessions();
    final existingIndex = sessions.indexWhere((s) => s.id == sessionId);
    
    final session = ChatSession(
      id: sessionId,
      title: _generateTitle(messages),
      createdAt: existingIndex >= 0 ? sessions[existingIndex].createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
      messageCount: messages.length,
    );
    
    if (existingIndex >= 0) {
      sessions[existingIndex] = session;
    } else {
      sessions.add(session);
    }
    
    // Sort by most recent
    sessions.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString('chat_sessions', json.encode(sessionsJson));
  }

  Future<List<Message>> loadChat(String sessionId) async {
    // Check cache first
    if (_cache.containsKey(sessionId)) {
      return List.from(_cache[sessionId]!);
    }
    
    try {
      final file = File('${_storageDir.path}/$sessionId.chat');
      final encrypted = await file.readAsString();
      final data = _decrypt(encrypted);
      final List<dynamic> jsonData = jsonDecode(data);
      final messages = jsonData.map((m) => Message.fromJson(m)).toList();
      
      // Cache the loaded messages
      _cache[sessionId] = List.from(messages);
      return messages;
    } catch (e) {
      return [];
    }
  }

  Future<List<ChatSession>> getChatSessions() async {
    try {
      final sessionsJson = _prefs.getString('chat_sessions');
      if (sessionsJson != null) {
        final List<dynamic> sessionsList = json.decode(sessionsJson);
        return sessionsList.map((s) => ChatSession.fromJson(s)).toList();
      }
    } catch (e) {
      // Fallback to file-based detection
    }
    
    // Fallback: scan files and create sessions
    final files = await _storageDir.list().toList();
    final sessions = <ChatSession>[];
    
    for (final file in files.where((f) => f.path.endsWith('.chat'))) {
      final sessionId = file.path.split('/').last.replaceAll('.chat', '');
      final stat = await file.stat();
      sessions.add(ChatSession(
        id: sessionId,
        title: 'Chat $sessionId',
        createdAt: stat.modified,
        updatedAt: stat.modified,
        messageCount: 0,
      ));
    }
    
    return sessions;
  }

  Future<void> deleteChat(String sessionId) async {
    // Remove from cache
    _cache.remove(sessionId);
    
    // Delete file
    final file = File('${_storageDir.path}/$sessionId.chat');
    if (await file.exists()) await file.delete();
    
    // Update session metadata
    final sessions = await getChatSessions();
    sessions.removeWhere((s) => s.id == sessionId);
    final sessionsJson = sessions.map((s) => s.toJson()).toList();
    await _prefs.setString('chat_sessions', json.encode(sessionsJson));
  }

  Future<void> clearAllChats() async {
    // Clear cache
    _cache.clear();
    
    // Delete all files
    final files = await _storageDir.list().toList();
    for (final file in files.where((f) => f.path.endsWith('.chat'))) {
      await file.delete();
    }
    
    // Clear session metadata
    await _prefs.remove('chat_sessions');
  }

  String? getCurrentSessionId() {
    return _prefs.getString('current_session_id');
  }

  Future<void> setCurrentSessionId(String? sessionId) async {
    if (sessionId != null) {
      await _prefs.setString('current_session_id', sessionId);
    } else {
      await _prefs.remove('current_session_id');
    }
  }
}