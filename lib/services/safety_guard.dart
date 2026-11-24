/// Safety layer that runs BEFORE any message reaches the language model.
///
/// A health chatbot must never try to handle an emergency itself. If the text
/// looks urgent we skip the model and show fixed, reviewed copy instead.
class SafetyGuard {
  static const _emergencyTerms = [
    'chest pain',
    'can\'t breathe',
    'cannot breathe',
    'difficulty breathing',
    'severe bleeding',
    'suicide',
    'kill myself',
    'overdose',
    'stroke',
    'unconscious',
  ];

  static const emergencyReply =
      'This could be an emergency. Please call your local emergency number '
      '(in Egypt: 123) or go to the nearest emergency room now. '
      'I can\'t help with urgent symptoms.';

  static const disclaimer =
      'Luma Assistant gives general information only. It is not a doctor and '
      'cannot diagnose. For medical advice, book an appointment.';

  static const unavailableReply =
      'I\'m having trouble answering right now. You can still book a visit with '
      'one of our doctors from the Doctors tab.';

  static bool isEmergency(String text) {
    final t = text.toLowerCase();
    return _emergencyTerms.any(t.contains);
  }
}
