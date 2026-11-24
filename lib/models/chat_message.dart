enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String text;
  final bool isSafetyNotice;
  const ChatMessage({required this.role, required this.text, this.isSafetyNotice = false});

  ChatMessage copyWith({String? text}) =>
      ChatMessage(role: role, text: text ?? this.text, isSafetyNotice: isSafetyNotice);
}
