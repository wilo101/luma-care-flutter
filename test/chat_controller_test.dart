import 'package:flutter_test/flutter_test.dart';
import 'package:luma_care/models/chat_message.dart';
import 'package:luma_care/services/chat_controller.dart';
import 'package:luma_care/services/chat_service.dart';
import 'package:luma_care/services/safety_guard.dart';

class _CountingService implements ChatService {
  int calls = 0;
  @override
  Stream<String> reply(List<ChatMessage> history) async* {
    calls++;
    yield 'ok';
  }
}

class _FailingService implements ChatService {
  @override
  Stream<String> reply(List<ChatMessage> history) => Stream.error(Exception('down'));
}

void main() {
  test('emergency text never reaches the model', () async {
    final svc = _CountingService();
    final c = ChatController(svc);
    await c.send('I have chest pain');
    expect(svc.calls, 0);
    expect(c.messages.last.text, SafetyGuard.emergencyReply);
  });

  test('model failure shows fallback copy', () async {
    final c = ChatController(_FailingService());
    await c.send('hello');
    expect(c.messages.last.text, SafetyGuard.unavailableReply);
  });
}
