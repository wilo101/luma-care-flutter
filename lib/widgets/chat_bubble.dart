import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../theme/app_theme.dart';

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  final bool showTyping;
  const ChatBubble({super.key, required this.message, this.showTyping = false});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    final bg = message.isSafetyNotice
        ? const Color(0xFFFDECEA)
        : isUser
            ? LumaColors.teal
            : Colors.white;
    final fg = isUser ? Colors.white : LumaColors.ink;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isUser ? 18 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 18),
          ),
          border: isUser ? null : Border.all(color: const Color(0xFFE3F0EE)),
        ),
        child: Text(
          message.text.isEmpty && showTyping ? '...' : message.text,
          style: TextStyle(color: message.isSafetyNotice ? LumaColors.danger : fg, height: 1.35),
        ),
      ),
    );
  }
}
