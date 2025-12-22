import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/session.dart';

class DeleteWorkoutSet {
  DeleteWorkoutSet({
    required this.workoutSetRepository,
    required this.sessionRepository,
  });

  final WorkoutSetRepository workoutSetRepository;
  final SessionRepository sessionRepository;

  void execute(Id workoutSetId) {
    final session = sessionRepository.getByWorkoutId(workoutSetId);
    final filteredSets = session.workoutSets
        .where((set) => set.id != workoutSetId)
        .toList(growable: false);
    if (filteredSets.length == session.workoutSets.length) {
      return;
    }
    final updatedSession = Session(
      id: session.id,
      workoutSets: filteredSets,
      active: session.active,
      startedAt: session.startedAt,
      finishedAt: session.finishedAt,
    );
    sessionRepository.update(updatedSession);
    workoutSetRepository.delete(workoutSetId);
  }
}
