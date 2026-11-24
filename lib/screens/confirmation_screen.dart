import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/doctor.dart';
import '../theme/app_theme.dart';

class ConfirmationScreen extends StatelessWidget {
  final Appointment appointment;
  const ConfirmationScreen({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const CircleAvatar(
              radius: 44,
              backgroundColor: LumaColors.tealLight,
              child: Icon(Icons.check_rounded, size: 48, color: LumaColors.teal),
            ),
            const SizedBox(height: 24),
            const Text('You\'re booked',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: LumaColors.ink)),
            const SizedBox(height: 12),
            Text(appointment.doctor.name, style: const TextStyle(fontSize: 18)),
            Text(DateFormat('EEEE, d MMM · HH:mm').format(appointment.start),
                style: const TextStyle(color: LumaColors.muted, fontSize: 16)),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Done'),
            ),
          ]),
        ),
      ),
    );
  }
}
