import 'package:fit_app/application/interfaces/repo/session.dart';
import 'package:fit_app/application/interfaces/repo/training.dart';
import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';

class DeleteTraining {
  final TrainingRepository trainingRepository;
  final PlannedSetRepository plannedSetRepository;
  final SessionRepository sessionRepository;
  final WorkoutSetRepository workoutSetRepository;

  DeleteTraining({
    required this.trainingRepository,
    required this.plannedSetRepository,
    required this.sessionRepository,
    required this.workoutSetRepository,
  });

  void execute(Id trainingId) {
    final training = trainingRepository.getById(trainingId);
    if (training == null) {
      throw ArgumentError('Training with id $trainingId not found');
    }

    for (var plannedSet in training.plannedSets) {
      plannedSetRepository.delete(plannedSet.id);
    }

    final sessions = sessionRepository.getByTrainingId(trainingId);
    for (final session in sessions) {
      for (final workoutSet in session.workoutSets) {
        workoutSetRepository.delete(workoutSet.id);
      }
      sessionRepository.delete(session.id);
    }

    trainingRepository.delete(trainingId);
  }
}
