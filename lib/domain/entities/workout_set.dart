import 'package:fit_app/domain/entities/exercise.dart';
import 'package:fit_app/domain/entities/id.dart';


/// Completed set of an exercise within a training session.
///
/// Includes repetitions and optional weight.
class WorkoutSet {
  final Id id;
  final Exercise exercise;
  final int repetitions;
  final double? weight;
  final bool done;

  WorkoutSet({
    required this.id,
    required this.exercise,
    required this.repetitions,
    this.weight,
    this.done = false,
  }) {
    if (repetitions <= 0) {
      throw ArgumentError('Repetitions must be greater than zero');
    }
    if (weight != null && weight! < 0) {
      throw ArgumentError('Weight cannot be negative');
    }
    if (done && weight == null && exercise.usesWeights) {
      throw ArgumentError('Weight is required for exercises that use weights');
    }
    if (!exercise.usesWeights && !(weight == null)) {
      throw ArgumentError('Exercise does not require weight');
    }
  }
}


/// Planned set that belongs to a training.
///
/// Stores target repetitions and optional weight.
class PlannedSet {
  final Id id;
  final Exercise exercise;
  final int targetRepetitions;

  PlannedSet({
    required this.id,
    required this.exercise,
    required this.targetRepetitions,
  }) {
    if (targetRepetitions <= 0) {
      throw ArgumentError('Target repetitions must be greater than zero');
    }
  }
}
