import 'id.dart';
import 'training.dart';
import 'exercise.dart';


/// Тренировочная сессия.
/// 
/// Состоит из выбранной тренировки (как база/план) и выполненных упражнений.
class Session {
  final Id id;
  final Training training;
  final List<WorkoutExercsie> workoutExercsies;

  Session({
    required this.id,
    required this.training,
    List<WorkoutExercsie>? workoutExercsies,
  }) : workoutExercsies = workoutExercsies ?? [];
}