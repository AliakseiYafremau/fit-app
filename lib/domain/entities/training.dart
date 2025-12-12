import 'package:fit_app/domain/entities/exercise.dart';

import 'id.dart';


/// Тренировка.
/// 
/// Состоит из набора предлагаемых упражнений.
class Training {
  final Id id;
  final String name;
  final List<PlannedExercise> exercises;

  Training({
    required this.id,
    required this.name,
    List<PlannedExercise>? exercises,
  }) : exercises = exercises ?? [] {
    if (name.trim().isEmpty) {
      throw ArgumentError('Training name cannot be empty');
    }
  }
} 