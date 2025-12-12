import 'package:fit_app/domain/entities/workout_set.dart';

import 'id.dart';
import 'training.dart';


/// Тренировочная сессия.
/// 
/// Состоит из выбранной тренировки (как база/план) и выполненных упражнений.
class Session {
  final Id id;
  final Training training;
  final List<WorkoutSet> workoutSets;

  Session({
    required this.id,
    required this.training,
    List<WorkoutSet>? workoutSets,
  }) : workoutSets = workoutSets ?? [];
}