import 'package:flutter/material.dart';
import 'chat_screen.dart';
import 'doctors_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    const pages = [DoctorsScreen(), ChatScreen()];
    return Scaffold(
      body: SafeArea(child: pages[_tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _tab,
        onDestinationSelected: (i) => setState(() => _tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.medical_services_outlined), label: 'Doctors'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline_rounded), label: 'Assistant'),
        ],
      ),
    );
  }
}
