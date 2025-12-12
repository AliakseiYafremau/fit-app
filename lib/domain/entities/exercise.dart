import 'workout_set.dart';

import 'id.dart';


/// Упражнение в сессии.
/// 
/// Имеет ссылку на упражнение, которое выполняется и список выполненных подходов.
class WorkoutExercsie {
  final PlannedExercise exercise;
  final List<WorkoutSet> sets;

  WorkoutExercsie({
    required this.exercise,
    this.sets = const [],
  }) {
    final usesWeights = exercise.usesWeights;
    final hasInvalidSet = sets.any((set) {
      final weight = set.weight;
      if (usesWeights) {
        return weight == null;
      } else {
        return weight != null && weight != 0;
      }
    });

    if (hasInvalidSet) {
      throw ArgumentError(
        usesWeights
            ? 'Exercise "${exercise.name}" uses weights, all sets must have weight'
            : 'Exercise "${exercise.name}" does not use weights, sets must not include weight',
      );
    }
  }
}


/// Запланированное упражнение в тренировке.
/// 
/// Содержит информацию о самом упражнении и его характеристиках.
class PlannedExercise {
  final Id id;
  final String name;
  final String technique;
  final String notes;
  final bool usesWeights;
  final List<String> links;

  PlannedExercise({
    required this.id,
    required this.name,
    this.technique = '',
    this.notes = '',
    required this.usesWeights,
    this.links = const [],
  }) {
    if (name.trim().isEmpty) {
      throw ArgumentError('Exercise name cannot be empty');
    }
  }
}
