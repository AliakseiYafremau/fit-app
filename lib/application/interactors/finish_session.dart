import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/session.dart';

class FinishSession {
  final SessionRepository sessionRepository;

  FinishSession({required this.sessionRepository});

  void execute(Id sessionId) {
    final session = sessionRepository.getById(sessionId);
    if (session == null) {
      throw ArgumentError('Session with id $sessionId not found');
    }
    if (!session.active) {
      return;
    }
    final updated = Session(
      id: session.id,
      training: session.training,
      workoutSets: session.workoutSets,
      active: false,
      startedAt: session.startedAt,
      finishedAt: DateTime.now(),
    );
    sessionRepository.update(updated);
  }
}
