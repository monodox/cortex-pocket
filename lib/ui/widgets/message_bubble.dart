import 'package:flutter/material.dart';
import '../../models/message.dart';

class MessageBubble extends StatelessWidget {
  final Message message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        decoration: BoxDecoration(
          color: message.isUser 
            ? Theme.of(context).primaryColor
            : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
_buildMessageContent(),
            const SizedBox(height: 4),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                fontSize: 10,
                color: message.isUser 
                  ? Colors.white70 
                  : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageContent() {
    final content = message.content;
    final textColor = message.isUser ? Colors.white : Colors.black87;
    
    // Simple markdown processing for **bold** text
    final parts = content.split('**');
    if (parts.length == 1) {
      // No bold formatting
      return Text(
        content,
        style: TextStyle(color: textColor),
      );
    }
    
    // Process bold formatting
    final spans = <TextSpan>[];
    for (int i = 0; i < parts.length; i++) {
      if (i % 2 == 0) {
        // Regular text
        if (parts[i].isNotEmpty) {
          spans.add(TextSpan(
            text: parts[i],
            style: TextStyle(color: textColor),
          ));
        }
      } else {
        // Bold text
        spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ));
      }
    }
    
    return RichText(
      text: TextSpan(children: spans),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}