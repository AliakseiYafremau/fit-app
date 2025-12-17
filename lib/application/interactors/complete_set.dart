import 'package:fit_app/application/interfaces/repo/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/workout_set.dart';

class CompleteSet {
  final WorkoutSetRepository workoutSetRepository;

  CompleteSet({required this.workoutSetRepository});

  void execute({
    required Id workoutSetId,
    required int repetitions,
    double? weight,
  }) {
    final set = workoutSetRepository.getById(workoutSetId);
    if (set == null) {
      throw ArgumentError('Workout set with id $workoutSetId not found');
    }
    if (repetitions <= 0) {
      throw ArgumentError('Repetitions must be greater than zero');
    }
    final effectiveWeight = weight ?? set.weight;
    if (set.exercise.usesWeights && effectiveWeight == null) {
      throw ArgumentError('Weight is required for weighted exercises');
    }
    final updated = WorkoutSet(
      id: set.id,
      exercise: set.exercise,
      repetitions: repetitions,
      weight: effectiveWeight,
      done: true,
    );
    workoutSetRepository.update(updated);
  }
}
