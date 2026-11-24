import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/doctor.dart';
import '../services/clinic_repository.dart';
import '../theme/app_theme.dart';
import 'booking_screen.dart';

class DoctorsScreen extends StatelessWidget {
  const DoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Doctor>>(
      future: context.read<ClinicRepository>().doctors(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text('Find a doctor',
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w700, color: LumaColors.ink)),
            const SizedBox(height: 16),
            for (final d in snap.data!) _DoctorCard(doctor: d),
          ],
        );
      },
    );
  }
}

class _DoctorCard extends StatelessWidget {
  final Doctor doctor;
  const _DoctorCard({required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (_) => BookingScreen(doctor: doctor))),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: LumaColors.tealLight,
              child: Text(doctor.name.split(' ')[1][0],
                  style: const TextStyle(
                      color: LumaColors.tealDark, fontWeight: FontWeight.w700, fontSize: 20)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(doctor.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 16, color: LumaColors.ink)),
                Text(doctor.specialty, style: const TextStyle(color: LumaColors.muted)),
                const SizedBox(height: 6),
                Row(children: [
                  const Icon(Icons.star_rounded, size: 18, color: Color(0xFFF2B01E)),
                  Text(' ${doctor.rating}  ·  ${doctor.yearsExperience} yrs',
                      style: const TextStyle(color: LumaColors.muted)),
                ]),
              ]),
            ),
            const Icon(Icons.chevron_right_rounded, color: LumaColors.muted),
          ]),
        ),
      ),
    );
  }
}
