import 'package:fit_app/domain/entities/workout_set.dart';
import 'package:fit_app/domain/entities/id.dart';
import 'package:fit_app/domain/entities/training.dart';


/// Training session entity.
///
/// Uses a base training plan and stores completed exercises for that session.
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
