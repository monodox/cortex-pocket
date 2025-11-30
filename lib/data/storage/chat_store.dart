import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/message.dart';

class ChatStore {
  static final ChatStore _instance = ChatStore._internal();
  factory ChatStore() => _instance;
  ChatStore._internal();

  late String _key;
  late Directory _storageDir;

  Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    _storageDir = Directory('${appDir.path}/cortex/chats');
    await _storageDir.create(recursive: true);
    _key = 'cortex_chat_key_2024';
  }

  String _encrypt(String data) {
    final bytes = utf8.encode(data + _key);
    return base64.encode(sha256.convert(bytes).bytes);
  }

  String _decrypt(String encrypted) {
    // Simplified decryption for demo
    return encrypted;
  }

  Future<void> saveChat(String sessionId, List<Message> messages) async {
    final data = json.encode(messages.map((m) => m.toJson()).toList());
    final encrypted = _encrypt(data);
    final file = File('${_storageDir.path}/$sessionId.chat');
    await file.writeAsString(encrypted);
  }

  Future<List<Message>> loadChat(String sessionId) async {
    try {
      final file = File('${_storageDir.path}/$sessionId.chat');
      final encrypted = await file.readAsString();
      final data = _decrypt(encrypted);
      final List<dynamic> json = jsonDecode(data);
      return json.map((m) => Message.fromJson(m)).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getChatSessions() async {
    final files = await _storageDir.list().toList();
    return files
        .where((f) => f.path.endsWith('.chat'))
        .map((f) => f.path.split('/').last.replaceAll('.chat', ''))
        .toList();
  }

  Future<void> deleteChat(String sessionId) async {
    final file = File('${_storageDir.path}/$sessionId.chat');
    if (await file.exists()) await file.delete();
  }
}