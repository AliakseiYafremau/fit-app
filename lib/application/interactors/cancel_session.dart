import 'package:fit_app/application/interfaces/repo/session.dart';

class CancelSession {
  final SessionRepository sessionRepository;

  CancelSession({required this.sessionRepository});

  void execute() {
    final currentSession = sessionRepository.getActive();

    if (currentSession == null) {
      throw StateError('There is no active session');
    }

    sessionRepository.delete(currentSession.id);
  }
}