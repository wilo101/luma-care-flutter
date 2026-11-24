import 'package:flutter/foundation.dart';

import '../models/chat_message.dart';
import 'chat_service.dart';
import 'safety_guard.dart';

/// Owns chat state. Order of operations for every user message:
/// 1. safety check  2. add empty assistant bubble  3. append streamed chunks
/// 4. on error show the fallback copy instead of a broken screen.
class ChatController extends ChangeNotifier {
  final ChatService _service;
  final List<ChatMessage> messages = [
    const ChatMessage(
      role: ChatRole.assistant,
      text: 'Hi, I\'m Luma Assistant. Ask me general health questions or how to book a visit.',
    ),
  ];
  bool isReplying = false;

  ChatController(this._service);

  Future<void> send(String text) async {
    final clean = text.trim();
    if (clean.isEmpty || isReplying) return;

    messages.add(ChatMessage(role: ChatRole.user, text: clean));

    if (SafetyGuard.isEmergency(clean)) {
      messages.add(const ChatMessage(
          role: ChatRole.assistant, text: SafetyGuard.emergencyReply, isSafetyNotice: true));
      notifyListeners();
      return; // the model is never called
    }

    isReplying = true;
    messages.add(const ChatMessage(role: ChatRole.assistant, text: ''));
    notifyListeners();
    final index = messages.length - 1;

    try {
      final history = messages.sublist(0, index);
      await for (final chunk in _service.reply(history)) {
        messages[index] = messages[index].copyWith(text: messages[index].text + chunk);
        notifyListeners();
      }
      if (messages[index].text.trim().isEmpty) {
        messages[index] = messages[index].copyWith(text: SafetyGuard.unavailableReply);
      }
    } catch (_) {
      messages[index] = ChatMessage(
          role: ChatRole.assistant, text: SafetyGuard.unavailableReply, isSafetyNotice: true);
    } finally {
      isReplying = false;
      notifyListeners();
    }
  }
}
