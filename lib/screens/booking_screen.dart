import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/doctor.dart';
import '../services/clinic_repository.dart';
import '../theme/app_theme.dart';
import 'confirmation_screen.dart';

/// Step 2 of the flow: pick a day and time, add a reason, confirm.
class BookingScreen extends StatefulWidget {
  final Doctor doctor;
  const BookingScreen({super.key, required this.doctor});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  late final List<DateTime> _days;
  int _dayIndex = 0;
  String? _slot;
  final _reason = TextEditingController();
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _days = List.generate(7, (i) => DateTime(today.year, today.month, today.day + i + 1));
  }

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final slot = _slot;
    if (slot == null) return;
    setState(() => _busy = true);
    final parts = slot.split(':');
    final day = _days[_dayIndex];
    final start = DateTime(day.year, day.month, day.day, int.parse(parts[0]), int.parse(parts[1]));
    final appt = await context.read<ClinicRepository>().book(widget.doctor, start, _reason.text.trim());
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ConfirmationScreen(appointment: appt)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.doctor.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Choose a day', style: TextStyle(fontWeight: FontWeight.w600, color: LumaColors.ink)),
          const SizedBox(height: 10),
          SizedBox(
            height: 74,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (_, i) {
                final selected = i == _dayIndex;
                return ChoiceChip(
                  showCheckmark: false,
                  selected: selected,
                  onSelected: (_) => setState(() => _dayIndex = i),
                  label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(DateFormat('EEE').format(_days[i])),
                      Text(DateFormat('d').format(_days[i]),
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
                    ]),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 22),
          const Text('Available times', style: TextStyle(fontWeight: FontWeight.w600, color: LumaColors.ink)),
          const SizedBox(height: 10),
          Wrap(spacing: 10, runSpacing: 10, children: [
            for (final s in widget.doctor.slots)
              ChoiceChip(
                label: Text(s),
                selected: _slot == s,
                onSelected: (_) => setState(() => _slot = s),
              ),
          ]),
          const SizedBox(height: 22),
          TextField(
            controller: _reason,
            maxLines: 3,
            decoration: const InputDecoration(
                labelText: 'Reason for visit (optional)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _slot == null || _busy ? null : _confirm,
            child: _busy
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Confirm appointment'),
          ),
        ],
      ),
    );
  }
}
