class Doctor {
  final String id;
  final String name;
  final String specialty;
  final double rating;
  final int yearsExperience;
  final List<String> slots; // "HH:mm" in clinic local time

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.yearsExperience,
    required this.slots,
  });
}

class Appointment {
  final Doctor doctor;
  final DateTime start;
  final String reason;
  const Appointment({required this.doctor, required this.start, required this.reason});
}
