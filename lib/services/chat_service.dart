import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chat_message.dart';

/// The UI only ever sees a Stream of text chunks, whatever backs it.
abstract class ChatService {
  Stream<String> reply(List<ChatMessage> history);
}

/// Offline demo "model". Streams a canned answer word by word so the typing
/// effect can be developed and demoed without any API key.
class MockChatService implements ChatService {
  @override
  Stream<String> reply(List<ChatMessage> history) async* {
    final last = history.last.text.toLowerCase();
    final answer = last.contains('book') || last.contains('appointment')
        ? 'Sure. Open the Doctors tab, pick a specialty and choose a time that suits you. I can also suggest which kind of doctor fits your symptoms.'
        : last.contains('headache')
            ? 'Headaches are often linked to dehydration, lack of sleep or screen time. Rest, water and a dark room can help. If it is sudden, severe or lasts more than a few days, please see a doctor.'
            : 'Thanks for your question. I can share general health information and help you book a visit. What would you like to know?';
    for (final word in answer.split(' ')) {
      await Future<void>.delayed(const Duration(milliseconds: 45));
      yield '$word ';
    }
  }
}

/// Talks to YOUR backend proxy, which holds the model API key and forwards to
/// an LLM. The app never contains a provider key.
///
/// Expected proxy contract (server-sent events, one `data:` line per chunk):
///   POST {endpoint}  body: {"messages":[{"role":"user","content":"..."}]}
///   response lines:  data: {"delta":"text"}   and a final   data: [DONE]
class ProxyChatService implements ChatService {
  final Uri endpoint;
  final http.Client _client;
  ProxyChatService(this.endpoint, {http.Client? client}) : _client = client ?? http.Client();

  static const _systemHint =
      'You are Luma Assistant for a clinic app. Give general health information '
      'only. Never diagnose, never prescribe doses. Encourage booking a doctor '
      'for anything persistent or serious.';

  @override
  Stream<String> reply(List<ChatMessage> history) async* {
    final req = http.Request('POST', endpoint)
      ..headers['Content-Type'] = 'application/json'
      ..body = jsonEncode({
        'system': _systemHint,
        'messages': [
          for (final m in history) {'role': m.role.name, 'content': m.text}
        ],
      });
    final res = await _client.send(req).timeout(const Duration(seconds: 15));
    if (res.statusCode != 200) {
      throw http.ClientException('Chat backend returned ${res.statusCode}');
    }
    await for (final line in res.stream.transform(utf8.decoder).transform(const LineSplitter())) {
      if (!line.startsWith('data:')) continue;
      final payload = line.substring(5).trim();
      if (payload == '[DONE]') break;
      final delta = (jsonDecode(payload) as Map<String, dynamic>)['delta'] as String?;
      if (delta != null) yield delta;
    }
  }
}
