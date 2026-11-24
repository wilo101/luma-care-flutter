import '../models/doctor.dart';

abstract class ClinicRepository {
  Future<List<Doctor>> doctors();
  Future<Appointment> book(Doctor d, DateTime start, String reason);
}

/// Mock data. A real backend (REST or Firestore) would implement the same
/// interface, so the screens never change.
class MockClinicRepository implements ClinicRepository {
  static const _slots = ['09:00', '09:30', '10:30', '11:00', '13:30', '15:00', '16:30'];

  @override
  Future<List<Doctor>> doctors() async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return const [
      Doctor(id: 'd1', name: 'Dr. Salma Hassan', specialty: 'General practice', rating: 4.9, yearsExperience: 12, slots: _slots),
      Doctor(id: 'd2', name: 'Dr. Omar Nabil', specialty: 'Dermatology', rating: 4.8, yearsExperience: 9, slots: _slots),
      Doctor(id: 'd3', name: 'Dr. Mariam Adel', specialty: 'Pediatrics', rating: 4.9, yearsExperience: 15, slots: _slots),
      Doctor(id: 'd4', name: 'Dr. Karim Fathy', specialty: 'Cardiology', rating: 4.7, yearsExperience: 18, slots: _slots),
    ];
  }

  @override
  Future<Appointment> book(Doctor d, DateTime start, String reason) async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return Appointment(doctor: d, start: start, reason: reason);
  }
}
