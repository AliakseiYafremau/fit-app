import 'package:fit_app/domain/entities/exercise.dart';

import 'id.dart';


/// Выполненный подход упражнения в тренировочной сессии.
/// 
/// Содержит информацию о количестве повторений и весе (если применимо).
class WorkoutSet {
  final Id id;
  final Exercise exercise;
  final int repetitions;
  final double? weight;

  WorkoutSet({
    required this.id,
    required this.exercise,
    required this.repetitions,
    this.weight,
  }) {
    if (repetitions <= 0) {
      throw ArgumentError('Repetitions must be greater than zero');
    }
    if (weight != null && weight! < 0) {
      throw ArgumentError('Weight cannot be negative');
    }
  }
}


/// Запланированный подход упражнения в тренировке.
/// 
/// Содержит информацию о целевых повторениях и весе (если применимо).
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