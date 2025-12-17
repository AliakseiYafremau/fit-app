import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

class UndoCompleteSet {
  final WorkoutSetRepository workoutSetRepository;

  UndoCompleteSet({required this.workoutSetRepository});

  void execute({required Id workoutSetId}) {
    final set = workoutSetRepository.getById(workoutSetId);
    if (set == null) {
      throw ArgumentError('Workout set with id $workoutSetId not found');
    }
    if (!set.done) {
      return;
    }

    final reverted = WorkoutSet(
      id: set.id,
      exercise: set.exercise,
      repetitions: set.repetitions,
      weight: set.exercise.usesWeights ? set.weight : null,
      done: false,
    );
    workoutSetRepository.update(reverted);
  }
}
