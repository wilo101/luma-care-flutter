import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/shell.dart';
import 'services/chat_controller.dart';
import 'services/chat_service.dart';
import 'services/clinic_repository.dart';
import 'theme/app_theme.dart';

/// Real model via your proxy:  --dart-define=CHAT_URL=https://your-proxy/chat
/// Without it the app uses the offline mock assistant.
const _chatUrl = String.fromEnvironment('CHAT_URL');

void main() {
  final ChatService chat =
      _chatUrl.isEmpty ? MockChatService() : ProxyChatService(Uri.parse(_chatUrl));
  runApp(MultiProvider(
    providers: [
      Provider<ClinicRepository>.value(value: MockClinicRepository()),
      ChangeNotifierProvider(create: (_) => ChatController(chat)),
    ],
    child: const LumaApp(),
  ));
}

class LumaApp extends StatelessWidget {
  const LumaApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Luma Care',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        home: const Shell(),
      );
}
