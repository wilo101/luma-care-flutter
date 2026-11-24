import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/chat_controller.dart';
import '../services/safety_guard.dart';
import '../theme/app_theme.dart';
import '../widgets/chat_bubble.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _send(ChatController c) {
    final text = _input.text;
    _input.clear();
    c.send(text);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.watch<ChatController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
    return Column(children: [
      Container(
        width: double.infinity,
        color: LumaColors.tealLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: const Text(SafetyGuard.disclaimer,
            style: TextStyle(fontSize: 12, color: LumaColors.tealDark)),
      ),
      Expanded(
        child: ListView.builder(
          controller: _scroll,
          padding: const EdgeInsets.all(16),
          itemCount: c.messages.length,
          itemBuilder: (_, i) => ChatBubble(
            message: c.messages[i],
            showTyping: c.isReplying && i == c.messages.length - 1,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _input,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(c),
              decoration: InputDecoration(
                hintText: 'Ask a health question',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            style: IconButton.styleFrom(backgroundColor: LumaColors.teal),
            onPressed: c.isReplying ? null : () => _send(c),
            icon: const Icon(Icons.arrow_upward_rounded),
          ),
        ]),
      ),
    ]);
  }
}
